```
wget https://github.com/mattermost/mattermost/archive/refs/tags/v11.2.2.tar.gz -O mattermost_source.tar.gz
tar -xzf mattermost_source.tar.gz
chmod +x create_patched_files.sh
./create_patched_files.sh

cp Dockerfile mattermost-11.2.2
cp build.sh mattermost-11.2.2
cp -r enterprise_replace mattermost-11.2.2/enterprise_replace
cd mattermost-11.2.2
git init
git branch -m main
chmod +x build_stage.sh
./build_stage.sh
```
