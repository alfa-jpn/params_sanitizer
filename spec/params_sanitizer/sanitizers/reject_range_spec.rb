require 'rspec'

describe ParamsSanitizer::Sanitizers::RejectRange do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::RejectRange
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have reject_range methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_reject_range!)).to be_true
      expect(Sanitizer.methods.include?(:reject_range)).to                  be_true
    end

    it 'reject_range method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.reject_range(:anime, 50, 0, 100)
    end

    it 'reject_range method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.reject_range(:anime, 50, 0, 100)
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          reject_range: { 'anime' => { default_value: 50, min: 0, max: 100 } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.reject_range(:anime, 50, 0, 100)
        @rule = definitions[:reject_range]
      end

      it 'sanitize_reject_range! method does not sanitize missing params.' do
        params = {'anime' => '0'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '40'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '80'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '100'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true
      end

      it 'sanitize_reject_range! method sanitizes params.' do
        params = {'anime' => '-50'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => -50})).to be_true

        params = {'anime' => '-1'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => -1})).to be_true

        params = {'anime' => '101'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 101})).to be_true

        params = {'anime' => '150'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'anime' => 150})).to be_true
      end
    end

    context 'after define rule of one limit free.' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.reject_range(:minnil, 50, nil, 100)
        Sanitizer.reject_range(:maxnil, 50, 0, nil)
        @rule = definitions[:reject_range]
      end

      it 'sanitize_reject_range! method does not sanitize missing params.' do
        params = {'minnil' => '-999'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => 50})).to be_true

        params = {'maxnil' => '999'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => 50})).to be_true
      end

      it 'sanitize_reject_range! method sanitizes params.' do
        params = {'minnil' => '150'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'minnil' => 150, 'maxnil' => 50})).to be_true

        params = {'maxnil' => '-50'}
        Sanitizer.new.send(:sanitize_reject_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => -50})).to be_true
      end
    end

  end
end
