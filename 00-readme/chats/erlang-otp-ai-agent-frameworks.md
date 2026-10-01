[AI agents on Erlang/OTP runtime](https://claude.ai/chat/05293b23-92ab-4f4c-b7ec-d1d6f8acd496)
# Prompt
* I regard erlang/otp runtime as the most simple way to be able to setup something that both is easy to setup both in local pc and in production and at the same time easy to setup to be reliable.
* I wonder if anyone build some kind of framework that can run in that runtime for running AI agents?
* can you give me a startup guide of each of the projects?

# Erlang/OTP AI Agent Frameworks

## Overview

Context: Erlang/OTP is appealing as a runtime for AI agents because OTP's
supervision trees give near-free fault tolerance (crash the agent, respawn it),
lightweight processes make parallel agents cheap, and distribution makes
multi-node scaling straightforward.

There's no dominant "LangGraph of the BEAM" yet — most people building agents
on Erlang/OTP today hand-roll GenServers/supervisors around LLM API calls
rather than using a mature framework, since the BEAM primitives already give
you most of what a framework would provide.

## Projects

### Jido — agent framework

- Started 2024 as a bot platform called "BotHive," pivoted into an agent
  framework when the AI wave hit. Jido 1.0 shipped March 2025 (admittedly
  overengineered), Jido 2.0 shipped March 2026 with simpler APIs and
  BEAM-first design.
- GitHub: `agentjido/jido` (core), `agentjido/jido_ai` (LLM layer)
- Core concepts: agents are plain structs (state + actions + tools) run
  inside a `GenServer`. Everything flows through `cmd/2` — actions go in,
  an updated agent + directives come out.
- Supports 57+ LLM providers via `ReqLLM`, plus Chain-of-Thought / ReAct /
  Tree-of-Thoughts reasoning strategies.

**Startup guide:**

```elixir
# mix.exs
def deps do
  [{:jido_ai, "~> 0.5.3"}]
end
```

```elixir
defmodule MyApp.Actions.AddNumbers do
  use Jido.Action,
    name: "add_numbers",
    schema: Zoi.object(%{a: Zoi.integer(), b: Zoi.integer()}),
    description: "Add two numbers."

  @impl true
  def run(%{a: a, b: b}, _context), do: {:ok, %{sum: a + b}}
end

defmodule MyApp.MathAgent do
  use Jido.AI.Agent,
    name: "math_agent",
    model: :fast,
    tools: [MyApp.Actions.AddNumbers],
    system_prompt: "Solve accurately. Use tools for arithmetic."
end

{:ok, pid} = Jido.AgentServer.start(agent: MyApp.MathAgent)
```

---

### Elixir LangChain (`brainlid/langchain`)

- Elixir port in spirit, not in API design — Elixir is functional, not OO,
  so it doesn't try for parity with the JS/Python LangChain.
- Supports OpenAI, Anthropic, Google AI/Vertex, Mistral, Ollama, and
  self-hosted Bumblebee models.
- Function/tool calling works by wrapping an Elixir function in a
  `LangChain.Function` struct, which the LLM can then call.
- More an "LLM integration toolkit" than an agent runtime.

**Startup guide:**

```elixir
def deps do
  [{:langchain, "~> 0.8.0"}]
end
```

```elixir
alias LangChain.Chains.LLMChain
alias LangChain.ChatModels.ChatAnthropic
alias LangChain.Message

{:ok, updated_chain} =
  %{llm: ChatAnthropic.new!(%{model: "claude-sonnet-4-6"})}
  |> LLMChain.new!()
  |> LLMChain.add_message(Message.new_user!("Hello!"))
  |> LLMChain.run()
```

---

### Instructor Ex (`thmsmlr/instructor_ex`)

- Not an agent framework — a structured-output layer. Spiritual port of the
  Python `instructor` library.
- You define an Ecto schema; Instructor coaxes the LLM into valid JSON
  matching it, with automatic retries on validation failure.
- Works with OpenAI, Anthropic, Groq, Ollama, Gemini, vLLM, llama.cpp.
- Useful as a building block *inside* a hand-rolled GenServer agent loop,
  for getting reliable structured tool-call outputs.

**Startup guide:**

```elixir
Mix.install([:instructor])
```

```elixir
defmodule SpamPrediction do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  ## Field Descriptions:
  - class: Whether or not the email is spam
  - reason: short rationalization
  - score: confidence 0.0–1.0
  """
  @primary_key false
  embedded_schema do
    field(:class, Ecto.Enum, values: [:spam, :not_spam])
    field(:reason, :string)
    field(:score, :float)
  end

  @impl true
  def validate_changeset(changeset) do
    Ecto.Changeset.validate_number(changeset, :score,
      greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
  end
end

Instructor.chat_completion(
  model: "gpt-4o-mini",
  response_model: SpamPrediction,
  messages: [%{role: "user", content: "Classify: Nigerian prince email scam"}],
  max_retries: 3
)
```

## Bottom line

None of these give you a "just add supervision and go" experience out of
the box. Jido is closest to a true agent runtime; LangChain and Instructor
are lower-level pieces you'd combine with your own GenServers/Supervisors
to get the OTP reliability benefits you're after.
