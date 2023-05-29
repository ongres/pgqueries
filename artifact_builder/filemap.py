from typing import TypedDict, List

# https://peps.python.org/pep-0589/

"""
Class fileMap
This class is intended to set the fields present in the json artifact 
for later indexing by the engine.
"""
class fileMap(TypedDict):    
    engine: str
    # Title is either the filename without scores or the title of the .md
    title: str
    fpath: str
    docFPath: str
    category: str
    query: str
    doc: str
    versionSupport: List[int]
    outputPerVersion: List[str]

def init():
    pass