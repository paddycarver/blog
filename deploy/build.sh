#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace
set -o pipefail


hugo --cleanDestinationDir --config config.toml -d public/paddy.carvers.co --debug --verbose
hugo --cleanDestinationDir --config drafts.config.toml -d public/drafts.paddy.carvers.co --debug --verbose
