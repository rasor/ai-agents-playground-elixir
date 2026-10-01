## Install [mise](https://mise.jdx.dev/getting-started.html)

`mise` enables to switch between multiple versions of erlang runtimes and other runtimes like nodejs.  
`Erlang` is the runtime for `Elixir`.  

```bash
winget install jdx.mise

# Downloading https://github.com/jdx/mise/releases/download/v2026.9.5/mise-v2026.9.5-windows-x64.zip
# Command line alias added: "mise-shim"
# Command line alias added: "mise"
# Path environment variable modified; restart your shell to use the new value.
# Successfully installed

mise --version
# 2026.9.5 windows-x64 (2026-09-10)
# mise WARN  mise version 2026.9.13 available
# mise WARN  To update, run mise self-update
# mise hint keep mise updated automatically with mise settings auto_update=true
```
Mise has a [VSCode](https://mise.jdx.dev/ide-integration.html#ide-plugins) extention called [mise-vscode](https://marketplace.visualstudio.com/items?itemName=hverlin.mise-vscode).  

For syntax highlighting of mises config files you can use [tombi-toml](https://marketplace.visualstudio.com/items?itemName=tombi-toml.tombi) extention.  

## Refs
* [Setup a project using mise](https://mise.jdx.dev/getting-started.html#set-up-a-project)
* [mise CI/CD](https://mise.jdx.dev/continuous-integration.html)
* [List of CLIs for mise](https://mise.jdx.dev/registry.html)
* [mise folder](https://mise.jdx.dev/directories.html)
* [mise demo](https://mise.jdx.dev/demo.html)

