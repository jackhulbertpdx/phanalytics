"""Main extraction script for Phish.net data."""
import logging
import sys
from typing import List
from config.settings import settings
from phish_api.client import PhishNetAPIClient
from phish_api.loader import MotherDuckLoader

# Configure logging
logging.basicConfig(
    level=getattr(logging, settings.LOG_LEVEL),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)


def extract_and_load() -> None:
    """Extract data from Phish.net API and load into MotherDuck."""
    # Validate settings
    try:
        settings.validate()
    except ValueError as e:
        logger.error(f"Configuration error: {e}")
        sys.exit(1)

    # Initialize client and loader
    api_client = PhishNetAPIClient(
        api_key=settings.PHISH_NET_API_KEY,
        base_url=settings.PHISH_NET_BASE_URL
    )

    loader = MotherDuckLoader(
        token=settings.MOTHERDUCK_TOKEN,
        database=settings.MOTHERDUCK_DATABASE,
        schema=settings.MOTHERDUCK_SCHEMA
    )

    try:
        # Connect to MotherDuck
        loader.connect()

        # Extract and load each endpoint
        logger.info("=" * 80)
        logger.info("Starting Phish.net data extraction")
        logger.info("=" * 80)

        # 1. Shows
        logger.info("\n[1/9] Extracting shows...")
        shows = api_client.get_shows()
        loader.load_data_from_dict("phish_shows", shows)

        # 2. Songs
        logger.info("\n[2/9] Extracting songs...")
        songs = api_client.get_songs()
        loader.load_data_from_dict("phish_songs", songs)

        # 3. Venues
        logger.info("\n[3/9] Extracting venues...")
        venues = api_client.get_venues()
        loader.load_data_from_dict("phish_venues", venues)

        # 4. Artists
        logger.info("\n[4/9] Extracting artists...")
        artists = api_client.get_artists()
        loader.load_data_from_dict("phish_artists", artists)

        # 5. Attendance (using uid=2 as in the YAML)
        logger.info("\n[5/9] Extracting attendance...")
        attendance = api_client.get_attendance(uid=2)
        loader.load_data_from_dict("phish_attendance", attendance)

        # 6. Reviews (depends on shows)
        logger.info("\n[6/9] Extracting reviews...")
        show_ids = [str(show.get("showid")) for show in shows if show.get("showid")]
        logger.info(f"Fetching reviews for {len(show_ids)} shows...")
        reviews = api_client.get_reviews(show_ids[:100])  # Limit to first 100 to avoid rate limits
        loader.load_data_from_dict("phish_reviews", reviews)

        # 7. Setlists
        logger.info("\n[7/9] Extracting setlists...")
        setlists = api_client.get_setlists()
        loader.load_data_from_dict("phish_setlists", setlists)

        # 8. Song metadata
        logger.info("\n[8/9] Extracting song metadata...")
        song_metadata = api_client.get_song_metadata()
        loader.load_data_from_dict("phish_song_metadata", song_metadata)

        # 9. Jamcharts
        logger.info("\n[9/9] Extracting jamcharts...")
        jamcharts = api_client.get_jamcharts()
        loader.load_data_from_dict("phish_jamcharts", jamcharts)

        logger.info("\n" + "=" * 80)
        logger.info("Extraction completed successfully!")
        logger.info("=" * 80)

    except Exception as e:
        logger.error(f"Extraction failed: {e}", exc_info=True)
        sys.exit(1)
    finally:
        loader.close()


if __name__ == "__main__":
    extract_and_load()
