#!/bin/bash

# This cannot be executed from within a Ruby-based environment (like Rake)
# since Bundler will affect the subshell environments.

set -e

function header() {
  echo -e "\n$(tput setaf 5)$(tput smul)$1:$(tput sgr0)"
}

function green() {
  echo "$(tput setaf 2)$*$(tput sgr0)"
}

function update() {
  bundle config --local path .bundle
  bundle update | grep -ve "^Using "
}

function install() {
  bundle install --quiet --path=.bundle && green "  OK"
}


root=$(dirname "$0")

# Previously needed by Travis CI; might still be needed at Github Actions
# due to nested repos
unset BUNDLE_GEMFILE

if [[ $1 == "install" ]]; then
  header "Installing gem dependencies"
  install

  for app_path in "$root"/spec/railsapps/rails_*; do
    (
      header "Rails app $(basename "$app_path")"
      cd "$app_path"
      echo -n "Installing gems for $(basename "$app_path")"
      install
    )
  done
  echo ""

elif [[ $1 == "update" ]]; then
  header "Updating gem dependencies"
  update

  for app_path in "$root"/spec/railsapps/rails_*; do
    (
      cd "$app_path"
      header "Updating $(basename "$app_path")"
      update
    )
  done
  echo ""

else
  echo "Usage: $0 [install|update]"
  echo ""
  echo "  Install: Install all bundled updates."
  echo "  Update: Run bundle update on all bundles."
  echo ""
  exit 127
fi
