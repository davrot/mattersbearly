# Change postgress password

You need to change the postgress password in compose.yaml at two places. Look for the placeholder REDACTED.

# change from mattermost.neuro.uni-bremen.de

I suggest a 

```
grep -R -i mattermost.neuro.uni-bremen.de
```

To find all the place the base name needs to be changed.

# Ningx

Add the SSL files and rebuild the something something pem.

# Prepare the VM

I assume that we are dealing with a Ubuntu 24.04 VM fresh out of the door. See prepare_vm for the preparations necessary. 

# Make the docker network

Run create_network.sh

# Mattermost docker image

We need the mattermost docker image to start the docker containers via up.sh Go to build_mattermost_docker and look at the README.md. You want to check the newest version on https://github.com/mattermost/mattermost and change the instruction in the README.md accordingly. 


