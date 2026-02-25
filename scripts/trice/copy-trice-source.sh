#!/bin/bash

# The argument must be ${localWorkspaceFolderBasename}
mkdir -p /workspaces/$1/Modules/trice 
cp -r /opt/trice/src/ /workspaces/$1/Modules/trice/
