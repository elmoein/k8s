#!/bin/bash

set -e

MY_REGISTRY="hr.12w.ir/lk8"

MAIN_REGISTRY="registry.k8s.io"

NAMESPACE="k8s.io"


IMAGES=(
    "kube-apiserver:v1.36.1"
    "kube-controller-manager:v1.36.1"
    "kube-scheduler:v1.36.1"
    "kube-proxy:v1.36.1"
    "coredns/coredns:v1.14.2"
    "pause:3.10.2"
    "pause:3.10.1"
    "etcd:3.6.8-0"
)


echo "🚀 Starting to pull and retag images..."

for IMG in "${IMAGES[@]}"; do

    SOURCE_IMAGE="${MY_REGISTRY}/${IMG}"
    TARGET_IMAGE="${MAIN_REGISTRY}/${IMG}"

    echo -e "\n----------------------------------------\n"
    echo "⬇️ Pulling from your registry: $SOURCE_IMAGE"
    
    ctr -n "$NAMESPACE" images pull "$SOURCE_IMAGE"

    ctr images pull "$SOURCE_IMAGE"

   echo "🏷️ Retagging to official: $TARGET_IMAGE"
    
    
    ctr -n "$NAMESPACE" images tag "$SOURCE_IMAGE" "$TARGET_IMAGE"
    ctr images tag "$SOURCE_IMAGE" "$TARGET_IMAGE"
    
    echo "🗑️ Removing the temporary source tag to save space..."
    
#    ctr -n "$NAMESPACE" images rm "$SOURCE_IMAGE"
done


 ctr images tag ${MY_REGISTRY}/coredns/coredns:v1.14.2 ${MY_REGISTRY}/coredns:v1.14.2
 ctr -n "$NAMESPACE" images tag ${MY_REGISTRY}/coredns/coredns:v1.14.2 ${MY_REGISTRY}/coredns:v1.14.2

echo "---------*--------"
echo "✅ All images pulled and successfully retagged!"
echo "🔍 Verifying with crictl:"
crictl img