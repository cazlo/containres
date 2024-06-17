
variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "example-table"
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
