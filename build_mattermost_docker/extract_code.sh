export MATTERMOST_VERSION="11.3.0"
wget -N https://github.com/mattermost/mattermost/archive/refs/tags/v${MATTERMOST_VERSION}.tar.gz -O mattermost_source.tar.gz
rm -rf mattersource
mkdir mattersource
tar -xzf mattermost_source.tar.gz -C mattersource --strip-components=1

chmod +x create_patched_files.sh
rm -rf enterprise_replace
./create_patched_files.sh

rm -rf mattersource/server/enterprise
mkdir -p mattersource/server/enterprise/metrics
mkdir -p mattersource/server/enterprise/message_export/shared

echo "package enterprise" > mattersource/server/enterprise/enterprise.go
echo "package metrics" > mattersource/server/enterprise/metrics/metrics.go
echo "package shared" > mattersource/server/enterprise/message_export/shared/shared.go

rm -rf mattersource/server/cmd/mmctl/commands/compliance
rm -f mattersource/server/cmd/mmctl/commands/compliance_export.go

cp -rvf ./enterprise_replace/* mattersource/
cp -f logo/* mattersource/webapp/channels/src/images
cp -f favicon/* mattersource/webapp/channels/src/images/favicon
# cp -f logo_dark_blue_svg.tsx mattersource/webapp/channels/src/components/common/svg_images_components/logo_dark_blue_svg.tsx
# cp -f mattermost_logo.tsx mattersource/webapp/channels/src/components/widgets/icons/mattermost_logo.tsx

cp build_without_docker.sh mattersource
cp build_with_docker.sh mattersource
cp Dockerfile mattersource

cd mattersource
git init
git branch -m main
chmod +x build_without_docker.sh
chmod +x build_with_docker.sh
