![Matterbearly Logo](build_mattermost_docker/logo/logo.svg)


This project is just a proof of concept. It is not a fork of Mattermost https://github.com/mattermost/mattermost. This is just a collection of scripts and patches that modify the Mattermost source code. This repository does not contain the code of the Mattermost project.   

18.01.2026: Tested with mattermost version 11.3.0.

# WARNING!!!

**Don't use this code until you have removed the original Mattermost brand (logo and name).** 

For details see here: https://docs.mattermost.com/product-overview/faq-license.html#how-can-i-create-an-open-source-derivative-work-of-mattermost

Concerning https://docs.mattermost.com/product-overview/faq-mattermost-source-available-license.html#how-can-i-identify-code-licensed-as-source-available the server/enterprise folder is deleted and replace by 
```
echo "package enterprise" > mattersource/server/enterprise/enterprise.go
echo "package metrics" > mattersource/server/enterprise/metrics/metrics.go
echo "package shared" > mattersource/server/enterprise/message_export/shared/shared.go
```

Concerning the logo 
```
webapp/channels/src/images
webapp/channels/src/images/favicon
webapp/channels/src/components/common/svg_images_components/logo_dark_blue_svg.tsx
webapp/channels/src/components/widgets/icons/mattermost_logo.tsx
```
are modifed. 

[Mattermost](https://mattermost.com/) is a trandmark of (Mattermost, Inc. All rights reserved).

# Goal

- Remove the user limit
- Add OIDC SSO
- Remove the complete enterprise code from the source code
- Build scripts for with / without docker image 

# Space for improvement
- Remove the start trial modal.


# OIDC

- This is the mapping, if you don't like it just change it:
  -  **mattersource/server/einterfaces/oidc.go** : func userFromOIDCUser
    -  user.Username <- oidcUser.Nickname (if not empty otherwise oidcUser.Email without @) <- json:"preferred_username"
    -  user.Email <- strings.ToLower(oidcUser.Email) <- json:"email"
    -  user.EmailVerified <- oidcUser.EmailVerified <- json:"email_verified"
    -  user.Nickname <- oidcUser.GivenName + oidcUser.FamilyName or if empty oidcUser.Nickname
    -  user.FirstName <- oidcUser.GivenName <- json:"given_name"
    -  user.LastName <- oidcUser.FamilyName <- json:"family_name"
    -  user.AuthData <- oidcUser.Sub <- json:"sub"
    -  user.AuthService <- "oidc"    
  -  **mattersource/server/channels/app/oidc.go** : func FindOrCreateOIDCUser, func generateUsernameFromOIDC
    -  user.Username <- oidcUser.Nickname (if not empty otherwise oidcUser.Email without @) <- json:"preferred_username"
    -  user.Email <- strings.ToLower(oidcUser.Email)  <- json:"email"
    -  user.EmailVerified <- oidcUser.EmailVerified <- json:"email_verified"
    -  user.Nickname <-  oidcUser.GivenName + oidcUser.FamilyName or if empty oidcUser.Nickname
    -  user.FirstName <- oidcUser.GivenName <- json:"given_name"
    -  user.LastName <- oidcUser.FamilyName <- json:"family_name"
    -  user.AuthData <- oidcUser.Sub  <- json:"sub"
    -  user.AuthService <- "oidc"
  -  **mattersource/server/channels/app/oidc.go** : func UpdateUserFromOIDC
    -  user.Email <- strings.ToLower(oidcUser.Email)  <- json:"email"
    -  user.EmailVerified <- oidcUser.EmailVerified <- json:"email_verified"
    -  user.FirstName <- oidcUser.GivenName <- json:"given_name"
    -  user.LastName <- oidcUser.FamilyName <- json:"family_name"
    -  user.Nickname <-  oidcUser.GivenName + oidcUser.FamilyName or if empty oidcUser.Nickname
  - If the env are set to MM_LOGSETTINGS_CONSOLELEVEL: DEBUG and MM_LOGSETTINGS_FILELEVEL: DEBUG , you can see the raw OIDC info in the mattermost log
```
mattermost  | {"timestamp":"2026-01-18 01:16:26.284 +01:00","level":"debug","msg":"DEBUG: RAW OIDC CLAIMS FROM KEYCLOAK","caller":"einterfaces/oidc.go:64","path":"/oauth/oidc/complete","request_id":"7x8tams1ktdgbnuht3x8r461th","ip_addr":"172.19.0.4","user_id":"","method":"GET","claims":{"acr":"1","at_hash":"zg5hBV5m4cTeFj0ENXAsqw","aud":"mattermost","auth_time":1768695386,"azp":"mattermost","email":"davrot@uni-bremen.de","email_verified":true,"exp":1768695446,"family_name":"Rotermund","given_name":"David","iat":1768695386,"iss":"https://sso.fb1.uni-bremen.de/sso/realms/master","jti":"334f8eef-fd9b-4a5b-9d6f-4ab46b1904ae","locale":"en","name":"David Rotermund","preferred_username":"davrot@uni-bremen.de","sid":"e3645393-e1ec-4d7d-afb6-166061c9ebc1","sub":"496667d6-2ef6-4f9a-8fda-2ead5e22e7b5","typ":"ID"}}
```

## Old GIT Lab setting

As comparison
- user.Username <- json:"username" or if empty json:"login"
- user.Email <- strings.ToLower(json:"email")
- user.EmailVerified <- Not assigned
- user.Nickname <- Not assigned
- user.FirstName <- explode json:"name" at space : first segment  or if empty glu.Name
- user.LastName <- explode json:"name" at space : rest segments 
- user.AuthData <- json:"id"
- user.AuthService <- "gitlab"

## Env Settings
```
MM_OIDCSETTINGS_ENABLE=true
MM_OIDCSETTINGS_DISCOVERYENDPOINT=https://keycloak.example.com/realms/mattermost
MM_OIDCSETTINGS_ID=mattermost
MM_OIDCSETTINGS_SECRET=your-secret
MM_OIDCSETTINGS_SCOPE="openid profile email"
MM_OIDCSETTINGS_BUTTONTEXT="Login with Keycloak"
MM_OIDCSETTINGS_UPDATEUSERDETAILSONLOGIN=true
```

## Conf JSON
```
{
  "OIDCSettings": {
    "Enable": true,
    "DiscoveryEndpoint": "https://your-keycloak-server/realms/your-realm",
    "Id": "mattermost-client-id",
    "Secret": "your-client-secret",
    "Scope": "openid profile email",
    "ButtonText": "Login with Keycloak",
    "ButtonColor": "#145DBF",
    "UpdateUserDetailsOnLogin": true,
  }
}
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


