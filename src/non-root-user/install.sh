#!/bin/sh
set -e

USERNAME="developer"

USER_UID=1000
USER_GID=1000

echo "Configure non-root user..."

if getent group "$USER_GID" >/dev/null; then
    EXISTING_GRP=$(getent group "$USER_GID" | cut -d: -f1)
    echo "Group with GID $USER_GID exists already ($EXISTING_GRP). Using it."
else
    groupadd --gid "$USER_GID" "$USERNAME"
fi

if getent passwd "$USER_UID" >/dev/null; then
    EXISTING_USER=$(getent passwd "$USER_UID" | cut -d: -f1)
    USERNAME="$EXISTING_USER"
    echo "User with UID $USER_UID exists already ($EXISTING_USER)."
else
    useradd --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME"
fi


### make sure sudo is installed and configure it

# if ! [ -x "$(command -v sudo)" ]; then
#     apt-get update && apt-get install -y sudo
# fi

# echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
# chmod 0440 /etc/sudoers.d/$USERNAME

echo "User-Einrichtung für '$USERNAME' abgeschlossen."
