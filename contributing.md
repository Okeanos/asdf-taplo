# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test taplo https://github.com/Okeanos/asdf-taplo.git "taplo --version"
```

Tests are automatically run in GitHub Actions on push and PR.
