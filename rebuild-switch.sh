#/usr/bin/env zsh
set -e # exit script on error

#navigate to dotfiles
pushd ~/dotfiles/

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
