# slurm-gcp/tests/shallow_water

This directory contains a sample slurm batch script and Matlab shallow water equations solver that demonstrates barotropic instability. ( http://www.met.reading.ac.uk/~swrhgnrj/shallow_water_model/ )

You can use these files to verify that the Matlab clients on the compute nodes can successfully execute
Matlab programs and communicate with the FlexNet server.

1. Clone the crm repository to your slurm-gcp login node
2. Submit a batch job
```
$ cd crm/deployment-manager/matlab/shallow_water/
$ sbatch test.slurm
```
3. The output of the script can be found in a slurm output file and should look like
```
dg-slurm-compute000000
Wed Oct 23 17:36:21 UTC 2019

                            < M A T L A B (R) >
                  Copyright 1984-2019 The MathWorks, Inc.
              R2019a Update 5 (9.6.0.1174912) 64-bit (glnxa64)
                               July 31, 2019

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> Time = 0 hours (max 24); max(|u|) = 0
Time = 1 hours (max 24); max(|u|) = 5.2922
Time = 2 hours (max 24); max(|u|) = 4.4662
Time = 3 hours (max 24); max(|u|) = 5.5728
Time = 4 hours (max 24); max(|u|) = 4.4838
Time = 5 hours (max 24); max(|u|) = 3.5428
Time = 6 hours (max 24); max(|u|) = 2.8437
Time = 7 hours (max 24); max(|u|) = 2.3361
Time = 8 hours (max 24); max(|u|) = 1.9519
Time = 9 hours (max 24); max(|u|) = 1.6946
Time = 10 hours (max 24); max(|u|) = 1.6396
Time = 11 hours (max 24); max(|u|) = 1.6039
Time = 12 hours (max 24); max(|u|) = 2.7026
Time = 13 hours (max 24); max(|u|) = 1.8047
Time = 14 hours (max 24); max(|u|) = 1.5555
Time = 15 hours (max 24); max(|u|) = 1.667
Time = 16 hours (max 24); max(|u|) = 1.6996
Time = 17 hours (max 24); max(|u|) = 1.7182
Time = 18 hours (max 24); max(|u|) = 1.7277
Time = 19 hours (max 24); max(|u|) = 1.7232
Time = 20 hours (max 24); max(|u|) = 1.7109
Time = 21 hours (max 24); max(|u|) = 1.6925
Time = 22 hours (max 24); max(|u|) = 1.6806
Time = 23 hours (max 24); max(|u|) = 1.7442
Time = 24 hours (max 24); max(|u|) = 2.0099

```
