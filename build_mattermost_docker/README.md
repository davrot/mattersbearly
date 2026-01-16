```
wget https://github.com/mattermost/mattermost/archive/refs/tags/v11.2.2.tar.gz -O mattermost_source.tar.gz
tar -xzf mattermost_source.tar.gz

cp Dockerfile mattermost-11.2.2
cp build.sh mattermost-11.2.2
cd mattermost-11.2.2
git init
git branch -m main
```
