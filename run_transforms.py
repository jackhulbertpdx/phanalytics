"""Run SQLMesh transformations directly using DuckDB."""
import duckdb
import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment
load_dotenv()

TOKEN = os.getenv("MOTHERDUCK_TOKEN")
DATABASE = os.getenv("MOTHERDUCK_DATABASE", "phanalytics_dev")

print("=" * 80)
print("Running Phish Data Transformations")
print("=" * 80)

# Connect to MotherDuck
conn = duckdb.connect(f"md:{DATABASE}?motherduck_token={TOKEN}")

# Create schemas
print("\n[1/3] Creating schemas...")
conn.execute("CREATE SCHEMA IF NOT EXISTS dev_t1_staging")
conn.execute("CREATE SCHEMA IF NOT EXISTS dev_t2_edw")
conn.execute("CREATE SCHEMA IF NOT EXISTS dev_t3_presentation")
print("✓ Schemas created")

# List of Phish-only staging models
staging_models = [
    "stg__shows",
    "stg__songs",
    "stg__venues",
    "stg__artists",
    "stg__reviews",
    "stg__setlists",
    "stg__song_metadata",
    "stg__jamcharts"
]

# Run staging transformations
print("\n[2/3] Running staging layer transformations...")
model_dir = Path("sqlmesh/models")

for model in staging_models:
    model_file = model_dir / "staging" / "phish" / f"{model}.sql"
    if model_file.exists():
        print(f"  Processing {model}...")

        # Read the SQL file
        with open(model_file, 'r') as f:
            sql = f.read()

        # Extract the SELECT statement (skip the MODEL definition)
        sql_lines = sql.split('\n')
        select_start = None
        for i, line in enumerate(sql_lines):
            if line.strip().lower().startswith('with') or line.strip().lower().startswith('select'):
                select_start = i
                break

        if select_start:
            query = '\n'.join(sql_lines[select_start:])

            # Create the staging table
            table_name = f"dev_t1_staging.{model}"
            create_sql = f"CREATE OR REPLACE TABLE {table_name} AS\n{query}"

            try:
                conn.execute(create_sql)
                count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
                print(f"    ✓ Created {table_name} ({count:,} rows)")
            except Exception as e:
                print(f"    ✗ Error creating {table_name}: {e}")

# Run EDW transformations
print("\n[3/3] Running EDW layer transformations...")

edw_models = [
    ("dim_phish_songs", "edw/dim_phish_songs.sql"),
    ("fct_shows", "edw/fct_shows.sql"),
    ("fct_sets", "edw/fct_sets.sql"),
    ("fct_reviews", "edw/fct_reviews.sql")
]

for model_name, model_path in edw_models:
    model_file = model_dir / model_path
    if model_file.exists():
        print(f"  Processing {model_name}...")

        with open(model_file, 'r') as f:
            sql = f.read()

        # Extract the SELECT statement
        sql_lines = sql.split('\n')
        select_start = None
        for i, line in enumerate(sql_lines):
            if line.strip().lower().startswith('with') or line.strip().lower().startswith('select'):
                select_start = i
                break

        if select_start:
            query = '\n'.join(sql_lines[select_start:])

            # Create the EDW table
            table_name = f"dev_t2_edw.{model_name}"
            create_sql = f"CREATE OR REPLACE TABLE {table_name} AS\n{query}"

            try:
                conn.execute(create_sql)
                count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
                print(f"    ✓ Created {table_name} ({count:,} rows)")
            except Exception as e:
                print(f"    ✗ Error creating {table_name}: {e}")

# Run presentation layer transformations
print("\n[4/4] Running presentation layer transformations...")

pres_models = [
    ("phish_songs", "presentation/phish_songs.sql"),
    ("phish_sets", "presentation/phish_sets.sql"),
    ("phish_reviews", "presentation/phish_reviews.sql"),
    ("phish_similar_shows", "presentation/phish_similar_shows.sql")
]

for model_name, model_path in pres_models:
    model_file = model_dir / model_path
    if model_file.exists():
        print(f"  Processing {model_name}...")

        with open(model_file, 'r') as f:
            sql = f.read()

        # Extract the SELECT statement
        sql_lines = sql.split('\n')
        select_start = None
        for i, line in enumerate(sql_lines):
            if line.strip().lower().startswith('with') or line.strip().lower().startswith('select'):
                select_start = i
                break

        if select_start:
            query = '\n'.join(sql_lines[select_start:])

            # Create the presentation table
            table_name = f"dev_t3_presentation.{model_name}"
            create_sql = f"CREATE OR REPLACE TABLE {table_name} AS\n{query}"

            try:
                conn.execute(create_sql)
                count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
                print(f"    ✓ Created {table_name} ({count:,} rows)")
            except Exception as e:
                print(f"    ✗ Error creating {table_name}: {e}")

print("\n" + "=" * 80)
print("Transformations Complete!")
print("=" * 80)

# Show summary
print("\nSummary of created tables:")
for schema in ['dev_t1_staging', 'dev_t2_edw', 'dev_t3_presentation']:
    print(f"\n{schema}:")
    tables = conn.execute(f"SHOW TABLES FROM {schema}").fetchall()
    for table in tables:
        table_name = table[0]
        count = conn.execute(f"SELECT COUNT(*) FROM {schema}.{table_name}").fetchone()[0]
        print(f"  - {table_name}: {count:,} rows")

conn.close()
