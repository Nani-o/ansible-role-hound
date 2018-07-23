#!/bin/bash

GITHUB_USER="${1}"
GITHUB_TEMPFILE=$(mktemp api_github_user_repos.XXXXXXXX)
CONFIG_TO_MERGE="${2}"
CONFIG_GITHUB_USER=$(mktemp github_repos_hound_config.XXXXXXXX)
CONFIG_FILE="${3}"

shift 3

for item in "$@"; do
    GREP_PATTERN="${GREP_PATTERN}${item};|"
done
GREP_PATTERN="${GREP_PATTERN%?}"
GREP_PATTERN="${GREP_PATTERN:-fuckingplaceholderthatshouldnotbeareponame}"

curl -s https://api.github.com/users/${GITHUB_USER}/repos > "${GITHUB_TEMPFILE}"
grep -q 'API rate limit' "${GITHUB_TEMPFILE}"
[[ "$?" == "0" ]] && echo "Github rate limit exceeded, wait and retry" && exit 1
REPOS_CSV=$(jq -s '.[][] | .name + ";" + .clone_url' "${GITHUB_TEMPFILE}" | sed 's/^"//g' | sed 's/"$//g' | grep -Ev "${GREP_PATTERN}")
REPOS_LENGTH=$(echo "${REPOS_CSV}" | wc -l)

echo $REPOS_LENGTH

echo '{
    "repos" : {' >> "${CONFIG_GITHUB_USER}"

IDX=1
while read -r LINE
do
    NAME=$(echo ${LINE} | cut -d ';' -f1)
    URL=$(echo ${LINE} | cut -d ';' -f2)
    echo "        \"${NAME}\" : {" >> "${CONFIG_GITHUB_USER}"
    echo "            \"url\": \"${URL}\"" >> "${CONFIG_GITHUB_USER}"
    if [[ "${IDX}" -eq "${REPOS_LENGTH}" ]]; then
        echo "        }" >> "${CONFIG_GITHUB_USER}"
    else
        echo "        }," >> "${CONFIG_GITHUB_USER}"
    fi
    IDX=$((${IDX}+1))
done <<< "$(echo "${REPOS_CSV}")"
echo "    }
}" >> "${CONFIG_GITHUB_USER}"

MERGED_CONFIG=$(mktemp merged_config.XXXXXXXX)

jq -s '.[0] * .[1]' "${CONFIG_TO_MERGE}" "${CONFIG_GITHUB_USER}" > "${MERGED_CONFIG}"

NEW_HASH=$(md5sum "${MERGED_CONFIG}" | awk '{print $1}')
OLD_HASH=$(md5sum "${CONFIG_FILE}" | awk '{print $1}')
echo ${NEW_HASH}
echo $OLD_HASH
if [[ "${NEW_HASH}" != "${OLD_HASH}" ]]; then
    echo "New repositories config changed restarting service"
    mv "${MERGED_CONFIG}" "${CONFIG_FILE}"
    sudo systemctl restart hound
else
    echo "No modifications to the config"
fi
