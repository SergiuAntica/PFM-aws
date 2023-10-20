variable "name" {
  description = "Docker Image Name"
  type        = string
  default     = null
}

variable "context" {
  description = "Docker Context Path Build"
  type        = string
  default     = null
}

variable "tag" {
  description = "Docker Tag Build"
  type        = string
  default     = null
}

variable "platform" {
  description = "Docker Platform Build"
  type        = string
  default     = null
}