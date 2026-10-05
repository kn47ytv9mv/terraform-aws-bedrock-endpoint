mock_provider "aws" {
  mock_resource "aws_bedrockagentcore_agent_runtime_endpoint" {
    defaults = {
      agent_runtime_endpoint_arn = "arn:aws:bedrock-agentcore:us-east-1:123456789012:runtime/example/runtime-endpoint/live"
      agent_runtime_arn          = "arn:aws:bedrock-agentcore:us-east-1:123456789012:runtime/example"
    }
  }
}

run "an_unpinned_endpoint_omits_the_version" {
  command = plan

  variables {
    name             = "live"
    agent_runtime_id = "support_assistant-abc123"
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.name == "live"
    error_message = "The endpoint should carry the name given."
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_id == "support_assistant-abc123"
    error_message = "The endpoint should front the runtime ID given."
  }
}

run "a_pinned_endpoint_carries_its_version" {
  command = plan

  variables {
    name                  = "live"
    agent_runtime_id      = "support_assistant-abc123"
    agent_runtime_version = "3"
    description           = "Production traffic."
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_version == "3"
    error_message = "A pinned endpoint should pass its runtime version through."
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.description == "Production traffic."
    error_message = "The endpoint should carry the description given."
  }
}

run "tags_are_applied" {
  command = plan

  variables {
    name             = "live"
    agent_runtime_id = "support_assistant-abc123"

    tags = {
      Service = "support-assistant"
    }
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.tags["Service"] == "support-assistant"
    error_message = "Tags should reach the endpoint."
  }
}

run "readme_minimal_endpoint_both_sources" {
  command = plan

  variables {
    name             = "live"
    agent_runtime_id = "support_assistant-abc123"
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.name == "live"
    error_message = "The README's minimal example should plan. The registry-source and GitHub-source forms set the same variables, so one run covers both."
  }
}

run "readme_pinned_endpoint_pair" {
  command = plan

  variables {
    name                  = "live"
    agent_runtime_id      = "support_assistant-abc123"
    agent_runtime_version = "3"

    tags = {
      Service = "support-assistant"
    }
  }

  assert {
    condition     = aws_bedrockagentcore_agent_runtime_endpoint.resource.agent_runtime_version == "3"
    error_message = "The README's pinned example should plan."
  }
}
