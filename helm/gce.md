1. Create GCE cluster
At least 3 nodes and 6Gb/Node,
disable Google Load Balancer (we'll use Nginx Controller)

2. Create helm user
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

3. Helm init with serviceaccount
`helm init --service-account tiller`

4. Add regcred
`kubectl --namespace helm create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username={{user}} --docker-password={{password}} --docker-email={{email}}`

5. Helm install
`helm --namespace helm install . --set ingress.enabled=true --set ingress.hosts[0]=cl2.km.io --set pullPolicy=Always`

6. Ingress
Example with a Nginx DeamonSet (but you can use whatever you want)
`helm --namespace nginx install stable/nginx-controller --set controller.kind=DaemonSet --set controller.daemonset.useHostPort=true`

7. DNS
Configure your DNS to your nodes
