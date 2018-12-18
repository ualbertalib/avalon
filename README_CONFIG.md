# Avalon 6 config via environment variables

## Summary

Avalon uses two main approaches when setting config parameters:

1. a Gem's built-in approach
2. a Gem called Config that manages settings

(1) A Gem's built-in approach (e.g., reading process specific environment variables). This approach can configure the following:

- DATABASE_URL: {adapter}://{username}:{password}@{host}:{port}/{database}?
- FEDORA_URL: http://{username}:{password}@{host}:{port}/{path}
- MATTERHORN_URL: http://{username}:{password}@{host}:{port}/
- REDIS_URL: redis://localhost:6379
- SOLR_URL: http://localhost:8983/solr/avalon

(2) The Config gem allows settings from environment variables utilizing a '\_\_' double underscore syntax as a level separator, for example: 'SETTINGS\_\_FFMPEG\_\_PATH' translates to 'Settings.ffmpeg.path' in the application or as the following in YAML setting.yml file:

```
  ffmpeg
    path: 'x'
```

The following section details the necessary properties with an example following.

## Environment variables to set

### Database

[Database parameters](https://edgeguides.rubyonrails.org/configuring.html#configuring-a-database): set via environment variable `DATABASE_URL` (alternate: database.yml). E.G. `DATABASE_URL=mysql2://username:password@localhost:port/database_name?pool=5&timeout=5000'

### Fedora Commons

Fedora_parameters: set environment variable `FEDORA_URL`. (alternate: fedora.yml) . E.G. `FEDORA_URL=http://username:password@localhost:port/{path: fcrepo}/rest/{path: prod}`. Fedora Gem: see for details.

#### TODO: as far as I can tell these FCREPO namespaced variables are not used

- FCREPO_URL='http://localhost:8984/fedora/rest'
- FCREPO_USER='username'
- FCREPO_PASSWORD='password'

### Matterhorn

[Matterhorm parameters via the Rubyhorn Gem](https://rubygems.org/gems/rubyhorn): set via: `MATTERHORN_URL`. E.G. MATTERHORN_URL=http://username:password@fully_qualified_domain_externally reachible:4080. `{domain.protocol}://{domain.host}:{domain.port}/{path}`. Note:

Other parameters:

- UofA Lib [PR #283](https://github.com/ualbertalib/avalon/commit/cf83ef590ac7698c399e8c388d8371d119c16b06#diff-3f8f85b622299614ed2fb8ed63b39e52R266) allowing client and server contexts to have different paths
  - `MATTERHORN_CLIENT_MEDIA_PATH` E.G., MATTERHORN_CLIENT_MEDIA_PATH=/masterfiles
  - `MATTERHORN_SERVER_MEDIA_PATH` E.G., MATTERHORN_SERVER_MEDIA_PATH=./masterfiles

### Redis

[Redis](https://github.com/redis/redis-rb): set environment valiable `REDIS_URL`. E.G., REDIS_URL=redis://localhost:6379'

### Solr and Blacklight

Solr and Blacklight: set environment variable `SOLR_URL`. E.G., SOLR_URL='http://localhost:8983/solr/avalon'

### Other

- Google Analytics

  - `GOOGLE_ANALYTICS_TOKEN`

- Secret Key Base

  - `SECRET_KEY_BASE`

- Rollbar
  - `ROLLBAR_TOKEN`: TODO - unsure is this is active

### Config Gem managed properties

The following is a list of properties managed via the Config Gem thru the `settings.yml` and associated yaml files. These properties are identified via the double underscore property from Gem Config (config/initializers/config.rb).

- `SETTINGS__NAME`: used in page titles

- `SETTINGS__DOMAIN`: {domain.protocol}://{domain.host}:{domain.port}

- `SETTINGS__BIB_RETRIEVER__PROTOCOL`:
- `SETTINGS__BIB_RETRIEVER__HOST`:
- `SETTINGS__BIB_RETRIEVER__PORT`:
- `SETTINGS__BIB_RETRIEVER__DATABASE`:
- `SETTINGS__BIB_RETRIEVER__ATTRIBUTE`:

- `SETTINGS__CONTROLLED_VOCABULARY`: E.G., config/controlled_vocabulary.yml'

- Avalon drop box for files (not DropBox the company)

  - `SETTINGS__DROPBOX__PATH`:
  - `SETTINGS__DROPBOX__UPLOAD_URI`:

- E-mail

  - `SETTINGS__EMAIL__COMMENTS`:
  - `SETTINGS__EMAIL__NOTIFICATION`:
  - `SETTINGS__EMAIL__SUPPORT`:
  - `SETTINGS__EMAIL__ERRORS`:
  - `SETTINGS__EMAIL__MAILER__SMTP__ADDRESS`:
  - `SETTINGS__EMAIL__MAILER__SMTP__PORT`:
  - `SETTINGS__EMAIL__MAILER__SMTP__ENABLE_STARTTLS_AUTO`:

- `SETTINGS__FFMPEG__PATH`: E.G., '/usr/bin/ffmpeg'

- `SETTINGS__MASTER_FILE_MANAGEMENT__STRATEGY`: E.G., 'none'

- `SETTINGS__MEDIAINFO__PATH`: E.G., '/usr/bin/mediainfo'

- Streaming server

  - `SETTINGS__STREAMING__SERVER=`: E.G., 'wowza'
  - `SETTINGS__STREAMING__CONTENT_PATH=`:
  - `SETTINGS__STREAMING__STREAM_DEFAULT_QUALITY=`:
  - `SETTINGS__STREAMING__STREAM_TOKEN_TTL=`:
  - `SETTINGS__STREAMING__RTMP_BASE=`: E.G., 'rtmp://{fqdn}/avalon6'
  - `SETTINGS__STREAMING__HTTP_BASE`: E.G., 'http://{fqdn}:1935/avalon6/_definst_'

## Example

```
# database parameters: set via DATABASE_URL (or via database.yml)
DATABASE_URL='mysql2://{username}:{password}@localhost:3306/rails?pool=5&timeout=5000'


# Fedora Gem: see for details
# should 'dev/prod' be added to the path? avdev01 uses '' (empty path) with first configured Nov. 2018
FEDORA_URL='http://{username}:{password}@localhost:8984/fedora/rest/prod'

# Matterhorn: details in Gem Rubyhorn
MATTERHORN_URL='http://matterhorn_system_account:{password}@{host}:4080/'
# UofA Lib pr allowing client and server contexts to have different paths
MATTERHORN_CLIENT_MEDIA_PATH='/masterfiles'
MATTERHORN_SERVER_MEDIA_PATH='/masterfiles'

# Redis Gem: see for details
REDIS_URL='redis://localhost:6379'

# Solr and Blacklight Gems: see for details
SOLR_URL='http://localhost:8983/solr/avalon'


## Config Gem managed properties (i.e., double underscore property names `config/initializers/config.rb`)

SETTINGS__NAME='UAL-Avalon6-dev' # used in page titles

# {domain.protocol}://{domain.host}:{domain.port}
SETTINGS__DOMAIN='https://{host}/'

#
SETTINGS__BIB_RETRIEVER__PROTOCOL='z39.50'
SETTINGS__BIB_RETRIEVER__HOST='129.xxx.xxx.xxx'
SETTINGS__BIB_RETRIEVER__PORT='2200'
SETTINGS__BIB_RETRIEVER__DATABASE='Unicorn'
SETTINGS__BIB_RETRIEVER__ATTRIBUTE='12'

#
SETTINGS__CONTROLLED_VOCABULARY='config/controlled_vocabulary.yml'

# Avalon drop box for files (not DropBox the company
SETTINGS__DROPBOX__PATH='/srv/avalon6/dropbox/'
SETTINGS__DROPBOX__UPLOAD_URI='sftp://{host}/dropbox'

# E-mail
SETTINGS__EMAIL__COMMENTS='deploy@localhost'
SETTINGS__EMAIL__NOTIFICATION='deploy@localhost'
SETTINGS__EMAIL__SUPPORT='deploy@localhost'
SETTINGS__EMAIL__ERRORS='deploy@localhost'
SETTINGS__EMAIL__MAILER__SMTP__ADDRESS='localhost'
SETTINGS__EMAIL__MAILER__SMTP__PORT='25'
SETTINGS__EMAIL__MAILER__SMTP__ENABLE_STARTTLS_AUTO='true'

#
SETTINGS__FFMPEG__PATH='/usr/bin/ffmpeg'

#
SETTINGS__MASTER_FILE_MANAGEMENT__STRATEGY='none'

#
SETTINGS__MEDIAINFO__PATH='/usr/bin/mediainfo'


# Streaming server
SETTINGS__STREAMING__SERVER='wowza'
SETTINGS__STREAMING__CONTENT_PATH='/avalon6'
SETTINGS__STREAMING__STREAM_DEFAULT_QUALITY='medium'
SETTINGS__STREAMING__STREAM_TOKEN_TTL='20'
SETTINGS__STREAMING__RTMP_BASE='rtmp://{host}/avalon6'
SETTINGS__STREAMING__HTTP_BASE='http://{host}:1935/avalon6/_definst_'

#Other

SECRET_KEY_BASE
GOOGLE_ANALYTICS_TOKEN
ROLLBAR_TOKEN


```
