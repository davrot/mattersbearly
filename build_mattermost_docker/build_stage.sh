docker pull mattermost/mattermost-build-server:1.24.11
ulimit -n 8096
docker build -t mattermost-final -f Dockerfile .
