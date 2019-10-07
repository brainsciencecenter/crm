#!/usr/bin/env python3

import argparse
import os
import googleapiclient.discovery
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

SCOPES = ['https://www.googleapis.com/auth/admin.directory.user']

def get_credentials():

    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    return creds


def get_directory_service():

    creds = get_credentials()
    service = googleapiclient.discovery.build('admin', 'directory_v1', credentials=creds)

    return service

def update_user_posix_credentials(user_email, home_dir, username, shell, uid, gid):

    service = get_directory_service()

    user = service.users().get(userKey=user_email).execute()

    # Verify that the user has a posixAccount

    posix_account = user['posixAccounts'][0]
    print('Existing POSIX account info:')
    print(posix_account)

    # Update credentials

    if home_dir:
        posix_account['homeDirectory'] = home_dir

    if username:
        posix_account['username'] = username

    if shell:
        posix_account['shell'] = shell

    if uid:
        posix_account['uid'] = str(uid)

    if gid:
        posix_account['gid'] = str(gid)

    update_command = service.users().update(userKey=user_email,
                                            body={'posixAccounts': [posix_account]})
    update_command.execute()

    print('POSIX account info updated; changes may take a few seconds to propagate. '
          'Check `gcloud beta compute os-login describe-profile` for changes')


def main():

    parser = argparse.ArgumentParser(description='Utility for modifying POSIX user information associated with Cloud Identity Account.')
    parser.add_argument('user_email')
    parser.add_argument('--home_dir', help='new home directory for the user')
    parser.add_argument('--username', help='new username for the user')
    parser.add_argument('--shell', help='new shell for the user')
    parser.add_argument('--uid', choices=range(1001, 65000), metavar='[1001-64999]',
                           type=int, help='new user ID for the user')
    parser.add_argument('--gid', type=int, help='new group ID for the user')

    args = parser.parse_args()

    update_user_posix_credentials(**vars(args))


if __name__ == '__main__':
    main()
