# terraform-aws-bedrock-endpoint

Terraform module for a Bedrock AgentCore agent runtime endpoint — the
address callers invoke to reach an agent, and the control over which version
of that agent they get.

## Cost

An endpoint has no charge of its own. What it fronts does: the agent runtime
is billed for the compute each session consumes, and every model call the
agent makes is billed against Bedrock. An endpoint pointing at a runtime
nobody invokes costs nothing.

See AWS's [Bedrock pricing](https://aws.amazon.com/bedrock/pricing/) page for
current rates.

## Design

This module owns the endpoint alone. The runtime behind it comes from
[`terraform-aws-bedrock-agent-runtime`](https://github.com/kn47ytv9mv/terraform-aws-bedrock-agent-runtime), which this module identifies by ID
rather than ARN — pass that module's `agent_runtime_id` output.

A runtime with no endpoint is deployed but unaddressable, so the two are
normally created together. More than one endpoint may front the same
runtime, which is the mechanism for running a pinned production address
alongside a floating one.

### Pinning a version is the point

Leaving `agent_runtime_version` null points the endpoint at whatever version
the runtime is currently on, and moves it every time the runtime changes.
That is convenient while developing and wrong in production, where a change
to the agent reaches live traffic the moment it applies.

Setting `agent_runtime_version` fixes the endpoint to one revision. Edits to
the runtime then produce new versions that this endpoint ignores until the
pin moves, which makes promotion an explicit step rather than a side effect
of an unrelated apply.

The common arrangement is two endpoints on one runtime: one pinned for
production, one unpinned for testing the current revision.

### Names reject hyphens

AWS accepts only letters, digits and underscore in an endpoint name, it must
begin with a letter, and it caps at 48 characters. That rules out the
family's random-UUID fallback, which contains hyphens, so this module
generates no name — `name` is simply required. The provider reports the rule
in full when a name breaks it, so this module adds no validation of its own.

## Usage

```hcl
module "endpoint" {
  source = "kn47ytv9mv/bedrock-endpoint/aws"

  name             = "live"
  agent_runtime_id = module.runtime.agent_runtime_id
}
```

Or directly from this repository:

```hcl
module "endpoint" {
  source = "github.com/kn47ytv9mv/terraform-aws-bedrock-endpoint"

  name             = "live"
  agent_runtime_id = module.runtime.agent_runtime_id
}
```

Pinned to one revision of the runtime:

```hcl
module "runtime" {
  source = "kn47ytv9mv/bedrock-agent-runtime/aws"

  agent_runtime_name = "support_assistant"
  role_arn           = module.runtime_role.arn

  agent_runtime_artifact = {
    container_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/support-assistant:latest"
  }

  network_configuration = {
    network_mode = "PUBLIC"
  }
}

module "endpoint" {
  source = "kn47ytv9mv/bedrock-endpoint/aws"

  name                  = "live"
  agent_runtime_id      = module.runtime.agent_runtime_id
  agent_runtime_version = module.runtime.agent_runtime_version

  tags = {
    Service = "support-assistant"
  }
}
```

Pinning to `module.runtime.agent_runtime_version` fixes the endpoint to the
revision this configuration just produced. To hold an endpoint on an older
revision while the runtime moves ahead, set the version literally instead.

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.0 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| name | Name of the endpoint. Letters, digits and underscore only, beginning with a letter, up to 48 characters. | `null` | no |
| agent_runtime_id | ID of the agent runtime this endpoint fronts, from [`terraform-aws-bedrock-agent-runtime`](https://github.com/kn47ytv9mv/terraform-aws-bedrock-agent-runtime). | `null` | no |
| agent_runtime_version | Version of the runtime this endpoint serves. Null follows the runtime's current version. | `null` | no |
| description | Description of the endpoint. | `null` | no |
| tags | A map of tags to assign to the endpoint. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| arn | The ARN of the endpoint, which is the address a caller invokes. |
| name | The name of the endpoint. |
| agent_runtime_arn | The ARN of the agent runtime behind this endpoint. |
| agent_runtime_version | The runtime version this endpoint serves, whether pinned or resolved by AWS. |

## License

MIT — see [LICENSE.md](LICENSE.md).
