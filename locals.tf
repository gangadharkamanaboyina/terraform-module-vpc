locals {
    common_name = "${var.project}-${var.env}"
    availability_zones = slice(data.aws_availability_zones.available.names, 0,2)
}