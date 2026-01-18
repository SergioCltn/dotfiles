# Set identification from install inputs
# TODO: don't know what to do with this maybe remove it
if [[ -n "${OMARCHY_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMARCHY_USER_NAME"
fi

if [[ -n "${OMARCHY_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMARCHY_USER_EMAIL"
fi
