# Create volume
# resource "civo_volume" "persisted-volume" {
#     name = "${var.name_prefix}-persisted-volume"
#     size_gb = var.drive_size
#     network_id = civo_instance.workspace-instance.network_id
# }

# Get volume by id
# terraform import civo_volume.persisted-volume 49304df4-bd23-40ff-a840-2bda89fc0f29


# Create volume attachment
resource "civo_volume_attachment" "persisted-volume-attachment" {
    instance_id = civo_instance.workspace-instance.id
    # volume_id  = civo_volume.persisted-volume.id
    volume_id  = "${var.persistent_volume_id}"
}