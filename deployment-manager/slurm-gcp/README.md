# crm/util/deployment-manager/slurm-gcp

This directory contains tools for preparing a slurm-gcp cluster for a user project.
Slurm-GCP is an open source deployment, currently brought in from https://github.com/fluidnumerics/slurm-gcp

The tools in this directory are used to create additional network resources (cloud router) for the shared VPC

## Setup
Before using these scripts, you will need to perform the following prerequisite steps if a user project has not had a slurm-gcp cluster previously.

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
2. (Recommended) Copy slurm-cluster.yaml to a new file, named after the project you will be deploying this resource to
```
$ cp slurm-cluster.yaml detre-group-slurm.yaml
```

3. Modify the service project settings and slurm-gcp cluster settings in your copy of slurm-cluster.yaml
**Service Project Settings**
```
    cluster_name            : dg-slurm
    vpc_subnet              : detre-group-subnet
    cidr                    : 10.20.0.0/16
    zone                    : us-east1-b
    region                  : us-east1
    default_users           : "holder, detre, sdolui, wtackett, sdas"
```
**Slurm-GCP Partitions**
```
    # Controller Settings
    controller_machine_type : n1-standard-4
    controller_disk_type    : pd-standard
    controller_disk_size_gb : 100
    
    # Login Settings
    login_machine_type      : n1-standard-4
    login_disk_type         : pd-standard
    login_disk_size_gb      : 10

    # Elastic Compute node partition settings
    partitions :

           - name           : n1-standard-32
             machine_type   : n1-standard-32
             max_node_count : 100 
             zone           : us-east1-b
             compute_disk_type          : pd-standard
             compute_disk_size_gb       : 10
             compute_labels             :
                   partition     : n1-standard-32
                   instance_type : compute
```

4. (Recommended) Preview the deployment.
```
$ gcloud deployment-manager deployments create dg-slurm --config=detre-group-slurm.yaml --preview
The fingerprint of the deployment is OrEmaxNvFYcQ6awScPfoxw==
Waiting for update [operation-1570813646320-594a58d65b43c-55c59c18-437ba13a]...done.                                                                                                                 
Update operation operation-1570813646320-594a58d65b43c-55c59c18-437ba13a completed successfully.
NAME                           TYPE                 STATE       ERRORS  INTENT
dg-slurm-compute-image-000000  compute.v1.instance  IN_PREVIEW  []      CREATE_OR_ACQUIRE
dg-slurm-controller            compute.v1.instance  IN_PREVIEW  []      CREATE_OR_ACQUIRE
dg-slurm-login1                compute.v1.instance  IN_PREVIEW  []      CREATE_OR_ACQUIRE
```

5. Deploy the cluster
```
$ gcloud deployment-manager deployments update dg-slurm
The fingerprint of the deployment is aPZnI9-AEKWoXRJUyfITGg==
Waiting for update [operation-1570813921880-594a59dd26b50-446fcd70-e88f3900]...done.                                                                                                                 
WARNING: Update operation operation-1570813921880-594a59dd26b50-446fcd70-e88f3900 completed with warnings:
---
code: EXTERNAL_API_WARNING
data:
- key: disk_size_gb
  value: '100'
- key: image_size_gb
  value: '10'
message: "Disk size: '100 GB' is larger than image size: '10 GB'. You might need to\
  \ resize the root repartition manually if the operating system does not support\
  \ automatic resizing. See https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd\
  \ for details."

NAME                           TYPE                 STATE      ERRORS  INTENT
dg-slurm-compute-image-000000  compute.v1.instance  COMPLETED  []
dg-slurm-controller            compute.v1.instance  COMPLETED  []
dg-slurm-login1                compute.v1.instance  COMPLETED  []
```


