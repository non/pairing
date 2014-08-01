#!/bin/sh

TARGET=/usr/local/bin/pair
DIR=/var/run/pairs
GROUP=pairing

# print out a basic usage description
usage() {
    echo "install.sh USER1 [USER2 ...]"
    echo ""
    echo "this script:"
    echo " * installs the pair command to $TARGET."
    echo " * creates the $GROUP group, and adds the users to it."
    echo " * creates $DIR and gives it appropriate permissions."
    echo ""
    exit 1
}

# check to see if we have the right tools
checknix() {
    [ -f /etc/group ] || notnix "/etc/group not found"
    which -s groupadd || notnix "groupadd not found"
    which -s usermod  || notnix "usermod not found"
}

# print an error explaining what we're missing
notnix() {
    echo "ERROR: not a valid *nix system: $1"
    exit 1
}

# make sure we are given at least one pairing user
if [ $# -eq 0 ]; then usage; fi

# if the group doesn't exist, create it
grep -q "^$GROUP:" /etc/group
if [ $? -ne 0 ]; then
    groupadd "$GROUP"
fi

# add each user to the group
while [ $# -ne 0 ]; do
    usermod -a -G "$GROUP" "$1" 
    shift
done

# set up the pairing directory's permissions
if [ ! -d "$DIR" ]; then
    mkdir "$DIR"
    chgrp -R "$GROUP" "$DIR"
    chmod 2770 "$DIR"
fi

# copy the executable and set it up
cp pair "$TARGET"
chmod +x "$TARGET"
