# phanalytics.dev

A comprehensive analytics platform for exploring and visualizing data from the jamband scene, specifically focusing on Phish and Goose. This application combines data from phish.net, elgoose.net, and Spotify to provide insights into shows, setlists, song metadata, and streaming analytics.

## Overview

phanalytics.dev is a modern data stack application that processes and analyzes concert and streaming data using:
- Airbyte for data integration
- Snowflake for data warehousing
- SQLMesh for data transformation
- Evidence.dev for data visualization and presentation

## Architecture

```
phish.net API ──┐
elgoose.net API ├─ Airbyte ─→ Snowflake ─→ SQLMesh ─→ Evidence.dev ─→ Web Interface
Spotify API ────┘
```

## Features

- Historical show data and statistics
- Setlist analysis and pattern recognition
- Song frequency and placement analytics
- Cross-band comparisons and insights
- Interactive visualizations and dashboards
- Spotify streaming statistics and analysis
- Audio feature analysis (tempo, key, time signature)
- Popularity trends and listening patterns

## Technical Components

### Data Integration (Airbyte)

The application uses Airbyte to extract data from:
- phish.net API: Show data, setlists, and song information for Phish
- elgoose.net API: Similar data points for Goose
- Spotify API: Streaming data, audio features, and popularity metrics

### Data Storage (Snowflake)

Raw data is stored in Snowflake with the following schema structure:
- `RAW_SHOWS`: Concert metadata and basic information
- `RAW_SETLISTS`: Detailed setlist information
- `RAW_SONGS`: Song-specific metadata and statistics
- `RAW_SPOTIFY`: Streaming data and audio features

### Data Transformation (SQLMesh)

SQLMesh models in `/models` directory transform raw data into analytics-ready tables:
- Show statistics and metrics
- Song playing patterns and frequencies
- Cross-band comparative analytics
- Spotify streaming analytics and trends
- Audio feature analysis and correlations

### Visualization (Evidence.dev)

The `/pages` directory contains Evidence.dev pages for:
- Show Explorer
- Song Statistics
- Setlist Analysis
- Comparative Analytics
- Streaming Analytics
- Audio Features Dashboard


## License

MIT License - see LICENSE file for details
