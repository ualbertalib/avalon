# Changelog

All notable changes to Avalon project will be documented in this file. Avalon (ERA-AV) is a University of Alberta Libraries-based Audio/Visual repository. https://era-av.library.ualberta.ca/.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and releases in Jupiter project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Avalon-6 Unreleased]

### Notes

- the Change Log starts recording as such time (2018-07-26) the upstream tag [v6.4.3](https://github.com/ualbertalib/avalon/pull/347) was merged into the avalon-6 branch along with the following additions - might be incomplete as compliling the list after the fact and some PRs have been merged into the upstream master

### Added

- batch ingest post-encoding email [#403](https://github.com/ualbertalib/avalon/pull/403)
- setup `resque` logging [#378](https://github.com/ualbertalib/avalon/pull/382)
- Unpublish button for editors of a media object [354](https://github.com/ualbertalib/avalon/pull/354)
- Audit report email task, ported from Avalon 5 [350](https://github.com/ualbertalib/avalon/pull/350)

### Changed

- switch backend from PostgreSQL to MySQL (MariaDB) - Docker & Travis [#405](https://github.com/ualbertalib/avalon/pull/405)
- resource description form: remove ability to import by bibliographic id [#398](https://github.com/ualbertalib/avalon/pull/398)
- resource description form: add deposit agreement checkbox [#394](https://github.com/ualbertalib/avalon/pull/394)

### Fixed

- fixes for the matterhorn path [#396](https://github.com/ualbertalib/avalon/pull/396)
- Docker: reconfigure allowing streaming to work with full docker stack (for development) [#393](https://github.com/ualbertalib/avalon/pull/393)
- Docker: avalon (rails) container store the installed gems in a volume [#392](https://github.com/ualbertalib/avalon/pull/392)
- Batch ingest: interpreting the terms of use field as an array [#385](https://github.com/ualbertalib/avalon/pull/385)
- Bad copy/paste for notes form field [#382](https://github.com/ualbertalib/avalon/pull/382)
- fix path that matterhorn encoder sees [#379](https://github.com/ualbertalib/avalon/pull/382)
- Docker: fix bogus hardcoded redis database number for full docker-compose config [#367](https://github.com/ualbertalib/avalon/pull/367)

## [Avalon-5 Unknown]

### Fixed

- Point Gemfile to a version of rubyhorn that has a five minute timeout by default[#353](https://github.com/ualbertalib/avalon/pull/353)
- Allow JSON access to public published media objects without an API token [354](https://github.com/ualbertalib/avalon/pull/354)
