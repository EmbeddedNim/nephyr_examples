#!/bin/sh 

for i in `seq 500`; do echo $i; curl $IP:8181; done 


