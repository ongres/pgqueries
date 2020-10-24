
.PHONY := setup

## create the virtual env running: python3 -m venv venv

setup :
	source venv/bin/activate
	pip install -r requirements.txt

compile: setup
	pgsanity sql/**/*.sql	
