variable "name" {
  description = "IAM Role Name"
  type        = string
  default     = null
}

variable "tags" {
  description = "IAM Role Tags"
  type        = map(any)
  default     = {}
}

variable "policy_arn" {
  description = "IAM ARN Policy to Attach Role"
  type        = string
  default     = null
}

variable "actions" {
  description = "IAM Policy Document Actions"
  type        = string
  default     = null
}

variable "type" {
  description = "IAM Principal Type"
  type        = string
  default     = null
}

variable "identifiers" {
  description = "IAM Principals Identifiers"
  type        = string
  default     = null
}