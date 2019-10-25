# slurm-gcp/tests

This directory contains a sample slurm batch script and Matlab "Hello World" script.

You can use these files to verify that the Matlab clients on the compute nodes can successfully execute
Matlab programs and communicate with the FlexNet server.

1. Upload test.m and test.slurm to your slurm-gcp login node
2. Submit a batch job
```
sbatch test.slurm
```
3. The output of the script can be found in a slurm output file and should look like
```
[joeschoonover@dg-slurm-login1 ~]$ cat slurm-23.out 
dg-slurm-compute000000
Tue Oct 22 01:02:45 UTC 2019

                            < M A T L A B (R) >
                  Copyright 1984-2019 The MathWorks, Inc.
              R2019a Update 5 (9.6.0.1174912) 64-bit (glnxa64)
                               July 31, 2019

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> >> Hello World!
```
