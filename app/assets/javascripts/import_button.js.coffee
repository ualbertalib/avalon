# Copyright 2011-2015, The Trustees of Indiana University and Northwestern
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


$ ->
  import_button_html = '<div class="input-group-btn"><button type="submit" name="media_object[import_bib_record]" class="btn btn-success" value="yes">Import</button></div>'
  $('div.import-button').append(import_button_html)

  bib_import_warning_message =
    'Warning, this import will overwrite the metadata stored on the remote server ' +
    'for this item.\n\nTHERE IS NO UNDO FOR THIS ACTION.\n\n' +
    'Are you sure you would like to continue?'

  window.set_bib_import_warning_message = (msg) ->
    bib_import_warning_message = msg

  $('div.import-button button').click ->
    return confirm(bib_import_warning_message);
