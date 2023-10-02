# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test kubeshark https://github.com/rm3l/asdf-kubeshark.git "kubeshark version"
```

Tests are automatically run in GitHub Actions on push and PR.
