# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

mkdir -p $HOME/.kube
# Explore the API with TOKEN
cat <<EOF > $HOME/.kube/config
apiVersion: v1
kind: Config
clusters:
- name: local
  cluster:
    certificate-authority: ${CACERT}
    server: ${APISERVER}
contexts:
- name: local
  context:
    cluster: local
    namespace: ${NAMESPACE}
    user: serviceaccount
current-context: local
users:
- name: serviceaccount
  user:
    tokenFile: ${SERVICEACCOUNT}/token
EOF
