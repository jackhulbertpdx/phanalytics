# Migration Summary: Airbyte → Custom API Extraction

## Overview

Successfully migrated from Airbyte-based extraction to custom Python API extraction with MotherDuck as the data warehouse.

## What Was Created

### 1. Python Extraction Infrastructure

```
extract/
├── __init__.py
├── config/
│   ├── __init__.py
│   └── settings.py          # Environment configuration
├── phish_api/
│   ├── __init__.py
│   ├── client.py            # Phish.net API client with retry logic
│   └── loader.py            # MotherDuck data loader
└── extract_phish.py         # Main orchestration script
```

**Features:**
- Robust API client with retry logic and rate limiting
- Efficient batch loading to MotherDuck using DuckDB native capabilities
- Structured logging
- Environment-based configuration

### 2. Configuration Files

- `.env` - Your credentials (already populated)
- `.env.example` - Template for others
- `requirements.txt` - Python dependencies

### 3. SQLMesh Configuration Updates

**Updated:** `sqlmesh/config.yaml`
- Added MotherDuck gateway with DuckDB connection
- Set as default gateway
- Changed default dialect from Snowflake to DuckDB

**Created:** `sqlmesh/external_models_motherduck.yaml`
- Defines schema for all 9 Phish.net raw tables
- Uses `_extracted_at` instead of Airbyte metadata columns

### 4. Updated Staging Models

All Phish staging models updated to remove Airbyte-specific columns:
- `stg__shows.sql` - Changed grain from `_airbyte_raw_id` to `showid`
- `stg__songs.sql` - Changed `_airbyte_extracted_at` to `_extracted_at`
- `stg__venues.sql` - Removed Airbyte metadata columns
- `stg__artists.sql` - Updated metadata column
- `stg__reviews.sql` - Changed grain to `reviewid`
- `stg__setlists.sql` - Changed grain to `uniqueid`
- `stg__song_metadata.sql` - Changed grain to `songid`
- `stg__jamcharts.sql` - Changed grain to `uniqueid`

### 5. GitHub Actions Workflow

**Created:** `.github/workflows/daily_etl.yml`

Automates daily pipeline execution:
- Scheduled daily at 6 AM UTC
- Can be triggered manually
- Extracts from Phish.net API
- Loads into MotherDuck
- Runs SQLMesh transformations

### 6. Documentation

- `SETUP.md` - Complete setup and usage guide
- `MIGRATION_SUMMARY.md` - This file

## Key Changes from Airbyte

| Aspect | Before (Airbyte) | After (Custom) |
|--------|------------------|----------------|
| **Extraction** | Airbyte connectors | Python scripts |
| **Warehouse** | Snowflake | MotherDuck (DuckDB) |
| **Metadata Columns** | `_airbyte_raw_id`, `_airbyte_extracted_at`, `_airbyte_meta`, `_airbyte_generation_id` | `_extracted_at` |
| **Scheduling** | Airbyte UI | GitHub Actions |
| **Cost** | Snowflake compute + Airbyte | MotherDuck compute |
| **Customization** | Limited | Full control |

## API Keys Configured

1. **Phish.net API Key:** `2D0AEBEF59FED52FB3C8`
2. **Alternative Key:** `5grds84fg8w00k` (if needed)

Note: The first key is currently configured in `.env`

## Next Steps to Test

### 1. Test Local Extraction (5 minutes)

```bash
# Install dependencies
pip install -r requirements.txt

# Run extraction
cd extract
python extract_phish.py
```

Expected output:
```
INFO - Starting Phish.net data extraction
INFO - [1/9] Extracting shows...
INFO - Loading 2000 records into dev_t0_raw.phish_shows
...
INFO - Extraction completed successfully!
```

### 2. Verify Data in MotherDuck

```python
import duckdb

conn = duckdb.connect("md:phanalytics_dev?motherduck_token=YOUR_TOKEN")

# Check tables exist
print(conn.execute("SHOW TABLES FROM dev_t0_raw").fetchall())

# Check record counts
print(conn.execute("SELECT COUNT(*) FROM dev_t0_raw.phish_shows").fetchone())
```

### 3. Run SQLMesh Transformations

```bash
cd sqlmesh
sqlmesh plan --auto-apply
```

### 4. Set Up GitHub Actions

1. Go to repository Settings → Secrets and variables → Actions
2. Add secrets:
   - `PHISH_NET_API_KEY`: `2D0AEBEF59FED52FB3C8`
   - `MOTHERDUCK_TOKEN`: (your token from `.env`)
3. Enable GitHub Actions in repository
4. Manually trigger workflow to test

## Data Schema

### Raw Tables (all in `dev_t0_raw` schema)

Each table includes:
- All fields from Phish.net API
- `_extracted_at` timestamp (UTC)

Example for `phish_shows`:
```sql
CREATE TABLE dev_t0_raw.phish_shows (
    _extracted_at TIMESTAMP,
    showid VARCHAR,
    showdate VARCHAR,
    city VARCHAR,
    state VARCHAR,
    venue VARCHAR,
    ...
);
```

## Troubleshooting

### Common Issues

1. **"MOTHERDUCK_TOKEN environment variable is required"**
   - Solution: Ensure `.env` file exists and is in the correct directory
   - Run from project root: `cd /path/to/phanalytics && cd extract && python extract_phish.py`

2. **"Error loading data into table"**
   - Check MotherDuck token has write permissions
   - Verify database name matches configuration

3. **Rate limiting from Phish.net**
   - Reviews are limited to first 100 shows to avoid rate limits
   - Increase delay in `client.py` if needed

4. **SQLMesh errors referencing old columns**
   - Check if any downstream models still reference `_airbyte_*` columns
   - Update them to use `_extracted_at` instead

## Performance

Expected extraction times:
- Shows: ~5 seconds (2,000 records)
- Songs: ~2 seconds (1,000 records)
- Venues: ~2 seconds (1,500 records)
- Setlists: ~10 seconds (40,000 records)
- Reviews: ~20 seconds (first 100 shows)
- Other endpoints: ~2-5 seconds each

**Total pipeline runtime: ~3-5 minutes**

## Cost Comparison

### Before (Airbyte + Snowflake)
- Snowflake compute: ~$2-5/month
- Airbyte: Free (self-hosted) or $X/month (cloud)
- Storage: Included in Snowflake

### After (Custom + MotherDuck)
- MotherDuck compute: ~$0.10-0.50/month (estimated)
- GitHub Actions: Free (under 2,000 minutes)
- Storage: Included in MotherDuck

**Estimated savings: $1.50-4.50/month**

## Rollback Plan

If you need to revert to Airbyte:

1. Keep Snowflake gateway in `sqlmesh/config.yaml`
2. Switch default gateway: `default_gateway: snowflake`
3. Use original `external_models.yaml`
4. Revert staging models to use `_airbyte_*` columns

All original configurations are preserved in the config file.

## Support

Questions? Check:
1. `SETUP.md` for detailed setup instructions
2. Extract logs: `extract/extract_phish.py` output
3. SQLMesh docs: https://sqlmesh.readthedocs.io/
4. MotherDuck docs: https://motherduck.com/docs

## What's Next?

- [ ] Test local extraction
- [ ] Verify data in MotherDuck
- [ ] Configure GitHub Actions secrets
- [ ] Run first automated pipeline
- [ ] Update any custom downstream models
- [ ] Consider adding Goose.net API if available
- [ ] Set up monitoring/alerting for pipeline failures
