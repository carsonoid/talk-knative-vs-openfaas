#!/bin/bash

# Wait for cluster to be ready
until kubectl get nodes &> /dev/null; do sleep 1; done

# make sure helm has cluster admin permissions
kubectl create clusterrolebinding helmadmin --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Init tiller
helm init

# wait for tiller to be ready
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system

# create OpenFaaS namespaces
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

# add OpenFaaS Helm repo
helm repo add openfaas https://openfaas.github.io/faas-netes/

# get latest chart version and install
helm repo update && helm upgrade openfaas --install openfaas/openfaas \
    --namespace openfaas  \
    --set functionNamespace=openfaas-fn \
    --set operator.create=true \
    --set faasnetes.imagePullPolicy=IfNotPresent \
    --set ingress.enabled=true

# Keep the container up, but die quickly
while :; do sleep 3; done
