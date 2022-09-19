#!/bin/bash
set -e
set -o pipefail

export HOME="$(mktemp -d)"
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=$HOME/.ssh/knonw_hosts -o StrictHostKeyChecking=no"

test -d "$HOME/.ssh" || mkdir "$HOME/.ssh"

if [ ! -z "$GITHUB_APP_ID" ] ; then
    if [[ "$GIT_CLONE_URL" == *"@"* ]]; then
    arrIN=(${IN//@// })
    GIT_CLONE_URL=$(${arrIN[1]})
    fi
    echo $GITHUB_APP_CERTIFICATE > appcert.pem
    echo "require 'openssl'
require 'jwt'  # https://rubygems.org/gems/jwt

# Private key contents
private_pem = File.read(\"./appcert.pem/\")
private_key = OpenSSL::PKey::RSA.new(private_pem)

# Generate the JWT
payload = {
  # issued at time, 60 seconds in the past to allow for clock drift
  iat: Time.now.to_i - 60,
  # JWT expiration time (10 minute maximum)
  exp: Time.now.to_i + (10 * 60),
  # GitHub App's identifier
  iss: "238135"
}

jwt = JWT.encode(payload, private_key, "RS256")
puts jwt
" > jwt.rb
    TOKEN=$(ruby jwt.rb)
    GITHUB_INSTALLATION_ID=$(curl -s "Accept: application/vnd.github+json" -H "Authorization: Bearer $TOKEN" https://api.github.com/app/installations | jq -r '.[].id')
    GITHUB_REPO_NAME=$(echo $GIT_GIT_CLONE_URL | rev | cut -d/ -f1 | rev)
    APP_TOKEN=$(curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $TOKEN" \
    https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens -d \
    '{"repository":"GITHUB_REPO_NAME","permissions":{"contents":"read"}}' | jq -r '.token')
    GIT_CLONE_URL=https://x-access-token:APP_TOKEN@$GIT_CLONE_URL
    echo "GITHUB URL IS $GIT_CLONE_URL"
fi
if [ ! -z "$SSH_RSA_PRIVATE_KEY" ] ; then
        echo "$SSH_RSA_PRIVATE_KEY" > "$HOME/.ssh/id_rsa"
        chmod 0400 "$HOME/.ssh/id_rsa"
        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND -o IdentityFile=$HOME/.ssh/id_rsa"
fi

if [ -z "$GIT_CLONE_URL" ] ; then
    echo "No \$GIT_CLONE_URL specified" >&2
    exit 1
fi

find "$SRC_DIR" -maxdepth 1 -mindepth 1 -print0 | xargs -0 /bin/rm -rf

set -x
git clone "$GIT_CLONE_URL" "$SRC_DIR"
cd "$SRC_DIR"
git checkout -B "$GIT_CLONE_REF" "origin/$GIT_CLONE_REF"
