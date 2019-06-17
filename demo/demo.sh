#!/bin/bash

. ./demo-magic.sh -n

export TYPE_SPEED=60
export DEMO_COMMENT_COLOR=$CYAN

p "# wait for faas gateway to be ready"
pe "kubectl -n openfaas rollout status -w deployment/gateway"
wait

# determine the generated nodeport for the gateway-ext service
GATEWAY_NODEPORT=$(kubectl -n openfaas get svc gateway-external -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
NODE_IP=$(kubectl get nodes --selector=kubernetes.io/role!=master -o jsonpath={.items[*].status.addresses[?\(@.type==\"InternalIP\"\)].address} |head -n 1)

p "# Install our test function"
pe "faas-cli --gateway=$NODE_IP:$GATEWAY_NODEPORT deploy -f get-tax.yml"
wait

p "# Invoke the test function with faas-cli"
pe "echo '{\"subtotal\":100}' | faas-cli --gateway=$NODE_IP:$GATEWAY_NODEPORT invoke get-tax"
wait

# p "# overload the function with vegeta"
pe "echo \"GET http://$NODE_IP:$GATEWAY_NODEPORT/function/get-tax\" | vegeta attack -body <( echo '{\"subtotal\":100}') | vegeta report --type hist[0,100ms,200ms,300ms,400ms,500ms,600ms,1s]"

# ----------------------------- Proxy
p "# Proxy connection into the faas gateway release 1 pod, Control-C to kill and continue"
p "# Access the forwarded service via http://127.0.0.1:9999"
pe "kubectl -n openfaas port-forward svc/gateway 9999:8080"

p "# Demo done! Feel free to use continue to use kubectl or faas-cli. Or run ./cleanup.sh to delete everything"
