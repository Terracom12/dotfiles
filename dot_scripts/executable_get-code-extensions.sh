#!/bin/bash

# If VS Code is installed, gets a list of the
# current extensions and adds it to $conf_file

set -eu  # Strict mode

# If code is not installed / the CLI is unavailable -> exit
type code &> /dev/null || exit 1

conf_file=~/.local/share/chezmoi/.chezmoidata/code-extensions.yml
extensions_list=$(code --list-extensions --show-versions)

cat << EOF > ${conf_file}
---
code_extensions:
$(echo "${extensions_list}" | sed 's/^/  - /')
...
EOF
