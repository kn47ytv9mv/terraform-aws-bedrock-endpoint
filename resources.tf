resource "aws_bedrockagentcore_agent_runtime_endpoint" "resource" {
  name             = var.name
  agent_runtime_id = var.agent_runtime_id

  agent_runtime_version = var.agent_runtime_version
  description           = var.description

  tags = var.tags
}

output "arn" {
  description = "The ARN of the endpoint. This is the address a caller invokes."
  value       = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_endpoint_arn
}

output "name" {
  description = "The name of the endpoint."
  value       = aws_bedrockagentcore_agent_runtime_endpoint.resource.name
}

output "agent_runtime_arn" {
  description = "The ARN of the agent runtime behind this endpoint."
  value       = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_arn
}

output "agent_runtime_version" {
  description = "The runtime version this endpoint serves, whether pinned or resolved by AWS."
  value       = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_version
}
