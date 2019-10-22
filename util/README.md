# crm/utils

This directory contains useful tools for managing Cloud Identity and OS Login information.

## Getting Started

### Enable APIs
```
gcloud services enable admin.googleapis.com
```

### Creating new credentials
1. On your local system
```
pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

2. Go to https://console.cloud.google.com

3. Navigate to APIs & Services > OAuth Consent Screen

4. Set `Application Type = Internal` and `Application Name = Update Directory`. Click Save.

5. Navigate to APIs & Services > Credentials

6. Create Credentials > OAuth Client ID. Set the Application Type to Other. Provide a name for the application/auth token (e.g. python client). Click "OK" at the prompt.

7. To the right of your new credentials, click on the Download icon

8. On your local system, move the downloaded json to this directory with the filename "credentials.json"
```
mv ~/Downloads/client_secret.json ./credentials.json
```

## Updating user POSIX information
The provided script `update_directory.py` is used to update the POSIX username, user id (uid), group id (gid), home directory, and default shell associated with a Cloud Identity or GSuite e-mail address.

```
python update_directory.py joe@fluidnumerics.com --username=joe --uid=2001 --gid=2000 --home_dir=/home/joe --shell="/bin/bash" -key=$(cat /home/joe/.ssh/id_rsa.pub)
```

