# blink-cmp-env

A simple environment variable completion source for [blink.cmp](https://github.com/Saghen/blink.cmp)

# Setup

```lua
{
  "saghen/blink.cmp",
  dependencies = { "ethansaxenian/blink-cmp-env" },
  opts = {
    sources = {
      default = { "env" },
      providers = {
        env = {
          name = "env",
          module = "blink-cmp-env",
          --- @type blink-cmp-env.Opts
          opts = {
              include_snippets = true,
              insert_variable_prefix = true,
          },
        },
      },
    },
  },
}
```
