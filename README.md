# ambient-weather-exporter
Prometheus exporter for an Ambient Weather station as reported from their API

This little project is a messy hack, but it works against my [WS-2902](https://www.ambientweather.com/amws2902.html) which I've had for just a few weeks at the time I'm writing this. It may not work well for stations which ship less metrics to Ambient Weather.

## Project Structure

```
ambient-weather-exporter/
├── src/                    # Source code
│   ├── main.py            # Entry point
│   ├── ambient_client.py  # Ambient Weather API client
│   ├── config_schema.json # Configuration schema validation
│   └── fields.yaml        # Field mapping configuration
├── test/                   # Test configuration
│   └── config.yaml        # Example configuration file
├── pyproject.toml         # Python project configuration
├── requirements.txt       # Python dependencies (auto-generated)
├── Dockerfile             # Container image definition
├── Makefile              # Build automation
└── README.md
```

## Libraries

Almost all of this code is just binding together two things:
* [ambient_api](https://github.com/avryhof/ambient_api) - a Python library which interfaces with the Ambient Weather API
* [prometheus/client_python](https://github.com/prometheus/client_python) - lets me register a series of metrics and runs a simple web server exposing the data read from Ambient as Prometheus metrics.

## Building

This project uses [uv](https://github.com/astral-sh/uv) for dependency management and a Makefile for build automation.

### Prerequisites
- [uv](https://github.com/astral-sh/uv) - Python package manager
- Docker (for container builds)

### Build Commands

- **Export dependencies**: Generate `requirements.txt` from `pyproject.toml`
  ```bash
  make export_deps
  ```

- **Build Docker image**: Build the container image
  ```bash
  make build
  ```

- **Push Docker image**: Build and push to registry
  ```bash
  make push
  ```

- **Run container locally**: Run the container with test configuration
  ```bash
  make run_container
  ```

The Docker image is built using `docker buildx` for multi-platform support (defaults to `linux/amd64`).

## Configuration

The exporter uses a YAML configuration file. See `test/config.yaml` for an example:

```yaml
tag: ambient-weather-exporter-config
poll_interval: 60
listen_port: 9000
ambient:
  api_key: <your-api-key>
  application_key: <your-application-key>
```

Configuration is validated against `src/config_schema.json` at runtime.

## How to Use

1. Get an API key and Application Key from Ambient Weather.
2. Create a configuration file (see `test/config.yaml` for an example).
3. Run with Docker:
   ```bash
   docker run -d --restart=unless-stopped \
     -v /path/to/config.yaml:/app/config/config.yaml \
     -p 9000:9000 \
     reedswenson/ambient-weather-exporter:latest
   ```

Or build and run locally:
```bash
make build
make run_container
```

Then configure Prometheus to scrape it every 60 seconds (or your configured `poll_interval`).

## What it looks like

[You came for a graph, so here's one](https://snapshot.raintank.io/dashboard/snapshot/XZJZDZlgPxQSaC6gP8pGKbuWsLmvGWYI) where you can clearly see that my weather station is not mounted properly (the wind is always coming from ~270 degrees?)

## Alternative approaches
Ideally, I'd rather get this data directly from the base station which sits in my house so that I'm not beholden to Ambient Weather's infrastructure. But I haven't found a way to do that.
