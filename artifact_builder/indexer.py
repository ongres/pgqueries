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

            if key not in _fileMap:
                _fileMap[key]={'engine': _engine}
            
            if filename.endswith(".sql"):
                with open(fpath, encoding="utf-8") as f:
                    _fileMap[key].update({'fpath': fpath, 
                                        'category': root.removeprefix(sqlDirectory),
                                        'query': f.read()})
            elif filename.endswith(".md"):
                with open(fpath, encoding="utf-8") as f:
                    _fileMap[key].update({'docFPath': fpath,
                                          'doc': f.read()})
            else:
                pass

    return _fileMap