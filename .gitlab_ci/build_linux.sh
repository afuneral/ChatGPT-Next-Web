#！/bin/bash
set -eo pipefail
set -x
echo "############## Begin to execute job:build ##############"
#<================ user modify(please modify content of script)
mkdir -p $TGZ_PACKAGE_PATH_LINUX/chatgpt-next-web
#sed -i "1c APP_VERSION = ${CI_COMMIT_TAG-:${CI_COMMIT_SHORT_SHA}}" .env.local

npm config set strict-ssl false
npm install --registry=https://registry.npm.taobao.org/

npm run build

cp -r ./package.json ./yarn.lock ./node_modules ./public ./.next  ./app
cp -r ./app ./$TGZ_PACKAGE_PATH_LINUX/$MODULE_NAME

#=============================================================>
echo "############## End to execute job:build ##############"
