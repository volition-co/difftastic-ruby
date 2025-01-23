# Difftastic Ruby

A Ruby interface and wrapper for the wonderful [Difftastic](https://difftastic.wilfred.me.uk) CLI tool.

First create a differ with your config.

```ruby
MY_DIFFER = Difftastic::Differ.new(
  background: :dark,
  color: :always,
  left_label: "Expected",
  right_label: "Actual"
)
```

Diff Objects

```ruby
MY_DIFFER.diff_objects(a, b)
```

Diff Ruby

```ruby
MY_DIFFER.diff_ruby(a, b)
```
