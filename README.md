# SearXNG local setup

A minimal local SearXNG instance running via Docker or [Apple Container](https://github.com/apple/container).

## Requirements

### Docker

- Docker
- Docker Compose

### Apple Container

- macOS on Apple silicon
- [Apple Container](https://github.com/apple/container/releases) CLI (`container` command)

## Usage

Before starting you will need to set `SEARXNG_SECRET`. The simplest way is the following:

```bash
export SEARXNG_SECRET="$(openssl rand -hex 32)"
```

You can start, stop, or restart SearXNG with the following commands (`SEARXNG_SECRET` is required for start and restart):

```bash
# Running with Docker
./searxng docker start
./searxng docker stop
./searxng docker restart

# Running with Apple Container
./searxng ac start
./searxng ac stop
./searxng ac restart
```

SearXNG will be available on [localhost:9009](http://localhost:9009)

## Resource usage

To check resource usage you can run the following commands:

```bash
# Docker
container docker --no-stream my-container
# Container
container stats --no-stream searxng
```

## Endpoints

| Endpoint                                              | Description |
| ----------------------------------------------------- | ----------- |
| `http://localhost:9009`                               | Web UI      |
| `http://localhost:9009/search?q=<string>&format=json` | JSON API    |

## Configuration

Settings live in `config/settings.yml` and are mounted into the container at `/etc/searxng`. The file sets `use_default_settings: true`, so SearXNG defaults apply unless explicitly overridden.

**General & server:**

- Instance name: `SearXNG`
- Rate limiter: disabled
- Image proxy: disabled

**Search:**

- Safe search: moderate (level 1)
- Autocomplete: DuckDuckGo
- Favicon resolver: DuckDuckGo
- Default language: auto
- Output formats: HTML, JSON

**UI:**

- Default locale: English

**Outgoing:**

- Default DOI resolver: `doi.org`

**Engines:**

Engines are curated for local development and research. General web search (DuckDuckGo, Google, Qwant), code and package registries (GitLab, npm, pkg.go.dev), documentation (Wikipedia, DBpedia), and a few specialty sources (Hugging Face, Ollama, Steam) are enabled. Social, media, torrent, and niche engines are disabled.

Edit `config/settings.yml` to enable or disable individual engines, then restart SearXNG for changes to take effect.

For all available options, see the [SearXNG admin documentation](https://docs.searxng.org/admin/index.html).
