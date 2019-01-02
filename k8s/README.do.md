# Create / Destroy cluster

Following creates/destroys a dev cluster on Digital Ocean, automatically setting/unsetting the local kubectl to use that cluster

    doctl kubernetes cluster create lsystemsed-dev --tag dev
    kubectl config use-context do-nyc1-lsystemsed-dev
    kubectl config set-context do-nyc1-lsystemsed-dev --namespace lsystemsed
    doctl kubernetes cluster delete lsystemsed-dev

# Apply
