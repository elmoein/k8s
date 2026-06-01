helm repo add cilium https://helm.cilium.io/

helm template cilium cilium/cilium --version 1.19.4 \
  --namespace kube-system \
  --set ipam.mode=kubernetes \
  --set tunnelMode=vxlan \
  --set resources.limits.cpu="500m" \
  --set resources.limits.memory="1Gi" \
  --set resources.requests.cpu="100m" \
  --set resources.requests.memory="512Mi"  > cilium-manifests.yaml

cp cilium-manifests.yaml local-cilium.yaml

MY_REGISTRY="hr.12w.ir/lqi"

# 2. Use sed to replace 'quay.io' with your registry everywhere inside the file
# (On macOS, use: sed -i '' "s|quay.io|$MY_REGISTRY|g" local-cilium.yaml)
sed -i '' "s|quay.io|$MY_REGISTRY|g" local-cilium.yaml

# 3. Extract the new custom paths into the array
IMAGES=($(grep -oE "${MY_REGISTRY}/cilium/[^\"' ]+" local-cilium.yaml | sort -u))

# 4. Pull the images
for img in "${IMAGES[@]}"; do
    echo "Pulling: $img"
    #docker pull "$img"
done