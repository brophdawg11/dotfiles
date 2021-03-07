#!/bin/bash

BACKUP_DIR="${HOME}/.dotfiles-backups"

for F in $(find . -type f -maxdepth 1 -not -iname "bootstrap.sh"); do
    F=$(basename "${F}")
    LINK_FILE="${HOME}/${F}"

    if [[ -L "${HOME}/${F}" ]]; then
        echo "${F} - already linked"
    elif [[ ! -f "${HOME}/${F}" ]]; then
        echo "${F} - creating symlink"
        ln -s "$(pwd)/${F}" "${LINK_FILE}"
    else
        echo "${F} - exits as a file - backing up and replacing"
        BACKUP_FILE="${BACKUP_DIR}/${F}-$(date +"%Y-%m-%dT%H-%M-%S")"
        echo "${F} not linked, backing up to ${BACKUP_FILE}"

        if [[ ! -d "${BACKUP_DIR}" ]]; then
            mkdir "${BACKUP_DIR}"
        fi

        mv "${LINK_FILE}" "${BACKUP_FILE}"
        ln -s "$(pwd)/${F}" "${LINK_FILE}"
    fi
done
