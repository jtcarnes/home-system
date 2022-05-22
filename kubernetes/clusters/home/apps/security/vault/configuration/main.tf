data "sops_file" "vault" {
  source_file = "secrets.sops.yaml"
}

resource "vault_mount" "db" {
  path = "database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend           = vault_mount.db.path
  name              = "main_postgres"
  verify_connection = true
  allowed_roles = ["*"]

  postgresql {
    # connection_url = "postgresql://{{username}}:{{password}}@postgres.postgres-postgresql.svc.cluster.local:5432/postgres?sslmode=disable"
    # username       = "vault"
    # password       = data.sops_file.vault.data["vault.postgres.password"]
    connection_url = "postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable"
    username = "postgres"
    password = "testpass"
  }
}


resource "vault_database_secret_backend_role" "authentik" {
  name    = "authentik"
  backend = vault_mount.db.path
  db_name = vault_database_secret_backend_connection.postgres.name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT ALL PRIVILEGES ON DATABASE authentik TO \"{{name}}\";",
  ]
}

# resource "vault_kubernetes_auth_backend_role" "authentik" {
#   role_name                        = "authentik"
#   bound_service_account_names      = ["authentik"]
#   bound_service_account_namespaces = ["authentik"]
#   token_ttl                        = 3600
# }

# resource "vault_database_secret_backend_role" "gitlab" {
#   name    = "gitlab"
#   backend = vault_mount.db.path
#   db_name = vault_database_secret_backend_connection.postgres.name
#   creation_statements = [
#     "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
#     "GRANT ALL PRIVILEGES ON DATABASE gitlab TO \"{{name}}\";",
#   ]
# }

resource "vault_identity_oidc_provider" "authentik" {
  name          = "authentik"
  https_enabled = false
  issuer_host   = "authentik.authentik.svc.cluster.local"
  allowed_client_ids = [
    "*"
  ]
  scopes_supported = [
    # "*"
  ]
}
