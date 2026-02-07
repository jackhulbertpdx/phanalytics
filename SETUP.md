# Phanalytics ETL Pipeline Setup Guide

This guide will help you set up and run the Phanalytics ETL pipeline that extracts data from Phish.net API, loads it into MotherDuck, and transforms it using SQLMesh.

## Architecture Overview

```
Phish.net API → Python Extractors → MotherDuck (DuckDB Cloud) → SQLMesh Transformations → Analytics Tables
```

## Prerequisites

- Python 3.11+
- MotherDuck account with API token
- Phish.net API key
- GitHub repository (for automated runs)

## Local Setup

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Environment Variables

Create a `.env` file in the project root:

```bash
# Copy the example file
cp .env.example .env
```

Edit `.env` with your credentials:

```bash
PHISH_NET_API_KEY=your_phish_net_api_key_here
MOTHERDUCK_TOKEN=your_motherduck_token_here
MOTHERDUCK_DATABASE=phanalytics_dev
MOTHERDUCK_SCHEMA=dev_t0_raw
LOG_LEVEL=INFO
```

### 3. Test the Extraction Pipeline

Run the extraction script to pull data from Phish.net and load into MotherDuck:

```bash
cd extract
python extract_phish.py
```

This will extract data from 9 endpoints:
1. Shows
2. Songs
3. Venues
4. Artists
5. Attendance
6. Reviews (first 100 shows)
7. Setlists
8. Song Metadata
9. Jamcharts

### 4. Run SQLMesh Transformations

```bash
cd sqlmesh
sqlmesh plan
```

Review the plan and apply:

```bash
sqlmesh plan --auto-apply
```

## GitHub Actions Setup (Daily Automation)

### 1. Configure GitHub Secrets

Go to your repository settings → Secrets and variables → Actions → New repository secret

Add the following secrets:

| Secret Name | Value |
|------------|-------|
| `PHISH_NET_API_KEY` | Your Phish.net API key |
| `MOTHERDUCK_TOKEN` | Your MotherDuck token |

### 2. Configure GitHub Variables (Optional)

If you want to customize database settings:

| Variable Name | Default Value | Description |
|--------------|---------------|-------------|
| `MOTHERDUCK_DATABASE` | `phanalytics_dev` | MotherDuck database name |
| `MOTHERDUCK_SCHEMA` | `dev_t0_raw` | Schema for raw tables |

### 3. Enable GitHub Actions

The workflow is configured to run daily at 6 AM UTC. You can also trigger it manually:

1. Go to Actions tab in your repository
2. Select "Daily Phish Data ETL Pipeline"
3. Click "Run workflow"

## API Endpoints Extracted

### Phish.net API v5

All endpoints use the base URL: `https://api.phish.net/v5`

| Endpoint | Table Name | Primary Key | Records |
|----------|-----------|-------------|---------|
| `/shows/artist/phish.json` | `phish_shows` | `showid` | ~2,000 |
| `/songs.json` | `phish_songs` | `songid` | ~1,000 |
| `/venues.json` | `phish_venues` | `venueid` | ~1,500 |
| `/artists.json` | `phish_artists` | `id` | ~10 |
| `/attendance/uid/2.json` | `phish_attendance` | `showid` | Varies |
| `/reviews/showid/{id}.json` | `phish_reviews` | `reviewid` | Limited |
| `/setlists` | `phish_setlists` | `uniqueid` | ~40,000 |
| `/songdata` | `phish_song_metadata` | `songid` | ~1,000 |
| `/jamcharts` | `phish_jamcharts` | `uniqueid` | ~1,000 |

## Data Flow

### Raw Layer (dev_t0_raw)
Tables loaded directly from API with minimal transformation:
- `phish_shows`
- `phish_songs`
- `phish_venues`
- `phish_artists`
- `phish_attendance`
- `phish_reviews`
- `phish_setlists`
- `phish_song_metadata`
- `phish_jamcharts`

All raw tables include a `_extracted_at` timestamp column.

### Staging Layer (DEV_T1_STAGING)
Clean and standardize raw data:
- `stg__shows`
- `stg__songs`
- `stg__venues`
- `stg__artists`
- `stg__reviews`
- `stg__setlists`
- `stg__song_metadata`
- `stg__jamcharts`

### EDW Layer (Enterprise Data Warehouse)
Dimensional and fact tables for analytics:
- Dimensions: `dim_phish_songs`, etc.
- Facts: `fct_shows`, `fct_sets`, `fct_reviews`

### Presentation Layer
User-facing analytics views:
- `phish_sets`
- `phish_songs`
- `phish_reviews`
- `phish_similar_shows`

## Troubleshooting

### Connection Issues

If you have trouble connecting to MotherDuck:

```python
import duckdb
conn = duckdb.connect(f"md:phanalytics_dev?motherduck_token=YOUR_TOKEN")
conn.execute("SHOW TABLES").fetchall()
```

### Rate Limiting

The Phish.net API has rate limits. The extractor includes:
- Retry logic with exponential backoff
- 100ms delay between review requests
- Limited to first 100 shows for reviews

### Missing Data

If tables are empty:
1. Check API key is valid
2. Verify MotherDuck token has write permissions
3. Check logs for error messages

## Monitoring

View extraction logs in GitHub Actions:
1. Go to Actions tab
2. Click on the latest workflow run
3. Expand "Extract data from Phish.net API" step

## Cost Considerations

- **Phish.net API**: Free tier available
- **MotherDuck**: Charges based on compute and storage
- **GitHub Actions**: 2,000 free minutes/month

The daily pipeline should complete in under 5 minutes.

## Next Steps

1. ✅ Verify raw data is loading correctly
2. ✅ Update staging models for your use case
3. Configure SQLMesh transformations
4. Build presentation layer analytics
5. Connect BI tools (Evidence, Tableau, etc.)

## Support

For issues with:
- **Phish.net API**: https://api.phish.net/
- **MotherDuck**: https://motherduck.com/docs
- **SQLMesh**: https://sqlmesh.readthedocs.io/
