# BSC Pilot Project - Infrastructure as Code
The scripts in this project are adapted from https://github.com/terraform-google-modules/terraform-google-project-factory.git


## Participants : 

* Gaylord Holder, Brain Science Center/U. Pennsylvania, gaylord.holder@gmail.com
* Joseph Schoonover, Fluid Numerics LLC, joe@fluidnumerics.com


## Project Scope
In this project we will create the following resources with Terraform

* A folder under which all projects are created
* A shared VPC host project
* A shared VPC (custom mode) in a host project on Google Cloud Platform
* A subnet for a MATLAB license server
* Firewall rules to permit access to the license server
* A MATLAB license server
* A service project

## About this repository
This repository contains two main directories
1. modules
2. resources

### Modules
The modules subdirectory contains terraform modules for creating a host project (VPC Host Project) and service projects.

The host project is used for managing the VPC network, subnets, and firewall rules.

Service projects are used for hosting compute and storage resources for researchers at the Brain Science Center.


### Resources
The resources subdirectory contains the main terraform scripts that manage the creation of a parent folder, host project, and all of the service projects and their resources.
When managing infrastructure at the BSC, you will primarily work in the resources subdirectory, unless you are making changes to the individual components that are deployed.

## Getting started

### Assumptions
To use terraform to create the resources listed above, we are assuming

1. A GCP project already exists (called the admin project) from which we can host a service account for executing terraform commands.
2. This project exists within a GCP folder or exists directly below the organization node
3. Users working on this project have Folder Admin/Organization Admin privileges at the folder or organization level
4. Users working on this project are conducting work in Cloud Shell.


### Initial project setup
Within the admin project, you will need to create a service account that will execute terraform commands. The first few steps of [this tutorial](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform) ( up to "Getting Project Credentials" ) provides a walkthrough of how to do this.

After creating the service account, you will want to create a json authentication key. Download and store this key securely (preferably in your cloud shell)

For the purposes of this project, this service account must be provided Folder/Organization Admin privileges so that it is able to provision new projects and create IAM rules.


**A word of caution** : This service account has a lot of privileges. You must store the authentication keys securely to prevent unauthorized access.

If the service account has already been created, but you need a key, you can create an additional key. From https://console.cloud.google.com

1. Go to IAM&Admin > Service Accounts
2. Click on the service account associated with using terraform ( e.g.  terraform@pennbrain-center.iam.gserviceaccount.com )
3. Click "Edit" on the top of the UI
4. Click "+ Create Key"
5. Following the prompt, choose JSON, and click create. This will download the credentials in json format to your local system.

You will need to store the service account credential keys in your Cloud Shell. Once you have created and downloaded the account keys, open cloud shell. Create a directory to store your credentials
```
mkdir -p ~/.terraform_creds
```
Upload the json key by clicking the triple-dot menu on the top-right of cloud shell and then clicking "Upload File". Follow the prompts to upload your json key from your local system. Once the upload is complete, move the key,
```
mv ~/<your-key>.json ~/.terraform_creds/
```
When using the scripts in this repository, you can now set
```
credentials_path = /home/<username>/.terraform_creds/<your-key>.json
```
in your terraform variables files.


### Download this repository

```
git clone https://bitbucket.org/fluidnumerics/bsc-pilot-project
cd bsc-pilot-project
```




