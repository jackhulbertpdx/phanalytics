"""Database loader for Phish.net data."""
import logging
from datetime import datetime
from typing import Any, Dict, List
import duckdb
import pandas as pd

logger = logging.getLogger(__name__)


class MotherDuckLoader:
    """Loader for inserting data into MotherDuck."""

    def __init__(self, token: str, database: str, schema: str):
        """Initialize the loader.

        Args:
            token: MotherDuck authentication token
            database: Database name
            schema: Schema name
        """
        self.token = token
        self.database = database
        self.schema = schema
        self.connection = None

    def connect(self) -> None:
        """Connect to MotherDuck."""
        logger.info("Connecting to MotherDuck")

        # First, connect to MotherDuck without specifying a database
        connection_string = f"md:?motherduck_token={self.token}"
        self.connection = duckdb.connect(connection_string)

        # Create database if it doesn't exist
        logger.info(f"Creating database {self.database} if it doesn't exist")
        self.connection.execute(f"CREATE DATABASE IF NOT EXISTS {self.database}")

        # Use the database
        self.connection.execute(f"USE {self.database}")

        # Create schema if it doesn't exist
        self.connection.execute(f"CREATE SCHEMA IF NOT EXISTS {self.schema}")
        logger.info(f"Connected to MotherDuck database: {self.database}, schema: {self.schema}")

    def close(self) -> None:
        """Close the connection."""
        if self.connection:
            self.connection.close()
            logger.info("Closed MotherDuck connection")

    def load_data(self, table_name: str, data: List[Dict[str, Any]], primary_key: str) -> int:
        """Load data into a table.

        Args:
            table_name: Target table name
            data: List of records to insert
            primary_key: Primary key column name

        Returns:
            Number of records inserted
        """
        if not data:
            logger.warning(f"No data to load for {table_name}")
            return 0

        full_table_name = f"{self.schema}.{table_name}"
        extracted_at = datetime.utcnow().isoformat()

        # Add metadata columns
        for record in data:
            record["_extracted_at"] = extracted_at

        logger.info(f"Loading {len(data)} records into {full_table_name}")

        try:
            # Create or replace table
            self.connection.execute(f"DROP TABLE IF EXISTS {full_table_name}")
            self.connection.execute(
                f"CREATE TABLE {full_table_name} AS SELECT * FROM (VALUES {self._build_values_placeholder(data[0])}) AS t {self._build_column_names(data[0])}"
            )

            # Use DuckDB's efficient batch insert
            self.connection.executemany(
                f"INSERT INTO {full_table_name} VALUES ({self._build_insert_placeholder(data[0])})",
                [tuple(record.values()) for record in data]
            )

            logger.info(f"Successfully loaded {len(data)} records into {full_table_name}")
            return len(data)
        except Exception as e:
            logger.error(f"Error loading data into {full_table_name}: {e}")
            raise

    def load_data_from_dict(self, table_name: str, data: List[Dict[str, Any]]) -> int:
        """Load data from a list of dictionaries using DuckDB's native support.

        Args:
            table_name: Target table name
            data: List of records to insert

        Returns:
            Number of records inserted
        """
        if not data:
            logger.warning(f"No data to load for {table_name}")
            return 0

        full_table_name = f"{self.schema}.{table_name}"
        extracted_at = datetime.utcnow().isoformat()

        # Add metadata column
        for record in data:
            record["_extracted_at"] = extracted_at

        logger.info(f"Loading {len(data)} records into {full_table_name}")

        try:
            # Drop existing table
            self.connection.execute(f"DROP TABLE IF EXISTS {full_table_name}")

            # Convert list of dicts to pandas DataFrame
            df = pd.DataFrame(data)

            # Register the DataFrame as a DuckDB relation and create the table from it
            self.connection.register('temp_data', df)
            self.connection.execute(f"CREATE TABLE {full_table_name} AS SELECT * FROM temp_data")
            self.connection.unregister('temp_data')

            row_count = self.connection.execute(f"SELECT COUNT(*) FROM {full_table_name}").fetchone()[0]
            logger.info(f"Successfully loaded {row_count} records into {full_table_name}")
            return row_count
        except Exception as e:
            logger.error(f"Error loading data into {full_table_name}: {e}")
            raise

    def _build_values_placeholder(self, record: Dict[str, Any]) -> str:
        """Build a VALUES placeholder string."""
        placeholders = ", ".join(["?" for _ in record])
        return f"({placeholders})"

    def _build_insert_placeholder(self, record: Dict[str, Any]) -> str:
        """Build an INSERT placeholder string."""
        return ", ".join(["?" for _ in record])

    def _build_column_names(self, record: Dict[str, Any]) -> str:
        """Build column names string."""
        columns = ", ".join(record.keys())
        return f"({columns})"
