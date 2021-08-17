# Information

Need to create flux bootstrapping with the correct access.

First create a GH token with access and export to shell.
Then create with `flux bootstrap --owner Carnes-Consulting --repository=homecluster`. This will create the normal bootstrap.

Next, create the sops secret to allow decryption.
`kubectl create generic sops-age -n flux-system --from-file=age.agekey=PATH/TO/AGE/KEY` (likely `$HOME/.config/sops/age/keys.txt`)
