# Copyright 2017, University of Alberta Libraries.
#   Licensed under the Apache License, Version 2.0 (the "License");
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

module EraAvHelper
  def ualib_logo_link
    link_to("", "https://library.ualberta.ca", :class => 'logo')
  end

  def era_av_logo_link
    image =
      image_tag("ERA-A+V-beta-logo.png",
                alt: "#{t('ualberta.era_av_full')} "\
                "- #{t(:release_label)} #{Avalon::VERSION}")
    return image if current_page?(root_path)
    return link_to(image, root_path)
  end

end
