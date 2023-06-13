import indexer
from filemap import fileMap
import json 
import ndjson
import argparse
from re import sub, escape, MULTILINE
from os import remove

sqlDirectory = "../sql/"
global _engine
_engine: str

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("-D", "--directory", help="Directory to be indexed", type=str, required=False, default=sqlDirectory)
    parser.add_argument("-O", "--output", help="Output json artifact", required=False, type=str, default="./index.json")
    parser.add_argument("-o", "--output-ndjson", help="Output ndjson artifact", required=False, type=str, default="./ndindex.json")
    parser.add_argument("-v", "--verbose", help="Kind of debug", default=False, action=argparse.BooleanOptionalAction)
    parser.add_argument("-E", "--engine", help="Engine name", default="postgres", type=str, required=True)
    args = parser.parse_args()

    fileMap = indexer.indexDir(args.directory, args.engine)

    if args.verbose:
        print(json.dumps(fileMap, indent=1))
    
    with open(args.output, 'w+', encoding='utf-8-sig') as f:
        json.dump(fileMap, f, indent=1)
    
    with open(args.output, 'rb') as f:
        data = json.load(f)

    """
    Next blocks are doing a nasty thing. They dump into a temporal file the contents of 
    the data dictionary for escaping the escape character later. This generates an ndjson 
    compatible with Postgres COPY.
    """
    with open(args.output_ndjson + '.temp', 'w+', encoding='utf-8-sig') as f:
        writer = ndjson.writer(f)
        for key in data:
            writer.writerow(data[key])

    with open(args.output_ndjson, 'w+', encoding='utf-8-sig') as f:
        input = open(args.output_ndjson + '.temp')
        f.write(sub(r'\\',r'\\\\',input.read()))
        input.close()

    remove(args.output_ndjson + '.temp')

if __name__ == "__main__":
    main()
    