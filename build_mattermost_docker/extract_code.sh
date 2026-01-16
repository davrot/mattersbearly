wget -N https://github.com/mattermost/mattermost/archive/refs/tags/v11.3.0.tar.gz -O mattermost_source.tar.gz
rm -rf mattersource
mkdir mattersource
tar -xzf mattermost_source.tar.gz -C mattersource --strip-components=1

chmod +x create_patched_files.sh
rm -rf enterprise_replace
./create_patched_files.sh

cp -r enterprise_replace mattersource
cp build_without_docker.sh mattersource

cd mattersource
git init
git branch -m main

