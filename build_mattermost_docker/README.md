# First

Set version-Number in first line  of extract_code.sh

```
chmod +x ./extract_code.sh
./extract_code.sh
```

# Second

## Build with docker

```
cd mattersource
build_with_docker.sh
```

## Build without docker

```
cd mattersource
build_without_docker.sh
```

# Env Settings
```
MM_OIDCSETTINGS_ENABLE=true
MM_OIDCSETTINGS_DISCOVERYENDPOINT=https://keycloak.example.com/realms/mattermost
MM_OIDCSETTINGS_ID=mattermost
MM_OIDCSETTINGS_SECRET=your-secret
MM_OIDCSETTINGS_SCOPE="openid profile email"
MM_OIDCSETTINGS_BUTTONTEXT="Login with Keycloak"
MM_OIDCSETTINGS_UPDATEUSERDETAILSONLOGIN=true
MM_OIDCSETTINGS_ALLOWEDEMAILDOMAINS="example.com,*.example.org"
MM_OIDCSETTINGS_ADMINGROUPNAMES="administrators"
```

# Conf JSON
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
    "AllowedEmailDomains": "example.com,*.example.org",
    "AdminGroupNames": "administrators,system-admins"
  }
}
```
