#!/bin/sh

#  appcenter-pre-build.sh
#  
#
#  Created by Oren Heimlich on 28/02/2021.
#  


#!/usr/bin/env bash

# Example: Change bundle name of an iOS app for non-production
if [ "$APPCENTER_BRANCH" != "main" ];
then
    plutil -replace CFBundleDisplayName -string "\$(PRODUCT_NAME) Beta" $APPCENTER_SOURCE_DIRECTORY/ZJTableViewManager/ExternalDemo/CommentsWithPicture/CommentsWithPicture/comments-Info/Info.plist
    
fi
