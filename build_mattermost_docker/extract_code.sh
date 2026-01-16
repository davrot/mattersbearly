export MATTERMOST_VERSION="11.3.0"
wget -N https://github.com/mattermost/mattermost/archive/refs/tags/v${MATTERMOST_VERSION}.tar.gz -O mattermost_source.tar.gz
rm -rf mattersource
mkdir mattersource
tar -xzf mattermost_source.tar.gz -C mattersource --strip-components=1

chmod +x create_patched_files.sh
rm -rf enterprise_replace
./create_patched_files.sh

cp -r enterprise_replace mattersource
cp build_without_docker.sh mattersource
cp build_with_docker.sh mattersource
cp Dockerfile mattersource

cd mattersource
git init
git branch -m main
chmod +x build_without_docker.sh
chmod +x build_with_docker.sh

