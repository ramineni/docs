#!/bin/bash

KCTL=$working_dir/kubernetes/cluster/kubectl.sh

export KUBERNETES_PROVIDER=local

$KCTL config set-cluster local --server=https://localhost:6443 --certificate-authority=/var/run/kubernetes/server-ca.crt
$KCTL config set-credentials myself --client-key=/var/run/kubernetes/client-admin.key --client-certificate=/var/run/kubernetes/client-admin.crt
$KCTL config set-context local --cluster=local --user=myself
$KCTL config use-context local

# RBAC rules
cd $working_dir/cloud-provider-openstack
$KCTL create -f cluster/addons/rbac/

$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:default kube-system-cluster-admin-1 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:pvl-controller kube-system-cluster-admin-2 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:cloud-node-controller kube-system-cluster-admin-3 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:cloud-controller-manager kube-system-cluster-admin-4 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:shared-informers kube-system-cluster-admin-5 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:kube-controller-manager  kube-system-cluster-admin-6 --clusterrole cluster-admin
$KCTL create clusterrolebinding --user system:serviceaccount:kube-system:attachdetach-controller kube-system-cluster-admin-7 --clusterrole cluster-admin
$KCTL set subject clusterrolebinding system:node --group=system:nodes

# For cinder-csi
$KCTL create -f manifests/cinder-csi-plugin

