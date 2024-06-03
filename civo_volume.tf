# Create volume
resource "civo_volume" "persisted-volume" {
    name = "${var.name_prefix}-persisted-volume"
    size_gb = var.drive_size
    network_id = civo_instance.workspace-instance.network_id
}

# Create volume attachment
resource "civo_volume_attachment" "foobar" {
    # instance_id = civo_instance.foo.id
    instance_id = civo_instance.workspace-instance.id
    # volume_id  = civo_volume.db.id
    volume_id  = civo_volume.persisted-volume.id
}