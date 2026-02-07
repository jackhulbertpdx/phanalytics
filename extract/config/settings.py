"""Configuration settings for the extraction pipeline."""
import os
from pathlib import Path
from typing import Optional
from dotenv import load_dotenv

# Load .env file from project root
env_path = Path(__file__).parent.parent.parent / '.env'
load_dotenv(dotenv_path=env_path)


class Settings:
    """Configuration settings loaded from environment variables."""

    # API Keys
    PHISH_NET_API_KEY: str = os.getenv("PHISH_NET_API_KEY", "")
    MOTHERDUCK_TOKEN: str = os.getenv("MOTHERDUCK_TOKEN", "")

    # Database settings
    MOTHERDUCK_DATABASE: str = os.getenv("MOTHERDUCK_DATABASE", "phanalytics_dev")
    MOTHERDUCK_SCHEMA: str = os.getenv("MOTHERDUCK_SCHEMA", "dev_t0_raw")

    # API settings
    PHISH_NET_BASE_URL: str = "https://api.phish.net/v5"

    # Logging
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")

    @classmethod
    def validate(cls) -> None:
        """Validate that required settings are present."""
        if not cls.PHISH_NET_API_KEY:
            raise ValueError("PHISH_NET_API_KEY environment variable is required")
        if not cls.MOTHERDUCK_TOKEN:
            raise ValueError("MOTHERDUCK_TOKEN environment variable is required")


settings = Settings()
