# BSC Pilot Project - Infrastructure as Code
The scripts in this project are adapted from https://github.com/terraform-google-modules/terraform-google-project-factory.git


## Participants : 

* Gaylord Holder, Brain Science Center/U. Pennsylvania, gaylord.holder@gmail.com
* Joseph Schoonover, Fluid Numerics LLC, joe@fluidnumerics.com


## Project Scope
In this project we will create the following resources with Terraform

* A shared VPC host project
* A shared VPC (custom mode) in a host project on Google Cloud Platform
* A subnet for a MATLAB license server
* Firewall rules to permit access to the license server
* A MATLAB license server
* A service project



## Getting started

### Assumptions
To use terraform to create the resources listed above, we are assuming

1. A GCP project already exists that we will want to set as the VPC host project. From hereon we refer to this project as the "host project"
2. This project exists within a GCP folder or exists directly below the organization node
3. Users working on this project have Folder Admin/Organization Admin privileges at the folder or organization level
4. Users working on this project are conducting work in Cloud Shell.


### Initial project setup
If the initial project setup has already been completed, you can proceed to "Obtaining the service account credentials key".

Within the host project, you will need to create a service account that will execute terraform commands. The first few steps of [this tutorial](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform) ( up to "Getting Project Credentials" ) provides a walkthrough of how to do this.

After creating the service account, you will want to create a json authentication key. Download and store this key securely (preferably in your cloud shell)

For the purposes of this project, this service account must be provided Folder/Organization Admin privileges so that it is able to provision new projects and create IAM rules.


**A word of caution** : This service account has a lot of privileges. You must store the authentication keys securely to prevent unauthorized access.


### Obtaining the service account credentials key


### Download this repository

```
git clone https://bitbucket.org/fluidnumerics/bsc-pilot-project
cd bsc-pilot-project
```




