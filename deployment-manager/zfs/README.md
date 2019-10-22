# crm/util/deployment-manager/zfs

This directory contains tools for preparing a zfs fileserver for a user project.

## Setup
Before using these scripts, you will need to perform the following prerequisite steps if a user project has not user deployment manager previously.

1. Enable the deployment manager API on the user project
```
$ gcloud services enable deploymentmanager.googleapis.com 
```

2. Give Network User permissions the user project deployment manager and compute engine service accounts on the pennbrain-host project.

## Usage

This documentation assumes you are working in cloud shell.

1. Set your project to the user project where you will deploy the slurm-gcp cluster.
```
$ gcloud config set project detre-group-dd34a9
```
2. (Recommended) Copy zfs.yaml to a new file, named after the project you will be deploying this resource to
```
$ cp zfs.yaml detre-group-zfs.yaml
```

3. Modify the service project settings and file server settings in your copy of zfs.yaml
**Service Project Settings**
```
    name                    : zfs-fileserver
    vpc_subnet              : detre-group-subnet
    zone                    : us-east1-b
    region                  : us-east1
    network_tag             : detre-group
```
**File Server Settings**
```
    # Fileserver Settings
    machine_type      : n1-standard-4
    boot_disk_type    : pd-standard
    boot_disk_size_gb : 50

    storage_disk_type    : pd-standard
    storage_disk_size_gb : 5000
```

4. (Recommended) Preview the deployment.
```
$ gcloud deployment-manager deployments create detre-group-zfs --config=detre-group-zfs.yaml --preview
The fingerprint of the deployment is EsV-ZjPy_jF17q1rO7DHjg==
Waiting for create [operation-1571765879694-5958342ede4bd-4a66d117-2e9a66d8]...done.
Create operation operation-1571765879694-5958342ede4bd-4a66d117-2e9a66d8 completed successfully.
NAME            TYPE                 STATE       ERRORS  INTENT
zfs-fileserver  compute.v1.instance  IN_PREVIEW  []      CREATE_OR_ACQUIRE
```

5. Deploy the fileserver
```
$ gcloud deployment-manager deployments update zfs
```


