# **standard-version plugin for Drone CI**

A utility for versioning using [standard-version](https://github.com/conventional-changelog/standard-version) powered by [Conventional Commits](https://conventionalcommits.org).



# How It Works:

1. Follow the [Conventional Commits Specification](https://conventionalcommits.org) in your repository.
2. When you're ready to release, run `standard-version`.

`standard-version` will then do the following:

1. Retrieve the current version of your repository by looking at `packageFiles`[[1]](#bumpfiles-packagefiles-and-updaters), falling back to the last `git tag`.
2. `bump` the version in `bumpFiles`[[1]](#bumpfiles-packagefiles-and-updaters) based on your commits.
4. Generates a `changelog` based on your commits (uses [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) under the hood).
5. Creates a new `commit` including your `bumpFiles`[[1]](#bumpfiles-packagefiles-and-updaters) and updated CHANGELOG.
6. Creates a new `tag` with the new version number.


# `bumpFiles`, `packageFiles` and `updaters`

`standard-version` uses a few key concepts for handling version bumping in your project.

- **`packageFiles`** – User-defined files where versions can be read from _and_ be "bumped".
  - Examples: `package.json`, `manifest.json`
  - In most cases (including the default), `packageFiles` are a subset of `bumpFiles`.
- **`bumpFiles`** – User-defined files where versions should be "bumped", but not explicitly read from.
  - Examples: `package-lock.json`, `npm-shrinkwrap.json`
- **`updaters`** – Simple modules used for reading `packageFiles` and writing to `bumpFiles`.

By default, `standard-version` assumes you're working in a NodeJS based project... because of this, for the majority of projects you might never need to interact with these options.

That said, if you find your self asking [How can I use standard-version for additional metadata files, languages or version files?](#can-i-use-standard-version-for-additional-metadata-files-languages-or-version-files) – these configuration options will help!


# Usage

### Minimal

```yaml
kind: pipeline
type: docker

steps:
  - name: update version
    image: bibasoft/drone-standard-version
```

### Advanced

```yaml
kind: pipeline
type: docker

steps:
  - name: update version
    image: bibasoft/drone-standard-version
    settings:
      first_release: true
      prerelease: alpha
      release_as: minor
      no_verify: true
      dry_run: true
      tag_prefix: v
      skip_bump: true
      skip_changelog: true
      skip_commit: true
      skip_tag: true
      commit_all: true
      silent: true
      infile: docs/CHANGELOG.md
```


# Configuration

You can configure `standard-version` either by:

1. Placing a `standard-version` stanza in your `package.json` (assuming
   your project is JavaScript).
2. Creating a `.versionrc`, `.versionrc.json` or `.versionrc.js`.
  - If you are using a `.versionrc.js` your default export must be a configuration object, or a function returning a configuration object.

Any of the parameters accepted by `standard-version` can instead
be provided via configuration or plugin settings. Please refer to the [conventional-changelog-config-spec](https://github.com/conventional-changelog/conventional-changelog-config-spec/) for details on available configuration options.


# Customizing CHANGELOG Generation

By default (as of `6.0.0`), `standard-version` uses the [conventionalcommits preset](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-conventionalcommits).

This preset:

* Adheres closely to the [conventionalcommits.org](https://www.conventionalcommits.org)
  specification.
* Is highly configurable, following the configuration specification
  [maintained here](https://github.com/conventional-changelog/conventional-changelog-config-spec).
  * _We've documented these config settings as a recommendation to other tooling makers._

There are a variety of dials and knobs you can turn related to CHANGELOG generation.

As an example, suppose you're using GitLab, rather than GitHub, you might modify the following variables:

* `commitUrlFormat`: the URL format of commit SHAs detected in commit messages.
* `compareUrlFormat`: the URL format used to compare two tags.
* `issueUrlFormat`: the URL format used to link to issues.

Making these URLs match GitLab's format, rather than GitHub's.


# Settings

## **first_release**

To generate your changelog for your first release.

This will tag a release **without bumping the version `bumpFiles`[1]()**.

When you are ready, push the git tag and `npm publish` your first release. \o/

## **prerelease**

If you typically use `npm version` to cut a new release.

As long as your git commit messages are conventional and accurate, you no longer need to specify the semver type - and you get CHANGELOG generation for free! \o/

After you cut a release, you can push the new git tag and `npm publish` (or `npm publish --tag next`) when you're ready.

## **prerelease**

Use the option `prerelease` to generate pre-releases:

Suppose the last version of your code is `1.0.0`, and your code to be committed has patched changes. Use:

```yaml
settings:
  prerelease: true
```

This will tag your version as: `1.0.1-0`.

If you want to name the pre-release, you specify the name via

```yaml
settings:
  prerelease: <name>
```

For example, suppose your pre-release should contain the `alpha` prefix:

```yaml
settings:
  prerelease: alpha
```

This will tag the version as: `1.0.1-alpha.0`

## **release-as**

Release as a Target Type Imperatively (`npm version`-like)

To forgo the automated version bump use `release_as` with `major`, `minor` or `patch`.

Suppose the last version of your code is `1.0.0`, you've only landed `fix:` commits, but
you would like your next release to be a `minor`.

You will get version `1.1.0` rather than what would be the auto-generated version `1.0.1`.

> **NOTE:** you can combine `release_as` and `prerelease` to generate a release. This is useful when publishing experimental feature(s).

## **no_verify**

Prevent Git Hooks

If you use git hooks, like pre-commit, to test your code before committing, you can prevent hooks from being verified during the commit step by passing the `no_verify` option.

## **sign**

Signing Commits and Tags

If you have your GPG key set up, add the `sign`option.

## **skip_bump**, **skip_changelog**, **skip_commit**, **skip_tag**,

Skipping Lifecycle Steps

You can skip any of the lifecycle steps (`bump`, `changelog`, `commit`, `tag`)

```yaml
settings:
  skip_bump: true
```

## **commit_all**

Committing Generated Artifacts in the Release Commit

If you want to commit generated artifacts in the release commit, you can use the `commit_all` option. You will need to stage the artifacts you want to commit.

## **dry_run**

Dry Run Mode

running with the option `dry_run` allows you to see what
commands would be run, without committing to git or updating files.

## **tag_prefix**

Prefix Tags

Tags are prefixed with `v` by default. If you would like to prefix your tags with something else, you can do so with the `tag_prefix` option.

```yaml
settings:
  tag_prefix: @scope/package
```

This will prefix your tags to look something like `@scope/package@2.0.0`

If you do not want to have any tag prefix you can use the `tag_prefix` option and provide it with an **empty string** as value.

> Note: simply tag_prefix without any value will fallback to the default 'v'




# FAQ

## How is `standard-version` different from `semantic-release`?

[`semantic-release`](https://github.com/semantic-release/semantic-release) is described as:

> semantic-release automates the whole package release workflow including: determining the next version number, generating the release notes and publishing the package.

While both are based on the same foundation of structured commit messages, `standard-version`  takes a different approach by handling versioning, changelog generation, and git tagging for you **without** automatic pushing (to GitHub) or publishing (to an npm registry). Use of `standard-version` only affects your local git repo - it doesn't affect remote resources at all. After you run `standard-version`, you can review your release state, correct mistakes and follow the release strategy that makes the most sense for your codebase.

We think they are both fantastic tools, and we encourage folks to use `semantic-release` instead of `standard-version` if it makes sense for their use-case.

## Should I always squash commits when merging PRs?

The instructions to squash commits when merging pull requests assumes that **one PR equals, at most, one feature or fix**.

If you have multiple features or fixes landing in a single PR and each commit uses a structured message, then you can do a standard merge when accepting the PR. This will preserve the commit history from your branch after the merge.

Although this will allow each commit to be included as separate entries in your CHANGELOG, the entries will **not** be able to reference the PR that pulled the changes in because the preserved commit messages do not include the PR number.

For this reason, we recommend keeping the scope of each PR to one general feature or fix. In practice, this allows you to use unstructured commit messages when committing each little change and then squash them into a single commit with a structured message (referencing the PR number) once they have been reviewed and accepted.

## Can I use `standard-version` for additional metadata files, languages or version files?

As of version `7.1.0` you can configure multiple `bumpFiles` and `packageFiles`.

1. Specify a custom `bumpFile` "`filename`", this is the path to the file you want to "bump"
2. Specify the `bumpFile` "`updater`", this is _how_ the file will be bumped.
    a. If you're using a common type, you can use one of  `standard-version`'s built-in `updaters` by specifying a `type`.
    b. If your using an less-common version file, you can create your own `updater`.

```js
// .versionrc
{
  "bumpFiles": [
    {
      "filename": "MY_VERSION_TRACKER.txt",
      // The `plain-text` updater assumes the file contents represents the version.
      "type": "plain-text"
    },
    {
      "filename": "a/deep/package/dot/json/file/package.json",
      // The `json` updater assumes the version is available under a `version` key in the provided JSON document.
      "type": "json"
    },
    {
      "filename": "VERSION_TRACKER.json",
      //  See "Custom `updater`s" for more details.
      "updater": "standard-version-updater.js"
    }
  ]
}
```

If using `.versionrc.js` as your configuration file, the `updater` may also be set as an object, rather than a path:

```js
// .versionrc.js
const tracker = {
  filename: 'VERSION_TRACKER.json',
  updater: require('./path/to/custom-version-updater')
}

module.exports = {
  bumpFiles: [tracker],
  packageFiles: [tracker]
}
```

## Custom `updater`s

An `updater` is expected to be a Javascript module with _atleast_ two methods exposed: `readVersion` and `writeVersion`.

#### `readVersion(contents = string): string`

This method is used to read the version from the provided file contents.

The return value is expected to be a semantic version string.

#### `writeVersion(contents = string, version: string): string`

This method is used to write the version to the provided contents.

The return value will be written directly (overwrite) to the provided file.

---

Let's assume our `VERSION_TRACKER.json` has the following contents:

```json
{
  "tracker": {
    "package": {
      "version": "1.0.0"
    }
  }
}

```

An acceptable `standard-version-updater.js` would be:

```js
// standard-version-updater.js
const stringifyPackage = require('stringify-package')
const detectIndent = require('detect-indent')
const detectNewline = require('detect-newline')

module.exports.readVersion = function (contents) {
  return JSON.parse(contents).tracker.package.version;
}

module.exports.writeVersion = function (contents, version) {
  const json = JSON.parse(contents)
  let indent = detectIndent(contents).indent
  let newline = detectNewline(contents)
  json.tracker.package.version = version
  return stringifyPackage(json, indent, newline)
}
```

# License

ISC
