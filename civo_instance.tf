# Create a new instance
resource "civo_instance" "foo" {
    count = var.create_instance ? 1 : 0
    hostname = "${var.name_prefix}-instance"
    notes = "An Example Machine Learning Development Environment"
    size = var.node_size
    disk_image = "ubuntu-cuda12-2" # or ubuntu-cuda11-8
    script = file("script.sh")
}