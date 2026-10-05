variable "name" {
  default     = null
  description = "Name of the endpoint, which AWS requires. Valid characters are a-z, A-Z, 0-9 and underscore, it must begin with a letter, and it can be up to 48 characters. A hyphen is rejected, which is why this module offers no generated fallback — the family's random-UUID fallback contains hyphens."
}

variable "agent_runtime_id" {
  default     = null
  description = "ID of the agent runtime this endpoint fronts, from terraform-aws-bedrock-agent-runtime's agent_runtime_id output. An endpoint identifies its runtime by ID, not by ARN."
}

variable "agent_runtime_version" {
  default     = null
  description = "Version of the runtime this endpoint serves. If null, AWS points the endpoint at the runtime's current version and moves it as the runtime changes. Pin a version to decouple the endpoint's behaviour from edits to the runtime — see the Design section."
}

variable "description" {
  default     = null
  description = "Description of the endpoint."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the endpoint."
}
