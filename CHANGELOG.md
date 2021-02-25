# Changelog

All notable changes to Avalon project will be documented in this file. Avalon (ERA-AV) is a University of Alberta Libraries-based Audio/Visual repository. https://era-av.library.ualberta.ca/.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and releases in Jupiter project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Table of Contents

- [Unreleased](#Unreleased)
- [Avalon-6 Production v6.5.0.20201217.uofa](#Production.v6.5.0.20201217.uofa)
- [Avalon-6 Production v6.5.0.20201215.uofa](#Production.v6.5.0.20201215.uofa)
- [Avalon-6 Production v6.5.0.20201004.uofa](#Production.v6.5.0.20201004.uofa)
- [Avalon-6 Production v6.5.0.20200707.uofa](#Production.v6.5.0.20200707.uofa)
- [Avalon-6 Production v6.5.0.20200612.uofa](#Production.v6.5.0.20200612.uofa)
- [Avalon-6 Production v6.5.0.20200528.uofa](#Production.v6.5.0.20200528.uofa)
- [Avalon-6 Production v6.5.0.20200514.uofa](#Production.v6.5.0.20200514.uofa)
- [Avalon-6 Production v6.4.3.20200303.uofa](#Production.v6.4.3.20200303.uofa)
- [Avalon-6 Production v6.4.3.20200120.uofa](#Production.v6.4.3.20200120.uofa)
- [Avalon-6 Production v6.4.3.20191204.uofa](#Production.v6.4.3.20191204.uofa)
- [Avalon-6 Production v6.4.3.20190924.uofa](#Production.v6.4.3.20190924.uofa)
- [Avalon-6 Production v6.4.3.20190821.uofa](#Production.v6.4.3.20190821.uofa)
- [Avalon-6 Production v6.4.3.20190809.uofa](#Production.v6.4.3.20190809.uofa)
- [Avalon-6 Production v6.4.3.20190709.uofa](#Production.v6.4.3.20190709.uofa)
- [Avalon-6 6.4.3.Unreleased](#Avalon.v6.4.3.Unreleased)
- [Avalon-6 6.4.2.Unreleased](#Avalon.v6.4.2.Unreleased)
- [Avalon-5 v5.1.5.20180727](#Avalon-v5.1.5.20180727)

<a name="Unreleased" />

### Unreleased

#### Fixed

- Update React Structural Metadata Editor JS package and associated Avalon upstream code; bump version of serialize-javascrip to 3.1.0 and node-forge to 0.10.0 [#680](https://github.com/ualbertalib/avalon/issues/680) 
- Address Blacklight and StringIO#lines deprecation warnings [#703](https://github.com/ualbertalib/avalon/pull/703) 

<a name="Production.v6.5.0.20201217.uofa" />

### Avalon-6 Production v6.5.0.20201217.uofa
#### Fixed

- Add directory creation to locking_runner [#690](https://github.com/ualbertalib/avalon/issues/690)

<a name="Production.v6.5.0.20201215.uofa" />

### Avalon-6 Production v6.5.0.20201215.uofa

#### Security

- [Security] Bump ini from 1.3.5 to 1.3.8 [PR #687](https://github.com/ualbertalib/avalon/pull/687)

#### Fixed

- Adds property to adjust transcoding client timeout for 8GB - 22 GB master file ingest [#650](https://github.com/ualbertalib/avalon/issues/650); [PR #660](https://github.com/ualbertalib/avalon/pull/660) enhances [PR #651](https://github.com/ualbertalib/avalon/pull/651)

<a name="Production.v6.5.0.20201004.uofa" />

### Avalon-6 Production v6.5.0.20201004.uofa

#### Fixed

- Revise policies text [issue #670](https://github.com/ualbertalib/avalon/issues/670)

#### Security

- [Security] Bump lodash from 4.17.15 to 4.17.20 [PR #678](https://github.com/ualbertalib/avalon/pull/678)

<a name="Production.v6.5.0.20200929.uofa" />

### Avalon-6 Production v6.5.0.20200929.uofa

#### Security

- [Security] Bump rails from 5.2.3 to 5.2.4.4 [CVE-2020-15169](https://groups.google.com/g/rubyonrails-security/c/b-C9kSGXYrc/m/rNlE_9EGAwAJ)

#### Feature

- Adds rake task to update visibility for a set of MediaObjects [#596](https://github.com/ualbertalib/avalon/issues/596)
- Restore unit metadata; update controlled vocabulary [PR #634](https://github.com/ualbertalib/avalon/pull/634)
- Update url of CC BY 4.0 license; fixes validation issue [#583](https://github.com/ualbertalib/avalon/issues/583)


<a name="Production.v6.5.0.20200707.uofa" />

### Avalon-6 Production v6.5.0.20200707.uofa

#### Fixed

- Update University of Alberta Library logo [#635](https://github.com/ualbertalib/avalon/issues/635)
- Add ability to change timeout of transcoding (Matterhorn) for master files 13GB or greater via environment variable: `AVALON_MATTERHORN_TIMEOUT`. Addresses [#650](https://github.com/ualbertalib/avalon/issues/650). Note: not needed in Avalon v7.1 due to code refactoring around transcoding (i.e., replacement of Matterhorn).

#### Bugfix

- Fix formatting in settings.yaml [#654](https://github.com/ualbertalib/avalon/pull/654)
- Fix problem opening structural metadata editor; update javascript packages [#652](https://github.com/ualbertalib/avalon/issues/652)

#### Security

- [Security] Bump rack from 2.0.9 to 2.2.3 [#649](https://github.com/ualbertalib/avalon/pull/649)


<a name="Production.v6.5.0.20200612.uofa" />

### Avalon-6 Production v6.5.0.20200612.uofa

#### Security

- [Security] Bump websocket-extensions Javascript from 0.1.3 to 0.1.4 [646](https://github.com/ualbertalib/avalon/pull/646)
- [Security] Bump websocket-extensions Gem from 0.1.3 to 0.1.5 [645](https://github.com/ualbertalib/avalon/pull/645)

#### Bugfix

- Add staging environment to webpacker.yml [647](https://github.com/ualbertalib/avalon/issues/647)


<a name="Production.v6.5.0.20200528.uofa" />

### Avalon-6 Production v6.5.0.20200528.uofa

#### Security

- [Security] Bump kaminari from 1.1.1 to 1.2.1 [#643](https://github.com/ualbertalib/avalon/pull/643)

<a name="Production.v6.5.0.20200514.uofa" />

### Avalon-6 Production v6.5.0.20200514.uofa

Updates to upstream [Avalon tagged version v6.5.0](https://github.com/avalonmediasystem/avalon/tree/v6.5.0). For a detailed view of the features added, see [upstream release notes](https://github.com/avalonmediasystem/avalon/releases/tag/v6.5.0). Highlights:

- Structural Metadata Editor
- IIIF Timeliner
- IIIF Presentation 3.0 Manifest Generation
- Enhancements to the API [details](https://wiki.dlib.indiana.edu/display/VarVideo/Avalon+Ingest+API#AvalonIngestAPI-mediaobjects)
- Rails 5.2 support, Webpacker JavaScript packages via Yarn

To apply update to an Avalon v6.4 instance make certain to:

- Backup DB as this version contains a DB migration updating autogenerated primary key columes and foreign key colums from int to bigint. [PR #627.](https://github.com/ualbertalib/avalon/pull/627).

- Follow the upgrade details at <https://wiki.dlib.indiana.edu/display/VarVideo/Upgrading+Avalon+6.4+to+Avalon+6.5>
  - UAL specific considerations / modifications to upstream instructions
    - Re. (2), environment variables: instead of altering `settings.yml` as per the indiana.edu instructions, add to the UAL setup for Apache and sysconf the following env var: `SETTINGS__TIMELINER__TIMELINER_URL=https://${hostname}/timeliner`
    - Re. (2), db migration details: adds timeline table and the Rails 4 automatically generated primary key and foreign keys to bigint (the default in Rails 5.2) as per [commit dc5b567](https://github.com/ualbertalib/avalon/commit/dc5b56754b4c01b7be67d8caac57a2661471381e)
      - backup db beforehand
    - Re. (3), Node.js version (tried v12 but it failed) indiana.edu indicate "tested with v10"
      - v10 maintenance support ends April 2021 (reference: <https://github.com/nodejs/Release>)
        - Tested v12 on 2020-03-02: result fails.
      - Note: also I modified .travis `nvm install 10` for tests (the default nvm version is incompatible - tested 2020-03-02)
    - Re. (10), waveform_backfill (needs to be run with the following environment variables: `/etc/sysconfig/avalon6_env`)
    - Ruby version considerations: UAT tested with Ruby 2.5, Travis tests Ruby 2.5 and 2.6. Upstream instructions indication Ruby 2.4 or above.

#### Security

- various security updates to Gems and Javascript packages.


<a name="Production.v6.4.3.20200303.uofa" />

### Avalon-6 Production v6.4.3.20200303.uofa

#### Security

- [Security] Bump nokogiri from 1.10.5 to 1.10.9 [#616](https://github.com/ualbertalib/avalon/pull/616)
- [Security] Bump omniauth from 1.7.1 to 1.9.1 [#617](https://github.com/ualbertalib/avalon/pull/617)

<a name="Production.v6.4.3.2020200120.uofa" />

### Avalon-6 Production v6.4.3.20200120.uofa

#### Changed

- typeahead autocompletion of language [#545](https://github.com/ualbertalib/avalon/issues/545)

#### Security

- [Security] Bump rack from 1.6.11 to 1.6.12 [#593](https://github.com/ualbertalib/avalon/issues/593)

<a name="Production.v6.4.3.20191204.uofa" />

### Avalon-6 Production v6.4.3.20191204.uofa

#### Changed

- Batch ingest emails now display full path of manifest file [#533](https://github.com/ualbertalib/avalon/issues/533)
- default Application name [#541](https://github.com/ualbertalib/avalon/issues/541)
- Documentation: fix name of controlled vocabulary environment variable [#418](https://github.com/ualbertalib/avalon/pull/418)
- Documentation: fixes missing `FEDORA_BASE_PATH` [#465](https://github.com/ualbertalib/avalon/pull/465)
- Documentation: add LTI config env variables [#582](https://github.com/ualbertalib/avalon/issues/582)
- Don't permit Genre with alternate capitalization [#545](https://github.com/ualbertalib/avalon/issues/545)
- Fixes conversion of genre field to lowercase upon submission [#559](https://github.com/ualbertalib/avalon/issues/559) [PR #573](https://github.com/ualbertalib/avalon/pull/573)

#### Added

- include opensearch description in the layout [#519](https://github.com/ualbertalib/avalon/issues/519)

#### Security

- [Security] Bump loofah from 2.2.3 to 2.3.1 [#565](https://github.com/ualbertalib/avalon/pull/565)
- [Security] Bump nokogiri from 1.10.4 to 1.10.5 [#579](https://github.com/ualbertalib/avalon/pull/579)
- [Security] Bump rubyzip from 1.2.2 to 1.3.0 [PR #565](https://github.com/ualbertalib/avalon/pull/565)
- [Security] Bump devise from 4.6.2 to 4.7.1 [PR #555](https://github.com/ualbertalib/avalon/pull/555)

<a name="Production.v6.4.3.20190924.uofa" />

### Avalon-6 Production v6.4.3.20190924.uofa

#### Changed

- use a direct link to the Feature Item rather than a search avoids needing to be logged-in [#529](https://github.com/ualbertalib/avalon/issues/529)
- use a public collection for the Featured Video Collection rather than a protected one [#536](https://github.com/ualbertalib/avalon/issues/536)

#### Fixed

- Fixed audio quality selector being cut off on mobile by opening selector downwards [#531](https://github.com/ualbertalib/avalon/issues/531)
- update the links on the edit page to the EDTF standard [#419](https://github.com/ualbertalib/avalon/issues/419)

#### Security

- [Security] Bump nokogiri from 1.10.3 to 1.10.4 [PR#549](https://github.com/ualbertalib/avalon/pull/549)

<a name="Production.v6.4.3.20190821.uofa" />

### Avalon-6 Production v6.4.3.20190821.uofa

#### Bugfix

- Fixes authentication configuration in staging/production environment to have shibboleth as the default [PR#520](https://github.com/ualbertalib/avalon/pull/520)

<a name="Production.v6.4.3.20190809.uofa" />
### Avalon-6 Production v6.4.3.20190809.uofa

#### Added

- include controlled vocabulary config file to repo [PR#508](https://github.com/ualbertalib/avalon/pull/508/files)
- add missing Rollbar initializer [PR#508](https://github.com/ualbertalib/avalon/pull/508/files)

#### Bugfix

- Fixes misspelled "Policies" heading with page footer [#504](https://github.com/ualbertalib/avalon/issues/504)
- Fix "About ERA A+V" page content [#505](https://github.com/ualbertalib/avalon/issues/505)
- Update link URL for ERA deposit agreement [#506](https://github.com/ualbertalib/avalon/issues/506)

<a name="Production.v6.4.3.20190709.uofa" />

### Production v6.4.3.20190709.uofa

#### Notes

Tagged production release

<a name="Avalon.v6.4.3.Unreleased" />

### [Avalon-6 6.4.3.Unreleased]

#### Notes

- this change log record starts at such time (i.e., 2018-07-26) the upstream tag [v6.4.3](https://github.com/ualbertalib/avalon/pull/347) was merged into the local UAL `avalon-6` branch along with the following additions. This record might be incomplete as the list was compiled after the fact. Also note some PRs have been merged into the upstream master.

#### Security

- Bups rails from 4.2.9 to 4.2.11.1. This update addresses [Two Vulnerabilities in Action View](https://weblog.rubyonrails.org/2019/3/13/Rails-4-2-5-1-5-1-6-2-have-been-released/). [PR#429](https://github.com/ualbertalib/avalon/pull/429)
- Bups devise from devise from 3.5.10 to 4.6.1. This update addresses [CVE-2019-5421](https://github.com/rubysec/ruby-advisory-db/blob/master/gems/devise/CVE-2019-5421.yml). [PR#437](https://github.com/ualbertalib/avalon/pull/437)

#### Added

- New file management strategy to allow retention of UI uploaded files in directory named after the collection (similarly to the drop box ingest workflow) [PR #454](https://github.com/ualbertalib/avalon/pull/454)
  - Requires the following config to be added/changed to enable
    - `SETTINGS__MASTER_FILE_MANAGEMENT__PATH=/path/to/retention/dir`
    - `SETTINGS__MASTER_FILE_MANAGEMENT__STRATEGY=move_ui_upload_only`
- Shibboleth authenication (CCID-based) [PR #409](https://github.com/ualbertalib/avalon/pull/409/files)
- Environment variable based configuration [#415](https://github.com/ualbertalib/avalon/pull/415) and samples [#416](https://github.com/ualbertalib/avalon/pull/416)
- UofA Libraries splash page theme [#410](https://github.com/ualbertalib/avalon/pull/410), [#411](https://github.com/ualbertalib/avalon/pull/411) & [#412](https://github.com/ualbertalib/avalon/pull/412)
- batch ingest post-encoding email [#403](https://github.com/ualbertalib/avalon/pull/403)
- setup `resque` logging [#378](https://github.com/ualbertalib/avalon/pull/382)
- Unpublish button for editors of a media object [#354](https://github.com/ualbertalib/avalon/pull/354)
- Audit report email task, ported from Avalon 5 [#350](https://github.com/ualbertalib/avalon/pull/350)

#### Changed

- UI formatting tweaks: splash-page text size & footer margin [PR #452](UI formatting tweaks: splash-page text size & footer margin #452)
- switch backend from PostgreSQL to MySQL (MariaDB) - Docker & Travis [#405](https://github.com/ualbertalib/avalon/pull/405)
- resource description form: remove ability to import by bibliographic id [#398](https://github.com/ualbertalib/avalon/pull/398)
- resource description form: add deposit agreement checkbox [#394](https://github.com/ualbertalib/avalon/pull/394)

#### Fixed

- Fix lograge warning & iconv deprecation [#456](https://github.com/ualbertalib/avalon/pull/456/files)
- fixes for the matterhorn path [#396](https://github.com/ualbertalib/avalon/pull/396)
- Docker: reconfigure allowing streaming to work with full docker stack (for development) [#393](https://github.com/ualbertalib/avalon/pull/393)
- Docker: avalon (rails) container store the installed gems in a volume [#392](https://github.com/ualbertalib/avalon/pull/392)
- Batch ingest: interpreting the terms of use field as an array [#385](https://github.com/ualbertalib/avalon/pull/385)
- Bad copy/paste for notes form field [#382](https://github.com/ualbertalib/avalon/pull/382)
- fix path that matterhorn encoder sees [#379](https://github.com/ualbertalib/avalon/pull/382)
- Docker: fix bogus hardcoded redis database number for full docker-compose config [#367](https://github.com/ualbertalib/avalon/pull/367)

<a name="Avalon.v6.4.2.Unreleased" />

### [Avalon-6 6.4.2.Unreleased]

#### Notes

Starting point for Avalon-6 (I think as I piece together the past). Merge pull request #2927 from avalonmediasystem/staging [6.4.2 Release](https://github.com/ualbertalib/avalon/commit/6d6885f4e1fdc6b1ccd6c1160fb7f9230853a868)

#### Added

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

### [Avalon-5 v5.1.5.20180727]

#### Fixed

- Point Gemfile to a version of rubyhorn that has a five minute timeout by default[#353](https://github.com/ualbertalib/avalon/pull/353)
- Allow JSON access to public published media objects without an API token [#354](https://github.com/ualbertalib/avalon/pull/354)
