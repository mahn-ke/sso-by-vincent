terraform {
  backend "pg" {
  }
  required_providers {
    allinkl = {
      source = "ViMaSter/allinkl"
      version = "0.1.2"
    }
  }
}

provider "allinkl" {
    kas_auth_type = "plain"
}

resource "random_password" "ddns_password" {
    length  = 30
    special = false
}

resource "allinkl_ddns" "sso" {
    dyndns_comment   = "SSO - KeyCloak"
    dyndns_password  = random_password.ddns_password.result
    dyndns_zone      = "mahn.ke"
    dyndns_label     = "sso.by.vincent"
    dyndns_target_ip = "88.99.215.101"
}
