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
- The loading message is not shown: 
  - webapp_channels_src_components_initial_loading_screen_initial_loading_screen.css.patch
  - webapp_channels_src_components_initial_loading_screen_initial_loading_screen_template.html.patch
- The about modal needs love:
  - mattersource/webapp/channels/src/components/about_build_modal/about_build_modal.tsx
- I have the feeling that the OIDC fields are not correctly assigned.
  -  mattersource/server/einterfaces/oidc.go : func userFromOIDCUser
  -  mattersource/server/channels/app/oidc.go : func FindOrCreateOIDCUser, func generateUsernameFromOIDC, func UpdateUserFromOIDC
  -  mattersource/server/public/model/user.go : type User struct
  - If the env are set to MM_LOGSETTINGS_CONSOLELEVEL: DEBUG and MM_LOGSETTINGS_FILELEVEL: DEBUG , you can see the raw OIDC info in the mattermost log
  ```
    mattermost  | {"timestamp":"2026-01-18 01:16:26.284 +01:00","level":"debug","msg":"DEBUG: RAW OIDC CLAIMS FROM KEYCLOAK","caller":"einterfaces/oidc.go:64","path":"/oauth/oidc/complete","request_id":"7x8tams1ktdgbnuht3x8r461th","ip_addr":"172.19.0.4","user_id":"","method":"GET","claims":{"acr":"1","at_hash":"zg5hBV5m4cTeFj0ENXAsqw","aud":"mattermost","auth_time":1768695386,"azp":"mattermost","email":"davrot@uni-bremen.de","email_verified":true,"exp":1768695446,"family_name":"Rotermund","given_name":"David","iat":1768695386,"iss":"https://sso.fb1.uni-bremen.de/sso/realms/master","jti":"334f8eef-fd9b-4a5b-9d6f-4ab46b1904ae","locale":"en","name":"David Rotermund","preferred_username":"davrot@uni-bremen.de","sid":"e3645393-e1ec-4d7d-afb6-166061c9ebc1","sub":"496667d6-2ef6-4f9a-8fda-2ead5e22e7b5","typ":"ID"}}
```

 
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


