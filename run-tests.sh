#!/bin/bash

# make sure we're in the project directory
cd $(dirname "$0")

# just to include the functions defined in ./bd
. ./bd /dev/null > /dev/null

red='\e[0;31m'
green='\e[0;32m'
nocolor='\e[0m'

success=0
failure=0
total=0

assertEquals() {
    ((total++))
    expected=$1
    actual=$2
    if [[ $expected = $actual ]]; then
        ((success++))
    else
        ((failure++))
        {
            echo Assertion failed on line $(caller 0)
            echo "  Expected: $expected"
            echo "  Actual  : $actual"
        } >&2
        echo
    fi
}

oldpwd=/home/user/project/src/org/main/site/utils/file/reader/whatever

# test run with no args
newpwd $oldpwd
assertEquals $oldpwd $NEWPWD

# test run with exact match
newpwd $oldpwd src
assertEquals /home/user/project/src/ $NEWPWD

# test run with prefix but no -s so not found
newpwd $oldpwd sr
assertEquals $oldpwd $NEWPWD

# test run with prefix found
newpwd $oldpwd -s sr
assertEquals /home/user/project/src/ $NEWPWD

# test run with prefix not found because case sensitive
newpwd $oldpwd -s Sr
assertEquals $oldpwd $NEWPWD

# test run with prefix found thanks to -si
newpwd $oldpwd -si Sr
assertEquals /home/user/project/src/ $NEWPWD

oldpwd='/home/user/my project/src'

# test run with space in dirname
newpwd "$oldpwd" -s my
assertEquals '/home/user/my project/' "$NEWPWD"

# should take to closest matching dir
newpwd /tmp/a/b/c/d/a/b a
assertEquals /tmp/a/b/c/d/a/ "$NEWPWD"

echo
[[ $failure = 0 ]] && printf $green || printf $red
echo "Tests run: $total ($success success, $failure failed)"
printf $nocolor
echo
