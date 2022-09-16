#!/usr/bin/env bash

set -e

## checkout tags
declare -a TAGS_TO_PUBLISH=('0.0.8' '0.0.9')

project_dir="$(pwd)/.."

site_dir="${project_dir}/dist/temp-site/"
rm -rf "${site_dir}"
mkdir -p "${site_dir}"
cd "${site_dir}"

for TAG_TO_PUBLISH in ${TAGS_TO_PUBLISH[@]}; do

  mkdir -p "${TAG_TO_PUBLISH}"
  cd "${TAG_TO_PUBLISH}"

  yaml_url="https://github.com/bonitasoft/bonita-openapi/releases/download/${TAG_TO_PUBLISH}/bonita-openapi-${TAG_TO_PUBLISH}.yaml"
  yaml_file="bonita-openapi-${TAG_TO_PUBLISH}.yaml"

  curl -L "${yaml_url}" -o "${yaml_file}"

  # FIXME: Images may differ from one version to another ...
  cp -r "$project_dir/docs/images" .

  npx redoc-cli build "${yaml_file}" -t "$project_dir/docs/index.html.hbs" --cdn -o index.html

  cd "${site_dir}"
done

# FIXME: Need to handle / /latest urls pointing to the site root folder
