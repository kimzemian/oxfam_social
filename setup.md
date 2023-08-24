- ## acquiring data
	- `fd -e zst -x ./amazon_warehouse.sh {} {.}_aw.json`
	  finds keywords in a compressed file and stores them in _aw file:
	  `-e` is the extension, `-x` executes
	  where the `.sh` script is:
	  `#!/bin/sh`
	  `zst --long=31 -cdq "$1" | rg -i warehouse | rg -i amazon > "$2"`
	  `"$1"` is filename and `"$2"` is newfileneame. we call this data the raw data.
	- do this for amazon warehouse, amazon warehouse employee/worker. Repeat for walmart.
- ## useful notes/commands
	- `zstd` which is used here getting keywords from a compressed file, is not running in parallel
	- `df -h` tells you how much storage you have
	- `>` overwrites to a file while `>>` appends to a file
	- on jupyter, if there is a connectivity issue between the server running the code and the browser viewing it, then the state of the notebook is lost. So for cells that take a long time to run, I suggest `caffeinate` your mac, i.e. stop it from sleeping
	- Note: if installing without sudo privileges, you can either use a package manager like cargo, or find the binary, 'make' it and add it to path.
	- `jql` deals with json (written in rust)
	  `jq` deals with json (in c++)
	  with `jq . filename` you can prettify a json file
	- to run a executable from the current directory use `./file`
	-
- ## processing data
	- first we make sure we can't change the raw data, since it's very time consuming to acquire. we need to change permissions on the folder and files, use `chmod` for that:
	  `fd . reddit -t d -x chmod 755`
	  `-t d` specifies type directory
	  `fd . reddit -t f -x chmod 444`
	  `-t f` specifies type file
	  `chmod 755 reddit` 
	  we need to do reddit folder seperately
	- create a dataset directory, run: `./gen_data amazon|walmart`, the bash file is:
	  ```bash
	  #!/bin/bash
	  SC=""
	  if [[ $1 == "amazon" ]]
	  then
	    SC="a"
	  elif [[ $1 == "walmart" ]]
	  then
	    SC="w"
	  else
	    echo "Usage: gen_data amazon|walmart"
	    exit 1
	  fi
	  
	  fd "${SC}w.json" /share/dean/reddit/comments -X bat > comments_${SC}w.json
	  fd "${SC}w.json" /share/dean/reddit/submissions -X bat > subs_${SC}w.json
	  # rg -i "worker|employee" subs_${SC}w.json | jq -c '' > subs_${SC}we.json
	  # rg -i "worker|employee" comments_${SC}w.json | jq -c '' > comments_${SC}we.json
	  rg -i "worker|employee" comments_${SC}w.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "subreddit" or .key == "body" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > comments_${SC}we.json
	  rg -i "worker|employee" subs_${SC}w.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "title" or .key == "subreddit" or .key == "selftext" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > subs_${SC}we.json
	  ```
	  `-e` is for extension, `-X` execute the given command once, with all search results as arguments
	  `-i` makes sure it is case insensitive, `-c` makes sure `jq` doesn't prettify, which is important to turn this into a huggingface dataset.
	  does two things: first makes sure `created_utc` is a number(turns string to number), second makes sure we only keep all the aforementioned key,value pairs.
		-
	- ## creating dataset and topic modeling
		- this is work done on jupyter/python files, so no comments needed here.
		-
	-
	-
	-
	-