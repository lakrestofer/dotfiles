#/usr/bin/env zsh
# A rebuild script that commits on a successful build
# adapted from <https://gist.githubusercontent.com/0atman/1a5133b842f929ba4c1e195ee67599d5/raw/4e2f3ad34edb07843db9d6abb7c340bba611c07e/nixos-rebuild.sh>

# Would be nice if this script also had some search and edit feature
# making the script the first point of contact whenever I want
# to alter my configuration
# feature list
# [ ] open rofi/fzf and search for files that we can change
# [ ] on change of file, run test to check for valid file
# [ ] on valid config file, rebuild and switch

set -e

#navigate to dotfiles
pushd ~/dotfiles/

# edit them
$EDITOR

# if no change, return
if git diff --quiet ; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# display what changed
git diff -U0

if [ -z "$(git status -s -uno | grep -v '^ ' | awk '{print $2}')" ]; then
    gum confirm "Stage all?" && git add .
fi

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder "scope")

test -n "$SCOPE" && SCOPE="($SCOPE)" # scope is optional

SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
DESCRIPTION=$(gum write --placeholder "Details of this change")

gum confirm "Commit changes and build?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"

nh os switch || git reset HEAD~1 # build, reset git history if build failed

# Back to where you were
popd
