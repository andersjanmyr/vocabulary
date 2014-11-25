#!/bin/bash

set -o errexit

git status --short |grep ''
changed=$?
if [ $changed -eq 0 ]; then
  git stash save -u 'Before deploy'
fi

git checkout deploy
git merge master --no-edit
npm run build
if git commit -am Deploy; then
  echo 'Changes Committed'
fi
git push heroku deploy:master
git checkout master

if [ $changed -eq 0 ]; then
  git stash pop
fi
npm run build-less
