#!/bin/bash
echo "##teamcity[blockOpened name='npm-diff']"

TMP=${TMPDIR}_artifacts

# get npm-list.txt from the latest successful build
function get_last_successful_npm_list() {
  buildName=inbox-mobile
  snapshotUrl=http://repo.dev.wix/artifactory/libs-snapshots/com/wixpress/crm/$buildName/1.0.0-SNAPSHOT
  build=`curl -s $snapshotUrl/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/"`
  rm -rf $TMP
  mkdir $TMP
  wget --quiet $snapshotUrl/$buildName-$build.tar.gz -O $TMP/$buildName-$build.tar.gz
  tar -xzf $TMP/$buildName-$build.tar.gz -C $TMP
  LAST_SUCCESSFUL_NPM_LIST=$(ls -d $TMP/npm-list.txt)
}

get_last_successful_npm_list
echo $LAST_SUCCESSFUL_NPM_LIST

npm list > $TMP/npm-list-current.txt

echo npm list diff between this version and last successful build:
echo --------------------------------------------------------------
git diff --no-index $TMP/npm-list.txt $TMP/npm-list-current.txt
echo -------------------------- diff-end --------------------------
echo "##teamcity[blockClosed name='npm-diff']"
