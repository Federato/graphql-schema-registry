#!/usr/bin/env bash

# Usage: ./bump_version.sh <major|minor|patch> - Increments the relevant version part by one.
#
# Usage 2: ./bump_version.sh <version-from> <version-to>
# 	e.g: ./bump_version.sh 1.1.1 2.0

set -e

# Define which files to update and the pattern to look for
# $1 Current version
# $2 New version
function bump_files() {
	bump ./chart/Chart.yaml "\version\: $1" "\version\: $2"
	bump ./package.json "\"version\": \"$1\"" "\"version\": \"$2\""
}

function bump() {
	echo "Updating $1..."
	sed -i '' "s/$2/$3/g" $1
	echo "Done"
}

function confirm() {
	read -r -p "$@ [Y/n]: " confirm

	case "$confirm" in
		[Nn][Oo]|[Nn])
			echo "Aborting."
			exit
			;;
	esac
}

if [ "$1" == "" ]; then
	echo >&2 "No 'from' version set. Aborting."
	exit 1
fi

if [ "$1" == "major" ] || [ "$1" == "minor" ] || [ "$1" == "patch" ]; then
    DESCRIBE=`git describe --tags --always`

    # increment the build number (ie 115 to 116)
    current_version=`echo $DESCRIBE | awk '{split($0,a,"-"); print a[1]}'`
	# current_version=$(grep -Po '(?<="version": ")[^"]*' package.json)
    echo $current_version

	IFS='.' read -a version_parts <<< "$current_version"

	major=${version_parts[0]}
	minor=${version_parts[1]}
	patch=${version_parts[2]}

	case "$1" in
		"major")
			major=$((major + 1))
			minor=0
			patch=0
			;;
		"minor")
			minor=$((minor + 1))
			patch=0
			;;
		"patch")
			patch=$((patch + 1))
			;;
	esac
	new_version="$major.$minor.$patch"
else
	if [ "$2" == "" ]; then
		echo >&2 "No 'to' version set. Aborting."
		exit 1
	fi
	current_version="$1"
	new_version="$2"
fi

if ! [[ "$new_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo >&2 "'to' version doesn't look like a valid semver version tag (e.g: 1.2.3). Aborting."
	exit 1
fi

confirm "Bump version number from $current_version to $new_version?"

bump_files "$current_version" "$new_version"


new_tag="$new_version"

confirm "Publish $new_tag?"

echo "Committing changed files..."
git add --all
git commit -m "Bumped version to $new_version"

echo "Adding new version tag: $new_tag..."
git tag "$new_tag"

current_branch=$(git symbolic-ref --short HEAD)

echo "Pushing branch $current_branch and tag $new_tag upstream..."
git push
git push --tags
