# searxng-local

A minimal local SearXNG instance running via Docker.

## Requirements

- Docker
- Docker Compose

## Usage

Start the instance (requires `SEARXNG_SECRET`):

```bash
export SEARXNG_SECRET="$(openssl rand -hex 32)"
./start.sh
```

Or manually:

```bash
export SEARXNG_SECRET="$(openssl rand -hex 32)"
docker compose up -d
```

SearXNG will be available at http://localhost:9009

## Endpoints

| Endpoint                                          | Description |
| ------------------------------------------------- | ----------- |
| `http://localhost:9009`                           | Web UI      |
| `http://localhost:9009/search?q=test&format=json` | JSON API    |

## Configuration

Settings are in `searxng/settings.yml`. The instance uses SearXNG defaults and overrides only the following:

**Search settings:**

- Safe search: moderate (level 1)
- Output formats: HTML, JSON

To learn more about other settings go to [this link](https://docs.searxng.org/admin/index.html).
