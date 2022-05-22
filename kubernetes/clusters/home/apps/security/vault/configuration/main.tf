data "sops_file" "vault" {
  source_file = "secrets.sops.yaml"
}

resource "vault_database_secrets_mount" "db" {
  postgresql {
    name              = "main_postgres"
    username          = "vault"
    password          = data.sops_file.vault.data["vault.postgres.password"]
    connection_url    = "postgresql://{{username}}:{{password}}@postgres.postgres-postgresql.svc.cluster.local:5432/postgres"
    verify_connection = true
    allowed_roles = [
      "authentik",
      # "gitlab"
    ]
  }
}

resource "vault_database_secret_backend_role" "authentik" {
  name    = "authentik"
  backend = vault_database_secrets_mount.db.path
  db_name = vault_database_secrets_mount.db.postgresql[0].name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT ALL PRIVILEGES ON DATABASE authentik TO \"{{name}}\";",
  ]
}

# resource "vault_database_secret_backend_role" "gitlab" {
#   name    = "gitlab"
#   backend = vault_database_secrets_mount.db.path
#   db_name = vault_database_secrets_mount.db.postgresql[0].name
#   creation_statements = [
#     "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
#     "GRANT ALL PRIVILEGES ON DATABASE gitlab TO \"{{name}}\";",
#   ]
# }