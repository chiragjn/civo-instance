# Create a firewall
resource "civo_firewall" "firewall" {
  name                 = "${var.name_prefix}-firewall"
  create_default_rules = false

  ingress_rule {
    protocol    = "tcp"
    port_range   = "22"
    cidr        = ["0.0.0.0/0"]
    label       = "SSH access port"
    action      = "allow"
  }

  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}
