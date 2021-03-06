# Copyright 2011-2019, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

require 'audio_waveform'
require 'wavefile'

class WaveformService
  def initialize(bit_res = 8, samples_per_pixel = 1024)
    @bit_res = bit_res
    @samples_per_pixel = samples_per_pixel
  end

  def get_waveform_json(uri)
    return nil unless uri.present?
    waveform = AudioWaveform::WaveformDataFile.new(
      sample_rate: 44_100,
      samples_per_pixel: @samples_per_pixel,
      bits: @bit_res
    )
    get_normalized_peaks(uri).each { |peak| waveform.append(peak[0], peak[1]) }
    waveform.to_json
  end

private

  def get_normalized_peaks(uri)
    wave_io = get_wave_io(uri)
    peaks = gather_peaks(wave_io)
    max_peak = peaks.flatten.map(&:abs).max
    res = 2**(@bit_res - 1)
    factor = res / max_peak.to_f
    peaks.map { |peak| peak.collect { |num| (num * factor).to_i } }
  end

  def get_wave_io(uri)
    headers = "-headers $'Referer: #{Rails.application.routes.url_helpers.root_url}\r\n'" if uri.starts_with? "http"
    normalized_uri = uri.starts_with?("file") ? URI.unescape(uri) : uri
    cmd = "#{Settings.ffmpeg.path} #{headers} -i '#{normalized_uri}' -f wav -ar 44100 - 2> /dev/null"
    IO.popen(cmd)
  end

  def gather_peaks(wav_file)
    peaks = []
    WaveFile::Reader.new(wav_file).each_buffer(@samples_per_pixel) do |buffer|
      peaks << [buffer.samples.flatten.min, buffer.samples.flatten.max]
    end
    peaks
  end
end
