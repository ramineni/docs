#!/bin/bash

DEADPROC=`ps -ef | grep [^]]kube | awk '{print $2}'`
sudo kill $DEADPROC
