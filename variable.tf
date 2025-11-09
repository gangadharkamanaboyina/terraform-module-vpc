variable project {
    default = "Roboshop"
}

variable env {
    default = "dev"
}

variable tags {
    type = map
    default = {}
}

variable vpc_cidr {
    type = list
}