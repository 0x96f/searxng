# SearXNG

A minimal SearXNG instance running via [Docker](https://www.docker.com/) or [Apple Container](https://github.com/apple/container).

## Requirements

### Docker

- [Docker](https://www.docker.com/)
- Docker Compose

### Apple Container

- macOS on Apple silicon
- [Apple Container](https://github.com/apple/container/releases) CLI (`container` command)

## Usage

Copy the example env file and set at least `SEARXNG_SECRET`:

```bash
cp .env.example .env
# edit .env - set SEARXNG_SECRET (e.g. openssl rand -hex 32)
```

The `./searxng` script loads `.env` automatically (shell-exported variables take precedence). Docker Compose also loads `.env` when you run `docker compose` directly.

You can start, stop, or restart SearXNG with the following commands (`SEARXNG_SECRET` is required for start and restart):

```bash
# Running with Docker
./searxng docker start
./searxng docker start --clean
./searxng docker stop
./searxng docker restart

# Running with Apple Container
./searxng ac start
./searxng ac start --clean
./searxng ac stop
./searxng ac restart
```

Use `--clean` on start to remove existing containers, images, and runtime data in `config/`, pull a fresh image, and start from scratch. Your `config/settings.yml` is preserved.

SearXNG will be available on [localhost:9009](http://localhost:9009)

### uWSGI workers and threads

`UWSGI_WORKERS` and `UWSGI_THREADS` default to `4`. Set them in `.env` (or export them) before start:

```bash
# in .env
UWSGI_WORKERS=8
UWSGI_THREADS=2
```

### Cloudflare Tunnel (Docker only)

To expose SearXNG through a Cloudflare Tunnel, create a tunnel in [Cloudflare Zero Trust](https://one.dash.cloudflare.com/) and point a public hostname at `http://searxng:8080`. Then set the token in `.env`:

```bash
CLOUDFLARE_TUNNEL_TOKEN=<your-tunnel-token>
SEARXNG_BASE_URL=https://search.example.com/
```

When `CLOUDFLARE_TUNNEL_TOKEN` is set, `./searxng docker start` also starts `cloudflared` via [`compose.cloudflare.yml`](compose.cloudflare.yml). You can run the same stack manually:

```bash
docker compose -f compose.yml -f compose.cloudflare.yml up -d
```

Set `SEARXNG_BASE_URL` to your public hostname when using the tunnel.

### Apple Container networking

Apple Container often sets the container DNS to `192.168.64.1`, which does not resolve hostnames. That shows up in SearXNG as `HTTP connection error` on every engine. The `./searxng ac start` command passes working DNS servers automatically. If you already have a container running, restart it so the new DNS settings take effect:

```bash
./searxng ac restart
```

To use different DNS servers, edit the `ac_dns_args()` function in `searxng`. It auto-detects your Mac’s primary DNS via `scutil` and adds `1.1.1.1` and `8.8.8.8` as fallbacks - change or remove those `--dns` values as needed, then restart.

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
