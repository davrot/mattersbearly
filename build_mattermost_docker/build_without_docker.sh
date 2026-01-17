export BASEDIR="$(pwd)/"

cd ${BASEDIR}/server
go mod edit -replace github.com/mattermost/mattermost/server/public=./public
go mod edit -replace github.com/mattermost/mattermost/server/public/shared=./public/shared

cd ${BASEDIR}/server/public
go mod edit -replace github.com/mattermost/mattermost/server/v8=../

cd ${BASEDIR}/server
go mod tidy
go mod download

cd ${BASEDIR}/server/public
go mod tidy
go mod download

cd ${BASEDIR}/server
make build-linux BUILD_HASH=local-dev BUILD_NUMBER=999.9.9

export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"

nvm install 20
nvm use 20

cd ${BASEDIR}/webapp
make dist

cd ${BASEDIR}
mkdir -p ${BASEDIR}/config
OUTPUT_CONFIG=${BASEDIR}/config/config.json ${BASEDIR}/server/bin/config_generator
