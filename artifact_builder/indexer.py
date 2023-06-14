import os
from os.path import join
from re import sub
from filemap import fileMap

"""
indexDir
This function iterates over the giving directory and constructs the 
dictionary of files with .sql and .md extension. 
"""
def indexDir(sqlDirectory: str, _engine: str) -> fileMap:
    _fileMap: fileMap = {}

    for root, dirs, files in os.walk(sqlDirectory):
        for filename in files:
            key = sub('.sql|.md', '', filename)
            fpath = join(root.removeprefix('../'), filename)

            # For now, we ignore READMEs. But, we might furtherly include some documentation
            # artifact.
            if key not in _fileMap and filename.removesuffix(".md").lower() not in ('readme', '.gitkeep'):
                _fileMap[key]={'engine': _engine}
                _fileMap[key]={'title': sub('[_-]'," ", str(key)).capitalize()}
            
            if filename.endswith(".sql"):
                with open(fpath, encoding="utf-8") as f:
                    _fileMap[key].update({'fpath': fpath, 
                                        'category': root.removeprefix(sqlDirectory + '/'),
                                        'query': f.read()})
            elif filename.endswith(".md") and filename.removesuffix(".md").lower()  not in ('readme', '.gitkeep'):
                with open(fpath, encoding="utf-8") as f:
                    _fileMap[key].update({'docFPath': fpath,
                                          'doc': f.read()})
            else:
                pass

    return _fileMap