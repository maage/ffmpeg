#!/bin/sh
set -e

git clone https://git.videolan.org/git/ffmpeg.git

cd ffmpeg

COMMIT=$(git rev-list HEAD -n1)
SHORTCOMMIT=$(echo ${COMMIT:0:7})
DATE=$(git log -1 --format=%cd --date=short | tr -d \-)
rm -fr .git*

cd ..

mv ffmpeg ffmpeg-$COMMIT

tar -cJf ffmpeg-$SHORTCOMMIT.tar.xz ffmpeg-$COMMIT
rm -fr ffmpeg-$COMMIT

sed -i \
    -e "s|%global commit0.*|%global commit0 ${COMMIT}|g" \
    -e "s|%global date.*|%global date ${DATE}|g" \
    ffmpeg.spec

rpmdev-bumpspec -c "Update to latest snapshot." ffmpeg.spec
