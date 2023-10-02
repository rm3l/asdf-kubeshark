<div align="center">

# asdf-kubeshark [![Build](https://github.com/rm3l/asdf-kubeshark/actions/workflows/build.yml/badge.svg)](https://github.com/rm3l/asdf-kubeshark/actions/workflows/build.yml) [![Lint](https://github.com/rm3l/asdf-kubeshark/actions/workflows/lint.yml/badge.svg)](https://github.com/rm3l/asdf-kubeshark/actions/workflows/lint.yml)

[kubeshark](https://docs.kubeshark.co/en/introduction) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add kubeshark
# or
asdf plugin add kubeshark https://github.com/rm3l/asdf-kubeshark.git
```

kubeshark:

```shell
# Show all installable versions
asdf list-all kubeshark

# Install specific version
asdf install kubeshark latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubeshark latest

# Now kubeshark commands are available
kubeshark version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/rm3l/asdf-kubeshark/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Armel Soro](https://github.com/rm3l/)
