#!/usr/bin/env bash

set -e

git submodule status
echo -e "\n"
read -p "which submodule do you wish to delete? " delete_submodule
echo -e "\n"

# Remove the submodule entry from .git/config
git submodule deinit -f ${delete_submodule}

# Remove the submodule directory from the superproject's .git/modules directory
rm -rf .git/modules/${delete_submodule}

# Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
git rm -f ${delete_submodule}

echo "submodule ${delete_submodule} has been removed succesfully"

set +e
