<div align="center">

# asdf-taplo [![Build](https://github.com/Okeanos/asdf-taplo/actions/workflows/build.yml/badge.svg)](https://github.com/Okeanos/asdf-taplo/actions/workflows/build.yml) [![Lint](https://github.com/Okeanos/asdf-taplo/actions/workflows/lint.yml/badge.svg)](https://github.com/Okeanos/asdf-taplo/actions/workflows/lint.yml)

[taplo](https://taplo.tamasfe.dev) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `gunzip`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add taplo
# or
asdf plugin add taplo https://github.com/Okeanos/asdf-taplo.git
```

taplo:

```shell
# Show all installable versions
asdf list-all taplo

# Install specific version
asdf install taplo latest

# Set a version globally (on your ~/.tool-versions file)
asdf global taplo latest

# Now taplo commands are available
taplo --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Okeanos/asdf-taplo/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Nikolas Grottendieck](https://github.com/Okeanos/)
