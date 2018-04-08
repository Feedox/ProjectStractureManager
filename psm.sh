#!/bin/bash

# psm
# version: 0.9

cmd=${1:-default}
repo=${2:-https://github.com/Livshitz/SuperWebApp.git}
timestamp=$(date +%s)

. .psmconfig
repoUrl=${repoUrl:-$repo}

if [ $cmd = init ] 
then 
	echo '> psm:init: ' $repoUrl

	git init . 
	mv .git .gitpsm
	git --git-dir=.gitpsm remote add origin $repoUrl
	git --git-dir=.gitpsm fetch origin
	git --git-dir=.gitpsm checkout -f -b master --track origin/master # origin/master is clone's default

	echo 'repoUrl='$repoUrl > .psmconfig

elif [ $cmd = update ]
then
	echo '> psm:update: '

	git --git-dir=.gitpsm add .
	git --git-dir=.gitpsm commit -m "."

	git --git-dir=.gitpsm fetch
	git --git-dir=.gitpsm branch old-master
	git --git-dir=.gitpsm reset --hard origin/master
	git --git-dir=.gitpsm merge old-master

	git --git-dir=.gitpsm mergetool --tool=opendiff --no-prompt
	git --git-dir=.gitpsm commit -m '.'
	git --git-dir=.gitpsm branch -d old-master

elif [ $cmd = resolve ]
then
	echo '> psm:resolve: '

elif [ $cmd = update-psm ]
then
	echo '> psm:update-psm: '

	# rm -f psm.sh
	curl -H 'Cache-Control: no-cache' -sL 'https://raw.githubusercontent.com/Livshitz/ProjectStructureManager/master/psm.sh?'$timestamp -o psm.sh && chmod +x psm.sh

else 
	echo '> psm:default: '
	echo '> psm:test: ' $repoUrl
	
fi
