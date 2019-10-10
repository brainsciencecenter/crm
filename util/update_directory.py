#!/usr/bin/python

import pickle
import argparse
import os
import googleapiclient.discovery
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

import pprint
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

def update_user_posix_credentials(user_email, home_dir, username, shell, uid, gid, key):

    service = get_directory_service()

    user = service.users().get(userKey=user_email).execute()

    # Verify that the user has a posixAccount

    if 'posixAccounts' in user.keys():
        posix_account = user['posixAccounts'][0]
        print('Existing POSIX account info:')
        print(posix_account)

        # Update credentials
        posix_modified = False

        if home_dir:
            posix_account['homeDirectory'] = home_dir
            posix_modified = True

        if username:
            posix_account['username'] = username
            posix_modified = True

        if shell:
            posix_account['shell'] = shell
            posix_modified = True

        if uid:
            posix_account['uid'] = str(uid)
            posix_modified = True

        if gid:
            posix_account['gid'] = str(gid)
            posix_modified = True

        if posix_modified:
            update_command = service.users().update(userKey=user_email,
                                                    body={'posixAccounts': [posix_account]})
            update_command.execute()


            print('POSIX account info updated; changes may take a few seconds to propagate. '
                  'Check `gcloud beta compute os-login describe-profile` for changes')

        if key:
            public_keys = user['sshPublicKeys'][0]
            public_keys['key'] = key
            update_command = service.users().update(userKey=user_email,
                                                body={'sshPublicKeys': [public_keys]})
            update_command.execute()
            print('Public RSA Key info updated; changes may take a few seconds to propagate. '
                  'Check `gcloud beta compute os-login describe-profile` for changes')

    else:
        print('Error: posixAccounts is not associated with output of admin.users().get()')
        pprint.pprint( user )
        print('Nothing updated')


def main():

    parser = argparse.ArgumentParser(description='Utility for modifying POSIX user information')
    parser.add_argument('user_email')
    parser.add_argument('--home_dir', help='new home directory for the user')
    parser.add_argument('--username', help='new username for the user')
    parser.add_argument('--shell', help='new shell for the user')
    parser.add_argument('--uid', choices=range(1001, 65000), metavar='[1001-64999]',
                           type=int, help='new user ID for the user')
    parser.add_argument('--gid', type=int, help='new group ID for the user')
    parser.add_argument('--key', type=str, help='new public RSA key for the user')

    args = parser.parse_args()

    update_user_posix_credentials(**vars(args))

    # update_user_rsa_keys
    

if __name__ == '__main__':
    main()
