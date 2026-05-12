# diamond
Source-built container image for `diamond`.

## Quick Usage

```bash
docker pull docker.io/picotainers/diamond:latest
docker run --rm docker.io/picotainers/diamond:latest version
```

## Usage

```bash
# Mount the current directory so DIAMOND can read databases and query files
docker run --rm -v "$(pwd):/data" -w /data docker.io/picotainers/diamond:latest blastp -d db -q queries.fasta -o matches.m8
```

## Building

```bash
docker build -t docker.io/picotainers/diamond:latest .
```
