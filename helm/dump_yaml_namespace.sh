#!/bin/bash

NAMESPACE=$1

if [ -z $1 ]; then
    NAMESPACE="default"
    exit 1
fi

echo "Using namespace \"${NAMESPACE}\"."

BASE_DIR="namespaces/$NAMESPACE"

mkdir -p $BASE_DIR

for n in $(kubectl get -o=name pvc,configmap,serviceaccount,secret,ingress,service,deployment,statefulset,hpa,job -n $NAMESPACE)
do
    mkdir -p $BASE_DIR/$(dirname $n)
    kubectl -n $NAMESPACE get -o=yaml --export $n > $BASE_DIR/$n.yaml
done
