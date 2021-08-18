# Information

Once cluster has been created, cilium (our CNI) needs to be installed. To do so:

1. `helm repo add cilium https://helm.cilium.io/` to add it to your local helm repo list,then `helm repo update` to fetch available helm charts.
    - NOTE: This needs only be done once on your machine. If you have already done so, proceed.
1. Helm install cilium with the values in the `cilium/cilium-values.yml` file (eg: `helm install cilium cilium/cilium -f cilium/cilium-values.yml`)

Need to create flux bootstrapping with the correct access.

First create a GH token with access and export to shell.
Then create with `flux bootstrap --owner Carnes-Consulting --repository=homecluster`. This will create the normal bootstrap.

Next, create the sops secret to allow decryption.
`kubectl create generic sops-age -n flux-system --from-file=age.agekey=PATH/TO/AGE/KEY` (likely `$HOME/.config/sops/age/keys.txt`)

## Rebuilding cluster

For my rebuilding of a cluster:

1. Apply the `machineconfig` with type `init` to start the cluster
1. After initial node has taken the VIP, edit the endpoint to point to the vip AND set type to `controlplane` over init
1. After node is rebooted, restore cluster through `talosctl bootstrap --recover-from=PATH/TO/BACKUP`
