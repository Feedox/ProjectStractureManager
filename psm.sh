#!/bin/bash

# psm
# version: 0.12

cmd=${1:-default}
repo=${2:-https://github.com/Livshitz/SuperWebApp.git}
timestamp=$(date +%s)

. .psmconfig
repoUrl=${repoUrl:-$repo}

if [ $cmd = init ] 
then 
	echo '> psm:init: ' $repoUrl

	mkdir temp_psm
	cd temp_psm
	git init .
	mv .git .gitpsm
	find . -maxdepth 1 -exec mv {} .. \;
	cd ../
	rm -r temp_psm
	git --git-dir=.gitpsm remote add origin $repoUrl
	git --git-dir=.gitpsm fetch origin
	git --git-dir=.gitpsm checkout -f -b master --track origin/master # origin/master is clone's default
	git --git-dir=.gitpsm config --global mergetool.keepBackup false

	echo 'repoUrl='$repoUrl > .psmconfig

elif [ $cmd = update ]
then
	echo '> psm:update: '

	echo "Getting ready for update. Did you commit all changes in your repo? "
	select yn in "Yes, continue" "No, abort"; do
		case $yn in
			"Yes, continue" ) break;;
			"No, abort" ) exit;;
		esac
	done

	git --git-dir=.gitpsm add .
	git --git-dir=.gitpsm commit -m "."

	git --git-dir=.gitpsm fetch
	git --git-dir=.gitpsm branch old-master
	git --git-dir=.gitpsm reset --hard origin/master
	git --git-dir=.gitpsm merge old-master -m "."

	echo '> psm:update: Attempting to merge '
	git --git-dir=.gitpsm mergetool --tool=opendiff --no-prompt
	
	echo "Please check your repo and commit changes. Did you commit or revered? "
	select yn in "Commited, continue" "Reverted, unroll changes and sync side repo state"; do
		case $yn in
			"Commited, continue" ) git --git-dir=.gitpsm commit -m '.'; git --git-dir=.gitpsm branch -d old-master; break;;
			"Reverted, unroll changes and sync side repo state" ) exit;;
		esac
	done
	
	
elif [ $cmd = reset ]
then
	echo '> psm:reset: '
	git --git-dir=.gitpsm pull -f
	git --git-dir=.gitpsm reset --hard origin/master

elif [ $cmd = update-psm ]
then
	echo '> psm:update-psm: '

	# rm -f psm.sh
	curl -H 'Cache-Control: no-cache' -sL 'https://raw.githubusercontent.com/Livshitz/ProjectStructureManager/master/psm.sh?'$timestamp -o psm.sh && chmod +x psm.sh

else 
	echo '> psm:default: '
	echo '> psm:test: ' $repoUrl
	
fi
