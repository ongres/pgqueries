# Artifact Builder

This section builds a JSON map of the SQL and MD files present on the repository, and structure them in the form of a Opensearh-compatible schema for later import into a searcher endpoint.

## Execution

Load virtual env:

```bash
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

The folowing allows you to index and search:

```bash
python3 artifact_builder/ -D sql -E -v | jq '.search_query'
```

See `python3 artifact_builder/ -h` for more information.

Default output: index.json (with `--output`) and `--ouput-ndjson` (`ndindex.json`).


## TODO 

Modules [potentially] beneficial: [Dataclasses](https://github.com/lidatong/dataclasses-json)
