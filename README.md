![Matterbearly Logo](build_mattermost_docker/logo/logo.svg)

# WARNING!!!

**This is just a Proof of Concept. Not a fork of Mattermost. Don't use this code until you have removed the Mattermost brand (logo and name).**

Tested with mattermost version 11.3.0.

# Goal

- Remove the user limit
- Add OIDC SSO
- Remove the complete enterprise code from the source code
- Build scripts for with / without docker image 

# Space for improvement
- Logo needs to be white for the UI
  - Need a light gray version of the logo as tsx file (svg -> tsx via convert_logo). Then in webapp/channels/src/components/global_header/left_controls/product_menu/product_branding_team_edition/product_branding_free_edition.tsx change the line accordingly:
    ``` import Logo from 'components/common/svg_images_components/logo_dark_blue_svg'; ```


# Installation notes 

## Change postgress password

You need to change the postgress password in compose.yaml at two places. Look for the placeholder REDACTED.

## change from mattermost.neuro.uni-bremen.de

I suggest a 

```
grep -R -i mattermost.neuro.uni-bremen.de *
```

To find all the place the base name needs to be changed.

## Ningx

Add the SSL files and rebuild the something something pem.

## Prepare the VM

I assume that we are dealing with a Ubuntu 24.04 VM fresh out of the door. See prepare_vm for the preparations necessary. 

## Make the docker network

Run create_network.sh

## Mattermost docker image

We need the mattermost docker image to start the docker containers via up.sh Go to build_mattermost_docker and look at the README.md. You want to check the newest version on https://github.com/mattermost/mattermost and change the instruction in the README.md accordingly. 


