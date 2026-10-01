## Install elixir (including mix) and erlang

```bash
# install and write the tools in mise config
# you can omit -g(lobal) if wanted for having a version file locally
mise use -g erlang elixir
# ✓ installed 2 tools in 72.2s: erlang@29.1.1, elixir@1.20.4-otp-29
# mise C:\Users\xxx\.config\mise\config.toml tools: erlang@29.1.1, elixir@1.20.4-otp-29

# read versions
mise exec -- elixir --version
# Erlang/OTP 29 [erts-17.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]
# Elixir 1.20.4 (compiled with Erlang/OTP 29)
```
Open new terminal to be able to reach new tools or   
do `mise activate pwsh` // shell must be activated or its PATH updated before the executable is callable without a prefix command

```bash
elixir --version   
# as above

# mix was installed together with elixir
mix --version
# Erlang/OTP 29 [erts-17.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]
# Mix 1.20.4 (compiled with Erlang/OTP 29)     

# from a cmd terminal this will work, but not from pwsh
iex -v
# Erlang/OTP 29 [erts-17.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]
# IEx 1.20.4 (compiled with Erlang/OTP 29)

# The erlang shell
erl -v 
# Erlang/OTP 29 [erts-17.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]
# Eshell V17.1 (press Ctrl+G to abort, type help(). for help)
```

## Install [igniter](https://hex.pm/packages/igniter)

Use igniter to easily add dependencies into elixir - like nuget
```bash
# install igniter
mix archive.install hex igniter_new
# * creating c:/Users/Soren/.mix/archives/hex-2.5.1
# Resolving Hex dependencies...
# Resolution completed in 0.03s
# New:
#   igniter_new 0.5.35
# * Getting igniter_new (Hex package)
# All dependencies have been fetched
# Compiling 7 files (.ex)
# Generated igniter_new app
# Generated archive "igniter_new-0.5.35.ez" with MIX_ENV=prod
# Do you trust and want to install "igniter_new-0.5.35.ez"? [Yn] Y
# * creating c:/Users/Soren/.mix/archives/igniter_new-0.5.35

# example usage:
mix igniter.new app_name --install ash,ecto
```
