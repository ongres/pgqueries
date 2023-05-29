import indexer
from filemap import fileMap
import json 
import argparse


sqlDirectory = "../sql/"
global _engine
_engine: str

def main():
    _engine = 'postgres'

    parser = argparse.ArgumentParser()
    parser.add_argument("-D", "--directory", help="Directory to be indexed", type=str, required=False, default=sqlDirectory)
    parser.add_argument("-O", "--output", help="Output artifact", required=False, type=str, default="./index.json")
    parser.add_argument("-v", "--verbose", help="Kind of debug", default=False, action=argparse.BooleanOptionalAction)
    args = parser.parse_args()

    fileMap = indexer.indexDir(args.directory, _engine)

    if args.verbose:
        print(json.dumps(fileMap, indent=2))
    
    with open(args.output, 'w+', encoding="utf-8") as f:
        json.dump(fileMap, f)

if __name__ == "__main__":
    main()
    