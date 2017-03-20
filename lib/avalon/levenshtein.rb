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

module Avalon::Levenshtein
  # The distance between two strings, as measured by the number of
  # edits required to tranform one string into another.
  def levenshtein(first, second)
    matrix = [(0..first.length).to_a]
    (1..second.length).each do |j|
      matrix << [j] + [0] * (first.length)
    end
 
    (1..second.length).each do |i|
      (1..first.length).each do |j|
        if first[j-1] == second[i-1]
          matrix[i][j] = matrix[i-1][j-1]
        else
          matrix[i][j] =
            [ matrix[i-1][j],
              matrix[i][j-1],
              matrix[i-1][j-1],
            ].min + 1
        end
      end
    end
    return matrix.last.last
  end

end
