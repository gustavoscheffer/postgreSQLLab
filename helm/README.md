# Install PostgreSQL through the Helm Chart.

The instructions below are going to install PostgresSQL server + PgAdmin Web.

## How to deploy

### Download the values from original chart
```
helm show values  oci://registry-1.docker.io/bitnamicharts/postgresql > postgres-values.yml
```
Note: Edit the values.yml file according to your necessity.

### Create the namespace used to host the new Postgres cluster 
```
kubectl create namespace postgres-helmdemo
```

### Exeute helm install using the values.yml 
```
helm install --values postgres-values.yml -n postgres-helmdemo mypostgres oci://registry-1.docker.io/bitnamicharts/postgresql
```

### Deploy PgAdmin
```
# Used to install repo
helm repo add truecharts https://charts.truecharts.org/

helm install my-pgadmin truecharts/pgadmin `
    --version 11.0.10 `
    --namespace postgres-helmdemo `
    --set workload.main.podSpec.containers.main.env.PGADMIN_DEFAULT_EMAIL=gustavo.scheffer@mechabuda.com,workload.main.podSpec.containers.main.env.PGADMIN_DEFAULT_PASSWORD=MojaZona123#
```

### Get the IP used for Traefik
```
kubectl get node/$env:COMPUTERNAME -o=jsonpath="{range .status.addresses[?(@.type == 'InternalIP')]}{.address}{end}"
```
Note: Edit pgadmin-ingress.yml with the ip outputted into the host for Ingress. E.g.: host: "pgadmin-dev.\<IP\>.sslip.io"

### Create ingress
```
kubectl apply -f pgadmin-ingress.yml -n postgres-helmdemo
```

### Get PgAdmin URL: 
```
echo "http://$(kubectl get ing -n postgres-helmdemo pgadmin-http -o=jsonpath='{@.spec.rules[0].host}')"
```

### Get the database password to configure the connection via PgAdmin
```
$enc_pg_pass = (kubectl get secret --namespace postgres-helmdemo mypostgres-postgresql -o jsonpath="{.data.postgres-password}")
[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($enc_pg_pass))
```

## Clean up
```
cd helm
kubectl delete -n postgres-helmdemo -f pgadmin-ingress.yml
helm uninstall -n postgres-helmdemo my-pgadmin mypostgres
kubectl delete namespace postgres-helmdemo
```

## Tech
* Rancher 
  * Helm 
  * Kubernetes
  * Traefik
  * Docker

## Reference
- https://docs.rancherdesktop.io/getting-started/installation/
- https://docs.rancherdesktop.io/how-to-guides/traefik-ingress-example
- https://helm.sh/docs/intro/using_helm/
- https://github.com/truecharts/charts/tree/master/charts/stable/pgadmin