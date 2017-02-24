#!/bin/bash
# find out your staff group id (for me it is 20)
# dscacheutil -q group
STAFF_GROUP_ID=20
USERNAME="pairprogger"
PASSWORD="password123"

MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
NEWID=$((MAXID+1))

sudo dscl . -create /Users/$USERNAME
sudo dscl . -create /Users/$USERNAME UserShell /bin/bash
sudo dscl . -create /Users/$USERNAME UniqueID "$NEWID"
sudo dscl . -create /Users/$USERNAME PrimaryGroupID $STAFF_GROUP_ID
sudo dscl . -create /Users/$USERNAME RealName "Pair Programmer"
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
sudo dscl . -passwd /Users/$USERNAME $PASSWORD
sudo dscl . -append /Groups/com.apple.access_ssh GroupMembership $USERNAME
sudo createhomedir -c -u $USERNAME
# make sure that there is /Users/pairprogger/ on your disk now
