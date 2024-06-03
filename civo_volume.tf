# Create volume
resource "civo_volume" "db" {
    count = var.create_volume ? 1 : 0
    name = "${var.name_prefix}-persisted-volume"
    size_gb = var.drive_size
    # network_id = civo_instance.foo.network_id
    network_id = civo_instance.foo[count.index].network_id
}

# Create volume attachment
resource "civo_volume_attachment" "foobar" {
    # instance_id = civo_instance.foo.id
    instance_id = civo_instance.foo[count.index].id
    # volume_id  = civo_volume.db.id
    volume_id  = civo_volume.db[count.index].id
}