#!/bin/sh

# This script is used to write a conventional commit message.
# It prompts the user to choose the type of commit as specified in the
# conventional commit spec. And then prompts for the summary and detailed
# description of the message and uses the values provided. as the summary and
# details of the message.
#
# If you want to add a simpler version of this script to your dotfiles, use:
#
# alias gcm='git commit -m "$(gum input)" -m "$(gum write)"'

# Fonction pour quitter proprement
clean_exit() {
    gum style --foreground 220 --border-foreground 220 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        '👋 Exiting...'
    exit 1
}

# Gestion de CTRL+C
trap 'echo ""; clean_exit' INT

# if [ -z "$(git status -s -uno | grep -v '^ ' | awk '{print $2}')" ]; then
#     gum confirm "Stage all?" && git add .
# fi

# Get the status of the repository

TYPE=""
SCOPE=""
BREAKING_CHANGE=""
MESSAGE=""


gum style \
	--align center --width 50 --margin "0 2" --padding "2 2" --bold --underline \
	'Create conventional commit! ⬇️'
git status -sb
echo ""
gum confirm "Stage all?" --default="No" && git add .; git status -sb
echo ""
gum style \
	--margin "0 2" --bold --underline \
	'🤔 What is the TYPE of this change?'
TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert") || clean_exit
MESSAGE=$TYPE
echo "$MESSAGE:"
gum style \
	--margin "0 2" --bold --underline \
	"📦 What is the SCOPE of this change?"

SCOPE=$(gum input --placeholder "scope") || clean_exit
test -n "$SCOPE" && SCOPE="($SCOPE)"
MESSAGE=$TYPE$SCOPE 
echo "$MESSAGE:"
BREAKING_CHANGE=$(gum confirm "⚠️  Is this a BREAKING CHANGE?" --selected.background="220" --prompt.foreground="220" --default="No" && echo "!" || echo "") || clean_exit
MESSAGE=$TYPE$SCOPE$BREAKING_CHANGE 
echo "$MESSAGE:"
gum style \
	--margin "0 2" --bold --underline \
	"📝 What's the TITLE of this change?"
SUMMARY=$(gum input --value "$MESSAGE: " --placeholder "Title of this change") || clean_exit
echo "$SUMMARY:"
gum style \
	--margin "0 2" --bold --underline \
	"📝 What's the DESCRIPTION of this change?"
DESCRIPTION=$(gum write --placeholder "Details of this change") || clean_exit
echo "$DESCRIPTION:"
# Commit these changes if user confirms
if gum confirm "Commit changes?"; then
    git commit -m "$SUMMARY" -m "$DESCRIPTION"
else
    gum style \
        --foreground 160 --border-foreground 160 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        '❌ Changes not committed!'
    exit 1
fi

echo ""
git log --all --color=always -n 1 --abbrev-commit --date=relative | cat
echo ""
gum style \
	--foreground 82 --border-foreground 22 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'✅ Changes committed!'
echo ""

gum confirm "Push changes?" --default="No" && git push; 
gum style \
	--foreground 82 --border-foreground 22 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'🚀 Changes pushed!' || clean_exit