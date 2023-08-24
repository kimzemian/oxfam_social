#!/bin/bash

fd ww.json /share/dean/reddit/comments -X bat > comments_ww.json
fd ww.json /share/dean/reddit/submissions -X bat > subs_ww.json
rg -i "worker|employee" subs_ww.json | jq -c '' > subs_wwe.json
rg -i "worker|employee" comments_ww.json | jq -c '' > comments_wwe.json
rg -i "worker|employee" comments_ww.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "subreddit" or .key == "body" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > comments_wwe.json
rg -i "worker|employee" comments_ww.json | jq -c '.created_utc |= (. | tonumber) | . |= with_entries(select(.key == "title" or .key == "subreddit" or .key == "body" or .key == "subreddit_id" or .key == "author" or .key == "link_id" or .key == "id" or .key == "score" or .key == "created_utc" or .key == "parent_id"))' > comments_wwe.json
