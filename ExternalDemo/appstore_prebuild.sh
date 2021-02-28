CFBundleDisplayName#!/bin/sh


ROOT=.#${WORKSPACE}
PLISTS_FOLDER=${ROOT}/discount/App/AppMain
SHARED_PLISTS_FOLDER=${ROOT}/discount/Shared/AppMain
PROJECT_FILE_PATH=${ROOT}/discount.xcodeproj/project.pbxproj
RESOURCES_FOLDER=${ROOT}/discount/Resources
DISCOUNT_RESOURCES_FOLDER=${RESOURCES_FOLDER}/discount
MERCANTILE_RESOURCES_FOLDER=${RESOURCES_FOLDER}/mercantile

# this script is not logged to the console so log output to file
exec > ${ROOT}/prebuild.log 2>&1

echo "Running pre-build script Jenkins"

echo "ROOT="${ROOT}
echo "PLISTS_FOLDER="${PLISTS_FOLDER}
echo "PROJECT_FILE_PATH="${PROJECT_FILE_PATH}

export VERSION=`defaults read ${PLISTS_FOLDER}/discount-Info.plist CFBundleShortVersionString`"("`defaults read ${PLISTS_FOLDER}/discount-Info.plist CFBundleVersion`")"
echo "VERSION="${VERSION}
echo VERSION=$VERSION > version.properties


#### replace development variables with production variables


# define as production
defaults write ${SHARED_PLISTS_FOLDER}/packaging-Info.plist "Build for production" -bool true


# ngsoft prefix
sed -i '' -e 's/$(PACKAGING_PREFIX)//g' ${PROJECT_FILE_PATH}
# change to store profile
sed -i '' -e 's/PROVISIONING_PROFILE_SPECIFIER = ngsoft./PROVISIONING_PROFILE_SPECIFIER = /g' ${PROJECT_FILE_PATH}

sed -i '' -e 's/$(PACKAGING_PREFIX)//g' ${PLISTS_FOLDER}/discount-Info.plist
sed -i '' -e 's/$(PACKAGING_PREFIX)//g' ${PLISTS_FOLDER}/mercantile-Info.plist

# bundle identifier
sed -i '' -e 's/$(DISCOUNT_BUNDLE_IDENTIFIER)/il.co.discountbank.discountbank/g' ${PROJECT_FILE_PATH}
sed -i '' -e 's/$(DISCOUNT_BUNDLE_IDENTIFIER)/il.co.discountbank.discountbank/g' ${PLISTS_FOLDER}/myAccountWatch-discount-Info.plist
sed -i '' -e 's/$(DISCOUNT_BUNDLE_IDENTIFIER)/il.co.discountbank.discountbank/g' ${PLISTS_FOLDER}/myAccountWatch-extension-discount-Info.plist

sed -i '' -e 's/$(MERCANTILE_BUNDLE_IDENTIFIER)/il.co.mercantile.mercantile/g' ${PROJECT_FILE_PATH}
sed -i '' -e 's/$(MERCANTILE_BUNDLE_IDENTIFIER)/il.co.mercantile.mercantile/g' ${PLISTS_FOLDER}/myAccountWatch-mercantile-Info.plist
sed -i '' -e 's/$(MERCANTILE_BUNDLE_IDENTIFIER)/il.co.mercantile.mercantile/g' ${PLISTS_FOLDER}/myAccountWatch-extension-mercantile-Info.plist



# team ID
sed -i '' -e 's/9VMR9WDN68/Z2W7HDJVP3/g' ${PROJECT_FILE_PATH}


#### replace development files with production files

PRODUCTION_FRAMEWORKS_FOLDER=${ROOT}/appstore/Frameworks
SRC_FRAMEWORKS_FOLDER=${ROOT}/discount/Frameworks
echo "PRODUCTION_FRAMEWORKS_FOLDER="${PRODUCTION_FRAMEWORKS_FOLDER}
echo "SRC_FRAMEWORKS_FOLDER="${SRC_FRAMEWORKS_FOLDER}

# replace nanorep fat framework with release framework
rm -d -f -r ${SRC_FRAMEWORKS_FOLDER}/Nanorep
cp -R ${PRODUCTION_FRAMEWORKS_FOLDER}/Nanorep ${SRC_FRAMEWORKS_FOLDER}

# replace trusteer manifest test file with release file
# mercantile file is replaced in appstore_prebuild_mercantile.sh
cp -f ${ROOT}/discount/Libs/trusteer/manifest/discount_production_manifest.rpkg ${ROOT}/discount/Libs/trusteer/manifest/tas/manifest.rpkg

# replace GoogleService-Info with release file
rm -d -f -r ${DISCOUNT_RESOURCES_FOLDER}/GoogleService-Info.plist
cp -R ${DISCOUNT_RESOURCES_FOLDER}/production/GoogleService-Info.plist ${DISCOUNT_RESOURCES_FOLDER}

rm -d -f -r ${MERCANTILE_RESOURCES_FOLDER}/GoogleService-Info.plist
cp -R ${MERCANTILE_RESOURCES_FOLDER}/production/GoogleService-Info.plist ${MERCANTILE_RESOURCES_FOLDER}



echo "End Running pre-build script Jenkins"
