variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "env" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_blocks" {
  type = object({
  })
}

variable "backend_conn_str" {
  type = string
}
