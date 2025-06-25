
minikube start --cpus=4 --memory=6144 --disk-size=100g --kubernetes-version=v1.31.0
kubectl create namespace seata-cluster   
kubectl apply -f .
watch kubectl get all -n seata-cluster   
kubectl port-forward service/seata-server 8091:8091 -n seata-cluster

## Metrics
> kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
> verify it: kubectl get deployment metrics-server -n kube-system
> kubectl top pod -n seata-cluster
