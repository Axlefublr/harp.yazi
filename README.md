Implementation of "cwd harps" using [harp](https://github.com/Axlefublr/harp), like the cwd harps from [my helix fork](https://github.com/Axlefublr/helix).

`.` relativity is supported.

Requires you to have the `harp` binary installed and in `$PATH`.

# Installation

```
ya pack -a Axlefublr/harp
```

(supposedly; I haven't tried)

# Usage

In your mappings:

```toml
{ on = 'z', run = 'plugin harp --args=get', desc = 'Travel to a cwd harp' },
{ on = 'Z', run = 'plugin harp --args=set', desc = 'Set a cwd harp' },
```

`z` and `Z` are what I use; feel free to pick mappings that make more sense for you.
