# crm/util/deployment-manager/matlab-flexnet

This directory contains tools for preparing a matlab-flexnet license server for a service project.

## Setup
Before using these scripts, you will need to perform the following prerequisite steps if a service project has not had a slurm-gcp cluster previously.

1. Enable the deployment manager API on the service project
```
$ gcloud services enable deploymentmanager.googleapis.com 
```

2. Give Network User permissions the service project deployment manager and compute engine service accounts on the pennbrain-host project.

## Usage

This documentation assumes you are working in cloud shell.

1. Set your project to the service project where you will deploy the slurm-gcp cluster.
```
$ gcloud config set project pennbrain-license
```
2. Modify the settings in matlab-flexnet.yaml
```
    name                    : matlab-flexnet-fileserver
    vpc_subnet              : pennbrain-license-subnet
    zone                    : us-east1-b
    region                  : us-east1
    network_tag             : pennbrain-license

    machine_type      : n1-standard-4
    boot_disk_type    : pd-standard
    boot_disk_size_gb : 50
```

3. (Recommended) Preview the deployment.
```
$ gcloud deployment-manager deployments create pennbrain-license-matlab-flexnet --config=matlab-flexnet.yaml --preview
```

4. Deploy the fileserver
```
$ gcloud deployment-manager deployments update pennbrain-license-matlab-flexnet
```


