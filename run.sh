#!/bin/bash

params=()

[[ $PLUGIN_FIRST_RELEASE == true ]] && params+=(--first-release)
[[ -n "${PLUGIN_PRERELEASE}" ]] && params+=(--prerelease=$PLUGIN_PRERELEASE)
[[ -n "${PLUGIN_RELEASE_AS}" ]] && params+=(--release-as=$PLUGIN_RELEASE_AS)
[[ $PLUGIN_NO_VERIFY == true ]] && params+=(--no-verify)


[[ $PLUGIN_DRY_RUN == true ]] && params+=(--dry-run)
[[ -n "${PLUGIN_TAG_PREFIX}" ]] && params+=(--tag-prefix=${PLUGIN_TAG_PREFIX})


[[ $PLUGIN_SKIP_BUMP == true ]] && params+=(--skip.bump)
[[ $PLUGIN_SKIP_CHANGELOG == true ]] && params+=(--skip.changelog)
[[ $PLUGIN_SKIP_COMMIT == true ]] && params+=(--skip.commit)
[[ $PLUGIN_SKIP_TAG == true ]] && params+=(--skip.tag)
[[ $PLUGIN_COMMIT_ALL == true ]] && params+=(--commit-all)

[[ $PLUGIN_SILENT == true ]] && params+=(--silent)
[[ -n "${PLUGIN_INFILE}" ]] && params+=(--infile=$PLUGIN_INFILE)


standard-version ${params[@]}