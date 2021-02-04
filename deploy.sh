#!/bin/bash
# testing PR stuff

versionRegex='^v([0-9]+)\.([0-9]+)\.([0-9]+)'
if [[ $(git describe --tags --abbrev=0) =~ $versionRegex ]]
then
    echo "major=${BASH_REMATCH[1]}" >> $GITHUB_ENV
    echo "minor=${BASH_REMATCH[2]}" >> $GITHUB_ENV
    echo "patch=${BASH_REMATCH[3]}" >> $GITHUB_ENV
else
    echo "No existing version tag found"
fi

comment="$(git log -1 --pretty=%B)"
majorChangeRegex='^[^:]+\!:|BREAKING\ CHANGE:'
minorChangeRegex='^feat:'
patchChangeRegex='^fix:'
bump=
branch=
if [[ $comment =~ $majorChangeRegex ]]
then
    echo "Major change detected"
    major=$(($major + 1))
    bump=1
    branch=1
elif [[ $comment =~ $minorChangeRegex ]]
then
    echo "Minor change detected"
    minor=$(($minor + 1))
    bump=1
elif [[ $comment =~ $patchChangeRegex ]]
then
    echo "Patch change detected"
    patch=$(($patch + 1))
    bump=1
else
    echo "No change detected"
fi

newVersion="${major}.${minor}.${patch}"

if [ $bump ]
then
    echo "Tagging commit with ""v${newVersion}"""
    git tag v${newVersion}
    if [ $branch ]
    then
        echo "Creating branch ""release/v${newVersion}"""
        git tag v${newVersion}
    fi
    
    echo "Restoring dependencies"
    dotnet restore
    echo "Building"
    dotnet build -c Release --no-restore -p:version=${newVersion}
else
    echo "Version is unchanged"
fi
