# Build and push

    docker build -t houseofmoran/lsystemsed:0.6.1_3 .
    docker push houseofmoran/lsystemsed:0.6.1_3

# Apply

First, set up kubectl to point at a cluster (e.g. [Digital Ocean](./k8s/README.do.md)) then do:

    kubectl apply -f k8s/namespace.yaml
    export NAMESPACE=lsystemsed
    kubectl apply --namespace=${NAMESPACE} -f k8s/deployment.yaml
    kubectl apply --namespace=${NAMESPACE} -f k8s/service.yaml
    kubectl apply --namespace=${NAMESPACE} -f k8s/ingress.yaml
