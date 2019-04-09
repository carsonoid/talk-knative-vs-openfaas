#!/bin/bash

# build and export the test fn image so it doesn't have to be uploaded to a registry
mkdir preload-images
faas-cli build -f get-tax.yml ; docker save -o preload-images/get-tax.tar carsonoid/get-tax:openfaas

# Make sure kubeconfig.yaml exists as a file
touch kubeconfig.yaml

# Bring up the server, recreate anon volumes
docker-compose up -d -V

export KUBECTL="kubectl --kubeconfig=kubeconfig.yaml "

# watch the create resources
watch -c bash -c : '
for ns in openfaas openfaas-fn; do
echo "#=================== $ns"
for obj in deployments pods; do
    echo "################ $obj"
    $KUBECTL -n $ns get $obj
    echo
done
done
'
