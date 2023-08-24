#!/bin/bash

fd . /share/dean/reddit/comments ww.json -X bat > comments_aw.json
fd . /share/dean/reddit/submissions ww.json -X bat > subs_aw.json
rg -i "worker|employee" subs_aw.json | jq -c '' > subs_awe.json
rg -i "worker|employee" comments_aw.json | jq -c '' > comments_awe.json
rg -i "worker|employee" comments_aw.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "subreddit" or .key == "body" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > comments_awe.json
rg -i "worker|employee" comments_aw.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "title" or .key == "subreddit" or .key == "body" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > comments_awe.json
