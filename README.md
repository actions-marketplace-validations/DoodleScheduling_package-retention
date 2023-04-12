## ghcr.io package retention action

[![release](https://img.shields.io/github/release/DoodleScheduling/package-retention/all.svg)](https://github.com/DoodleScheduling/package-retention/releases)
[![release](https://github.com/doodlescheduling/package-retention/actions/workflows/release.yaml/badge.svg)](https://github.com/doodlescheduling/package-retention/actions/workflows/release.yaml)
[![report](https://goreportcard.com/badge/github.com/DoodleScheduling/package-retention)](https://goreportcard.com/report/github.com/DoodleScheduling/package-retention)
[![Coverage Status](https://coveralls.io/repos/github/DoodleScheduling/package-retention/badge.svg?branch=master)](https://coveralls.io/github/DoodleScheduling/package-retention?branch=master)
[![license](https://img.shields.io/github/license/DoodleScheduling/package-retention.svg)](https://github.com/DoodleScheduling/package-retention/blob/master/LICENSE)

Package retention manager for ghcr.io.
Unlike other actions implementing a similar mechanism this action actually has support for docker manifests
and can do retentions for multi platform image tags.

* Delete packages based on age (and optionally in combination with a regex filter)
* Supports rentention for multi platform container images

### Inputs

```yaml
  token:
    description: "Github API token"
    required: true
    default: ${{ github.token }}
  package-name:
    description: 'Comma delimted names of packages to target (They all need to be of the same package type)'
    required: true
  package-type:
    description: 'The type of the package (container, maven, ...)'
    required: true
  age:
    description: 'Consider the last update timestamp whether a package version should be deleted. (Example: 48h). Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h".'
    required: false
  version-match:
    description: 'Regex to match a version. Note for containers it will match container tags (If package-type is container)'
    required: false
  organization-name:
    description: 'Name of the github organization'
    required: true
    default: ${{ github.repository_owner }}
  dry-run:
    description: 'Only attempt to delete, does not actaully delete the versions.'
    required: false
    default: 'true'
```

### Usage

Example usage of a package retention workflow.
This workflow will clean packages daily at midnight.

```yaml
name: package-retention
on:
  schedule:
    - cron: '0 0 * * *'
jobs:
  package-retention:
    permissions:
      packages: write
    runs-on: ubuntu-latest
    steps:
      - uses: doodlescheduling/package-retention@v1
        name: Delete oci helm charts older than 90 days
        with:
          package-name: charts/${{ github.event.repository.name }}
          package-type: container
          age: 2160h
          version-match: 0.0.0-.*
      - uses: doodlescheduling/package-retention@v1
        name: Delete maven snapshot versions older than 90 days
        with:
          package-name: org.example.mypackage
          package-type: maven
          age: 2160h
          version-match: ".*-SNAPSHOT$"
```
