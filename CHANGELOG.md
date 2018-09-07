# Changelog

All notable changes to Avalon project will be documented in this file. Avalon (ERA-AV) is a University of Alberta Libraries-based Audio/Visual repository. https://era-av.library.ualberta.ca/.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and releases in Jupiter project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Table of Contents

- [Avalon-6 6.4.3.Unreleased](#Avalon.v6.4.3.Unreleased)
- [Avalon-6 6.4.2.Unreleased](#Avalon.v6.4.2.Unreleased)
- [Avalon-5 v5.1.5.20180727](#Avalon-v5.1.5.20180727)


<a name="Avalon.v6.4.3.Unreleased" />

## [Avalon-6 6.4.3.Unreleased]

### Notes

- this change log record starts at such time (i.e., 2018-07-26) the upstream tag [v6.4.3](https://github.com/ualbertalib/avalon/pull/347) was merged into the local UAL `avalon-6` branch along with the following additions. This record might be incomplete as the list was compiled after the fact. Also note some PRs have been merged into the upstream master.

### Added

- batch ingest post-encoding email [#403](https://github.com/ualbertalib/avalon/pull/403)
- setup `resque` logging [#378](https://github.com/ualbertalib/avalon/pull/382)
- Unpublish button for editors of a media object [#354](https://github.com/ualbertalib/avalon/pull/354)
- Audit report email task, ported from Avalon 5 [#350](https://github.com/ualbertalib/avalon/pull/350)

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

<a name="Avalon.v6.4.2.Unreleased" />

## [Avalon-6 6.4.2.Unreleased]

### Notes

Starting point for Avalon-6 (I think as I piece together the past). Merge pull request #2927 from avalonmediasystem/staging [6.4.2 Release](https://github.com/ualbertalib/avalon/commit/6d6885f4e1fdc6b1ccd6c1160fb7f9230853a868)

### Added

- Set up batch ingest to CC the errors mailing list on all communications [#346](https://github.com/ualbertalib/avalon/pull/346)
- Redesign the license and terms of use, as per Issue #294 [#341](https://github.com/ualbertalib/avalon/pull/341)
- LTI integration [#327](https://github.com/ualbertalib/avalon/pull/327)
- Create dropbox directories with group write permissions [#323](https://github.com/ualbertalib/avalon/pull/323)
- Re-adding Google Analytics [#319](https://github.com/ualbertalib/avalon/pull/319)
- Port Avalon 5 Rollbar work to Avalon 6 [#317](https://github.com/ualbertalib/avalon/pull/317)
- Controlled vocabulary changes [#315](https://github.com/ualbertalib/avalon/pull/315)
- Staging / UAT environments [#313](https://github.com/ualbertalib/avalon/pull/313)
- Remove the Unit facet from browse [#309](https://github.com/ualbertalib/avalon/pull/309)
- Make share button more noticeable, as per issue #50. [#304](https://github.com/ualbertalib/avalon/pull/304)
- Make language, subject, genre required, with genre coming from PBCore [#302](https://github.com/ualbertalib/avalon/pull/302)
- Flag required descriptive metadata form fields with red asterisk [#296](https://github.com/ualbertalib/avalon/pull/296)
- Make Solr config (and docker) match what Jupiter is doing. [#283](https://github.com/ualbertalib/avalon/pull/283/commits)

<a name="Avalon-v5.1.5.20180727" />

## [Avalon-5 v5.1.5.20180727]

### Fixed

- Point Gemfile to a version of rubyhorn that has a five minute timeout by default[#353](https://github.com/ualbertalib/avalon/pull/353)
- Allow JSON access to public published media objects without an API token [#354](https://github.com/ualbertalib/avalon/pull/354)
