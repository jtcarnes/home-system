# Bootstrapping Vault

Unfortunately, vault must be bootstrapped the first time it is deployed. All other times
after that (pod rescheduled), its fine. While not 100% gitops, this is the best that can
be done in context of vault.

## Procedure

1. exec into vault, unseal, copy keys and token
1. kubectl proxy local ports (8200)
1. Set env var VAULT_ADDR (localhost)
1. terraform apply

## After firstt time

After the initial bootstrap, the system can be managed by using the standard address for
VAULT_ADDR
