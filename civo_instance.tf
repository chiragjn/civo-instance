# Create a new instance
resource "civo_instance" "workspace-instance" {
    notes = "Machine Learning Development Environment"
    hostname = "${var.name_prefix}-instance"
    size = var.node_size
    initial_user = "civo"
    public_ip_required = "none"
    reserved_ipv4 = "${var.reserved_ipv4_id}"
    sshkey_id = "${var.sshkey_id}"
    disk_image = "ubuntu-jammy"
    script = file("script.sh")
}
