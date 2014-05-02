require 'spec_helper'

describe 'Sequence' do
  let(:sequence) { ('gatc' * 50) } #gatcgatcgatcgatc.....

  context "initialization with default window length" do
    let(:default_window_length) { 50 }
    before :each do
      @sequence = Sequence.new(sequence)
    end
    describe '#initialize' do
      it 'should set the sequence and window length properly' do
        @sequence.instance_variable_get('@sequence').should == sequence
        @sequence.instance_variable_get('@window_length').should == default_window_length
        @sequence.instance_variable_get('@window_base_count').should == nil
      end
    end
  end
  context "initialization with alternate window length" do
    let(:alternate_window_length) { 75 }
    before :each do
      @sequence = Sequence.new(sequence, alternate_window_length)
    end
    describe '#initialize' do
      it 'should set the sequence and window length properly' do
        @sequence.instance_variable_get('@sequence').should == sequence
        @sequence.instance_variable_get('@window_length').should == alternate_window_length
        @sequence.instance_variable_get('@window_base_count').should == nil
      end
    end
  end

  context "getter and setter methods" do
    let(:window_length) { 50 }
    before :each do
      @sequence = Sequence.new(sequence, window_length)
    end

    describe '#window_start' do
      it 'initialize window start to nil' do
        @sequence.window_start.should be_nil
      end
    end

    describe '#window_end' do
      it 'should initialize window_end to nil' do
        @sequence.window_end.should be_nil
      end
    end

    describe '#window_length' do
      it 'should initialize window length to the default window length' do
        @sequence.send(:window_length).should == window_length
      end
    end
  end

  context 'generating base counts' do
    let(:count) { 50 }
    let(:sequence) { ('gatc' * count) }
    let(:base_count) do
      {
        :g => count,
        :a => count,
        :t => count,
        :c => count
      }
    end
    before :each do
      @sequence = Sequence.new(sequence)
    end
    describe '#base_count' do 
      it 'should compute base counts correctly' do
        @sequence.send(:base_count, sequence).should == base_count
      end
    end

    describe '#increment_base_count' do
      it 'should increment the base count properly' do
        exiting_base = 'g'
        next_base = 'c'
        original_base_count = base_count

        @sequence.send(:increment_base_count, exiting_base, next_base, original_base_count)
        original_base_count[exiting_base.to_sym].should == count - 1
        original_base_count[next_base.to_sym].should == count + 1
      end
    end
  end

  context 'iterating through windows' do
    describe '#next_window' do
      before :all do
        @sequence_text = ('gatc' * 10)
        @window_length = 5
        @sequence = Sequence.new(@sequence_text, @window_length)
      end

      context 'getting the first window' do
        it 'should get the first window in the sequence' do
          window = @sequence.next_window
          @sequence.window_start.should == 0
          @sequence.window_end.should == @window_length - 1
          @sequence.window_base_count.should == {
            :g => 2,
            :a => 1,
            :t => 1,
            :c => 1
          }
        end
      end

      context 'getting the second window' do
        it 'should get the second window in the sequence' do
          window = @sequence.next_window
          @sequence.window_start.should == 1
          @sequence.window_end.should == @sequence.window_start + @window_length - 1
          @sequence.window_base_count.should == {
            :g => 1,
            :a => 2,
            :t => 1,
            :c => 1
          }
        end
      end
    end

    context 'iterating through the sequence' do
      before :all do
        @sequence_text = ('gatc' * 10)
        @window_length = 5
        @window_count = @sequence_text.length - @window_length + 1 #(e.g. sequence of length 4, window of length 3 has 2 windows)
        @sequence = Sequence.new(@sequence_text, @window_length)
      end

      describe '#next_window' do
        it 'should be able to iterate through the existing windows' do
          #before we've walked through the sequence, there should be more windows to walk through
          @sequence.more_windows?.should == true
          #iterate through all of the (n-1) windows. since there will always be at least one more window, more_windows should always be true
          (@window_count - 1).times do
            @sequence.next_window
            @sequence.more_windows?.should == true
          end
        end

        it 'should not iterate beyond the end of the sequence' do
          @sequence.more_windows?.should == true #initially, we're one from the end
          @sequence.next_window #walk one more step
          @sequence.more_windows?.should == false
        end

        it 'should raise an error if you try to iterate from the end of the sequence' do
          @sequence.more_windows?.should == false
          expect{ @sequence.next_window }.to raise_error(EndOfSequenceError)
        end
      end
    end
  end
end