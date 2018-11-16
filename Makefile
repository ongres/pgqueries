
.PHONY := setup

setup :
	pip install -r requirements.txt

compile: setup
	pgsanity sql/**/*.sql	
