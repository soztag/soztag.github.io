#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "info@maxheld.de"
git config --global user.name "Maximilian Held"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git \blogdown-output
cd blogdown-output
git rm -rf .
cp -r ../public/* ./
git add --all *
git commit -m "Update webpage" || true
git push origin gh-pages
