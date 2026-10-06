#!/bin/zsh
# Copy a rendered post folder onto the public image shelf and push it.
# Usage: ./shelf.sh <source-dir> <name>   e.g. ./shelf.sh ../content/month-1/week1-v3/out w1
# PNG -> JPEG (Instagram's API only takes JPEG), JPG and MP4 copied as is.
# Public URL: https://drewneros.github.io/travisaro-media/<name>/<file>
set -e
src=${1:?source dir}; name=${2:?shelf folder name}
src=${src:A}
cd "${0:A:h}"; mkdir -p "$name"
for f in "$src"/*.png(N); do sips -s format jpeg -s formatOptions 92 "$f" --out "$name/${f:t:r}.jpg" >/dev/null; done
for f in "$src"/*.(jpg|jpeg|mp4)(N); do cp "$f" "$name/"; done
git add "$name"
git diff --cached --quiet || git commit -qm "shelf: $name"
[[ -n "$NO_PUSH" ]] || git push -q
echo "Ready: https://drewneros.github.io/travisaro-media/$name/"
