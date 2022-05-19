# GeoIP blocking

resource "cloudflare_filter" "countries" {
  zone_id     = cloudflare_zone.main_zone.id
  description = "Expression to block all countries except US"
  expression  = "(ip.geoip.country ne \"US\")"
}

resource "cloudflare_firewall_rule" "countries" {
  zone_id     = cloudflare_zone.main_zone.id
  description = "Firewall rule to block all countries except US"
  filter_id   = cloudflare_filter.countries.id
  action      = "block"
}

# Bots and threats
resource "cloudflare_filter" "bots_and_threats" {
  zone_id     = cloudflare_zone.main_zone.id
  description = "Expression to block bots and threats determined by CF"
  expression  = "(cf.client.bot) or (cf.threat_score gt 14)"
}

resource "cloudflare_firewall_rule" "bots_and_threats" {
  zone_id     = cloudflare_zone.main_zone.id
  description = "Firewall rule to block bots and threats determined by CF"
  filter_id   = cloudflare_filter.bots_and_threats.id
  action      = "block"
}