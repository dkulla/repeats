require 'pry'
class SequenceTooShortError < StandardError; end
class EndOfSequenceError < StandardError; end

class Sequence

  def initialize(sequence, window_length = 50)
    raise SequenceTooShortError.new if sequence.length < window_length

    @sequence = sequence
    @window_length = window_length
    @window_base_count = nil
    @window_start = nil
    @window_end = nil
    @more_windows = true
  end

  def next_window
    raise EndOfSequenceError.new unless more_windows?

    if @window_base_count # do things if we've already started walking and there are more windows to iterate through
      exiting_base = sequence[@window_start]
      entering_base = sequence[@window_end + 1]
      increment_base_count(exiting_base, entering_base, window_base_count)
      increment_window
      @more_windows = false if window_end >= sequence.length - 1 #set to false if window end points to the last char of the sequence
    else
      @window_start = 0
      @window_end = window_length - 1
      @window_base_count = base_count(sequence[@window_start..@window_end])
      @more_windows = false if window_end >= sequence.length - 1
    end
  end

  def window_start
    @window_start
  end

  def window_end
    @window_end
  end

  def window_base_count
    @window_base_count
  end

  def more_windows?
    @more_windows
  end

  private

  def window_length
    @window_length
  end

  def sequence
    @sequence
  end

  def increment_window
    return false if @window_end >= sequence.length #don't allow the window to shift off the end of the sequence
    @window_start += 1
    @window_end += 1
    true
  end

  #get the distribution of bases for a given DNA sequence
  def base_count(seq)
    {
      :g => seq.scan(/G/i).count,
      :a => seq.scan(/A/i).count,
      :t => seq.scan(/T/i).count,
      :c => seq.scan(/C/i).count
    }
  end

  def increment_base_count(exiting_base, next_base, base_count)
    base_count[exiting_base.to_sym] -= 1
    base_count[next_base.to_sym] += 1
    base_count
  end
end