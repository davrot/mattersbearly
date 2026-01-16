export BASEDIR="$(pwd)/"

rm -rf ${BASEDIR}/server/enterprise
cp ./enterprise_replace/server/cmd/mmctl/commands/compliance_export.go ${BASEDIR}/server/cmd/mmctl/commands/compliance_export.go
cp ./enterprise_replace/server/cmd/mattermost/main.go ${BASEDIR}/server/cmd/mattermost/main.go
cp ./enterprise_replace/server/Makefile ${BASEDIR}/server/Makefile

# Create stub directories for enterprise packages to satisfy imports
mkdir -p ${BASEDIR}/server/enterprise/metrics
mkdir -p ${BASEDIR}/server/enterprise/message_export/shared

# Create a dummy file in the main enterprise stub
echo "package enterprise" > ${BASEDIR}/server/enterprise/enterprise.go
echo "package metrics" > ${BASEDIR}/server/enterprise/metrics/metrics.go
echo "package shared" > ${BASEDIR}/server/enterprise/message_export/shared/shared.go

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

nvm install 20 
nvm use 20
cd ${BASEDIR}/webapp
make dist

cd ${BASEDIR}
mkdir -p ${BASEDIR}/config
OUTPUT_CONFIG=${BASEDIR}/config/config.json ${BASEDIR}/server/bin/config_generator


