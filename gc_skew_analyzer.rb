require 'dna'
require 'json'
require './sequence'

class GCSkewAnalyzer

  def initialize(filename, window_length=50)
    @filename = filename
    @window_length = window_length # the length of window that we'll use for computing G/C skew
  end



  private

  def filename
    @filename
  end

  def window_length
    @window_length
  end

end