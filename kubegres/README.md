# Install PostgreSQL through the Kubegres

## How to deploy

### Create Kubegres Controller
```
cd kubegres
kubectl apply -f kubegres_controller_v1.17.yml
```
Note: You must wait until all resources are created.

### Create the namespace used for Postgres
```
kubectl create namespace postgres-demo
```

### Create secrets used by Postgres Cluster and PgAdmin
```
kubectl apply -n postgres-demo -f .\my-postgres-secrets.yml
kubectl apply -n postgres-demo -f .\pgadmin-secrets.yml
```

### Create PostgresSQL Cluster
```
kubectl apply -n postgres-demo -f my-postgres-cluster.yml
```

### Get the IP used for Traefik
```
kubectl get node/$env:COMPUTERNAME -o=jsonpath="{range .status.addresses[?(@.type == 'InternalIP')]}{.address}{end}"
```
Note: Edit my-pgadmin.yml with the ip outputted into the host for Ingress. E.g.: host: "pgadmin-dev.\<IP\>.sslip.io"

### Create PgAdmin Server
```
kubectl apply -n postgres-demo -f my-pgadmin.yml
```

### Get PgAdmin URL: 
```
echo "http://$(kubectl get ing -n postgres-helmdemo pgadmin-http -o=jsonpath='{@.spec.rules[0].host}')"
```

### Default Credentials
- pgadmin email => admin@posgresql.local
- pgadmin password => PostgreSql123Admin
- postgresql user => postgres
- postgresql pass => PostgreSql123Admin

Note: They can be modified via my-pgadmin-secrets.yml and my-postgres-secret.yml files.

## How to clean up
```
kubectl delete -n postgres-demo -f my-pgadmin.yml
kubectl delete -n postgres-demo -f my-postgres-cluster.yml
kubectl delete -n postgres-demo -f my-postgres-secrets.yml
kubectl delete -n postgres-demo -f pgadmin-secrets.yml
kubectl delete namespace postgres-demo
kubectl delete -f kubegres_controller_v1.17.yml
```

## Techs: 
* Runcher Desktop (Kubernetes + Docker + Traefik)
* Kubegress

## Reference: 
- https://www.kubegres.io/doc/getting-started.html
- https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data
- https://kubernetes.io/docs/concepts/configuration/secret/#opaque-secrets
- https://docs.rancherdesktop.io/how-to-guides/traefik-ingress-example
