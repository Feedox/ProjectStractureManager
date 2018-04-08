#!/bin/bash

# psm
# version: 0.1

cmd=$1
cmd=${cmd:-default}
repoUrl=git@github.com:Livshitz/SuperWebApp.git

if [ $cmd = init ] 
then 
	echo '> psm:init: '

	git init . 
	mv .git .gitpsm
	git --git-dir=.gitpsm remote add origin $repoUrl
	git --git-dir=.gitpsm fetch origin
	git --git-dir=.gitpsm checkout -f -b master --track origin/master # origin/master is clone's default

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
	# git --git-dir=.gitpsm branch -d old-master

elif [ $cmd = resolve ]
then
	echo '> psm:resolve: '

else 
	echo '> psm:default: '
fi
