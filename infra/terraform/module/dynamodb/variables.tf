
variable "cluster_name" {
  description = "The name of the RES cluster"
  type        = string
  default     = "res-dev"
}

variable "read_capacity" {
  description = "Read capacity units for the table"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for the table"
  type        = number
  default     = 5
}
