#!/usr/bin/env bash
set -eu

echo Starting deploy app to $HOST

TMP=~/tmp/cosmos
APP=app-$(date +%Y%m%d-%H%M%S)-$(git log --pretty=format:"%H" -1 | cut -c 1-12)

echo Ensure temp directory: $TMP
mkdir -p $TMP

echo Building release on the docker container

docker build --platform linux/amd64 -t cosmos:latest .
docker create --name dummy cosmos:latest
docker cp dummy:/app $TMP/$APP
docker rm dummy

echo Packaging the release build

cd $TMP
COPYFILE_DISABLE=1 tar zcf $APP.tar.gz $APP
rm -r $APP


echo Uploading the package

scp $APP.tar.gz $HOST:~/deploy
rm $APP.tar.gz

echo Unpackage the release build end deploy

ssh $HOST /bin/bash << EOF
cd ~/deploy
tar zxvf $APP.tar.gz
rm $APP.tar.gz
sudo chown -R www-data:www-data $APP
sudo mv $APP /var/www/cosmos
cd /var/www/cosmos
sudo ln -snf $APP app
sudo systemctl restart cosmos
sudo systemctl status cosmos
EOF
