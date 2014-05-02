require 'spec_helper'

describe 'GCSkewAnalyzer' do
  let(:filename) { 'test.fasta' }
  let(:default_window_length) { 50 }

  context 'building the class' do
    let(:alternate_window_length) { 75 }

    context 'without passing default window length' do
      before :each do
        @gc_skew_analyzer = GCSkewAnalyzer.new(filename)
      end
      describe '#new' do
        it 'should take a filename and initialize the class with it' do
          @gc_skew_analyzer.instance_variable_get('@filename').should == filename
          @gc_skew_analyzer.instance_variable_get('@window_length').should == default_window_length
        end
      end
      context 'passing default window length' do
        before :each do
          @gc_skew_analyzer = GCSkewAnalyzer.new(filename, alternate_window_length)
        end
        describe '#new' do
          it 'should initialize both filename and window length' do
            @gc_skew_analyzer.instance_variable_get('@filename').should == filename
            @gc_skew_analyzer.instance_variable_get('@window_length').should == alternate_window_length
          end
        end
      end
    end

    context 'getter and setter methods' do
      before :each do
        @gc_skew_analyzer = GCSkewAnalyzer.new(filename)
      end

      describe '#filename' do
        it 'should retrieve the filename' do
          @gc_skew_analyzer.send(:filename).should == filename
        end
      end

      describe '#window_length' do
        it 'should retrieve the window length' do
          @gc_skew_analyzer.send(:window_length).should == default_window_length
        end
      end
    end
  end
end