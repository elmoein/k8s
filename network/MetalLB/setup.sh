helm repo add metallb https://metallb.github.io/metallb
helm repo update

# helm install my-metallb metallb/metallb --version 0.16.1  --namespace metallb-system --dry-run

helm template my-metallb metallb/metallb --version 0.16.1  --namespace metallb-system > local-metallb.yaml

MY_REGISTRY="hr.12w.ir/lqi"

# 2. Use sed to replace 'quay.io' with your registry everywhere inside the file
# (On macOS, use: sed -i '' "s|quay.io|$MY_REGISTRY|g" local-metallb.yaml)
sed -i '' "s|quay.io|$MY_REGISTRY|g" local-metallb.yaml

# 3. Extract the new custom paths into the array
IMAGES=($(grep -oE "${MY_REGISTRY}[^\"' ]+" local-metallb.yaml | sort -u))

# 4. Pull the images
for img in "${IMAGES[@]}"; do
    echo "Pulling: $img"
 #   docker pull "$img"
done

kubectl create namespace metallb-system
kubectl apply -f local-metallb.yaml --namespace metallb-system --server-side

kubectl apply -f ip-pool.yaml --namespace metallb-system --server-side