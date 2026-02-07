"""Phish.net API client."""
import logging
import time
from typing import Any, Dict, List, Optional
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

logger = logging.getLogger(__name__)


class PhishNetAPIClient:
    """Client for interacting with the Phish.net API."""

    def __init__(self, api_key: str, base_url: str = "https://api.phish.net/v5"):
        """Initialize the API client.

        Args:
            api_key: Phish.net API key
            base_url: Base URL for the API
        """
        self.api_key = api_key
        self.base_url = base_url
        self.session = self._create_session()

    def _create_session(self) -> requests.Session:
        """Create a requests session with retry logic."""
        session = requests.Session()
        retry = Retry(
            total=3,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry)
        session.mount("http://", adapter)
        session.mount("https://", adapter)
        return session

    def _make_request(self, endpoint: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Make a request to the API.

        Args:
            endpoint: API endpoint
            params: Optional query parameters

        Returns:
            API response as dictionary
        """
        if params is None:
            params = {}

        params["apikey"] = self.api_key
        url = f"{self.base_url}/{endpoint}"

        logger.info(f"Fetching data from {endpoint}")

        try:
            response = self.session.get(url, params=params, timeout=30)
            response.raise_for_status()
            data = response.json()

            if "data" not in data:
                logger.warning(f"No 'data' field in response from {endpoint}")
                return {"data": []}

            return data
        except requests.exceptions.RequestException as e:
            logger.error(f"Error fetching data from {endpoint}: {e}")
            raise

    def get_shows(self, artist: str = "phish", order_by: str = "showdate") -> List[Dict[str, Any]]:
        """Fetch shows for an artist.

        Args:
            artist: Artist name
            order_by: Field to order by

        Returns:
            List of show records
        """
        endpoint = f"shows/artist/{artist}.json"
        params = {"order_by": order_by}
        response = self._make_request(endpoint, params)
        return response.get("data", [])

    def get_songs(self) -> List[Dict[str, Any]]:
        """Fetch all songs.

        Returns:
            List of song records
        """
        endpoint = "songs.json"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_venues(self) -> List[Dict[str, Any]]:
        """Fetch all venues.

        Returns:
            List of venue records
        """
        endpoint = "venues.json"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_attendance(self, uid: int = 2) -> List[Dict[str, Any]]:
        """Fetch attendance records for a user.

        Args:
            uid: User ID

        Returns:
            List of attendance records
        """
        endpoint = f"attendance/uid/{uid}.json"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_reviews(self, show_ids: List[str]) -> List[Dict[str, Any]]:
        """Fetch reviews for shows.

        Args:
            show_ids: List of show IDs

        Returns:
            List of review records
        """
        all_reviews = []

        for show_id in show_ids:
            endpoint = f"reviews/showid/{show_id}.json"
            try:
                response = self._make_request(endpoint)
                reviews = response.get("data", [])
                all_reviews.extend(reviews)
                time.sleep(0.1)  # Rate limiting
            except requests.exceptions.RequestException as e:
                logger.warning(f"Failed to fetch reviews for show {show_id}: {e}")
                continue

        return all_reviews

    def get_setlists(self) -> List[Dict[str, Any]]:
        """Fetch setlists.

        Returns:
            List of setlist records
        """
        endpoint = "setlists"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_song_metadata(self) -> List[Dict[str, Any]]:
        """Fetch song metadata.

        Returns:
            List of song metadata records
        """
        endpoint = "songdata"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_jamcharts(self) -> List[Dict[str, Any]]:
        """Fetch jamcharts.

        Returns:
            List of jamchart records
        """
        endpoint = "jamcharts"
        response = self._make_request(endpoint)
        return response.get("data", [])

    def get_artists(self) -> List[Dict[str, Any]]:
        """Fetch all artists.

        Returns:
            List of artist records
        """
        endpoint = "artists.json"
        response = self._make_request(endpoint)
        return response.get("data", [])
