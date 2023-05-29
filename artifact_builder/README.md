# Artifact Builder

This section builds a JSON map of the SQL and MD files present on the repository, and structure them in the form of a Opensearh-compatible schema for later import into a searcher endpoint.

## Execution


```bash
python3 artifact_builder/ -D sql -v | jq '.search_query'
```

Default output: index.json (with `--output`).


## Modules [potentially] used

[Dataclasses](https://github.com/lidatong/dataclasses-json)
