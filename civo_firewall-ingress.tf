# Create a firewall
resource "civo_firewall" "firewall-ingress" {
  name                 = "${var.name_prefix}-firewall"
  create_default_rules = false

  ingress_rule {
    protocol    = "tcp"
    port_range   = "22"
    cidr        = ["0.0.0.0/0"]
    label       = "SSH access port"
    action      = "allow"
  }
}
