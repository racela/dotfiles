#!/bin/bash

response=$(curl -s -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/racela/home-server-argocd/pulls?state=open&sort=created")

count=$(echo $response | jq '. | length')

titles=$(echo $response | jq -r '[.[] | "\(.created_at | split("T")[0]): \(.title)"] | join("\\n")')

echo "{\"text\":\"$count\", \"tooltip\":\"$titles\"}"
