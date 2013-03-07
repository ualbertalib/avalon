# Loads configuration information from the YAML file and then sets up the
# dropbox 
#
# This makes a Dropbox object accessible in the controllers to query and find
# out what is available. See lib/avalon/dropbox.rb for details on the API 
require 'avalon/dropbox'

module Avalon
  DEFAULT_CONFIGURATION = {
    "dropbox"=>{},
    "fedora"=>{"namespace"=>"avalon"},
    "matterhorn"=>{},
    "mediainfo"=>{"path"=>"/usr/local/bin/mediainfo"},
    "email"=>{},
    "streaming"=>{
      "server"=>:generic,
      "rtmp_base"=>"rtmp://localhost/avalon/",
      "http_base"=>"http://localhost:3000/streams/",
      "stream_token_ttl"=>20
    }
   }

  env = ENV['RAILS_ENV'] || 'development'
  Configuration = DEFAULT_CONFIGURATION.deep_merge(YAML::load(File.read(Rails.root.join('config', 'avalon.yml')))[env])
  ['dropbox','matterhorn','mediainfo','email','streaming'].each { |key| Configuration[key] ||= {} }
  DropboxService = Dropbox.new Avalon::Configuration['dropbox']['path']
  
  begin
    mipath = Avalon::Configuration['mediainfo']['path']
    unless mipath.blank? 
      Mediainfo.path = Avalon::Configuration['mediainfo']['path']
    end
    url_handler_class = Avalon::Configuration['streaming']['server'].to_s.classify
    Derivative.url_handler = UrlHandler.const_get(url_handler_class.to_sym)
  rescue Exception => e
    logger.fatal "Danger Will Robinson"
    logger.fatal e.backtrace
  end

  def self.matterhorn_config
    mh_server = Configuration['matterhorn']['root'].sub(%r{/+$},'')
    {
      "plugin_urls"=>{
        "analytics"=>"#{mh_server}/usertracking/footprint.xml",
        "annotation"=>"#{mh_server}/annotation/annotations.json",
        "description"=>{
          "episode"=>"#{mh_server}/search/episode.json",
          "stats"=>"#{mh_server}/usertracking/stats.json",
        },
        "search"=>"#{mh_server}/search/episode.json",
        "segments_text"=>"#{mh_server}/search/episode.json",
        "segments_ui"=>"#{mh_server}/search/episode.json",
        "segments"=>"#{mh_server}/search/episode.json",
        "series"=>{
          "series"=>"#{mh_server}/search/series.json",
          "episode"=>"#{mh_server}/search/episode.json"
        }
      },
      "mediaDebugInfo"=>{
        "mediaPackageId"=>"",
        "mediaUrlOne"=>"",
        "mediaUrlTwo"=>"",
        "mediaResolutionOne"=>"",
        "mediaResolutionTwo"=>"",
        "mimetypeOne"=>"",
        "mimetypeTwo"=>""
      }
    }
  end
end
