#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

MASTER_IP="150.150.100.10"
NODENAME=$(hostname -s)
POD_CIDR="10.150.0.0/16"

sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --upload-certs

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

source <(kubectl completion bash) # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

#curl https://docs.projectcalico.org/manifests/calico.yaml -O
#kubectl apply -f calico.yaml

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

