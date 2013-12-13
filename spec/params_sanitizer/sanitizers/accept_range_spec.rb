require 'rspec'

describe ParamsSanitizer::Sanitizers::AcceptRange do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::AcceptRange
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have accept_range methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_accept_range!)).to be_true
      expect(Sanitizer.methods.include?(:accept_range)).to                  be_true
    end

    it 'accept_range method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.accept_range(:anime, 50, 0, 100)
    end

    it 'accept_range method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.accept_range(:anime, 50, 0, 100)
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          accept_range: { 'anime' => { default_value: 50, min: 0, max: 100 } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.accept_range(:anime, 50, 0, 100)
        @rule = definitions[:accept_range]
      end

      it 'sanitize_accept_range! method sanitizes missing params.' do
        params = {'anime' => '-50'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '-1'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '101'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true

        params = {'anime' => '150'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 50})).to be_true
      end

      it 'sanitize_accept_range! method does not sanitize params.' do
        params = {'anime' => '0'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 0})).to be_true

        params = {'anime' => '40'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 40})).to be_true

        params = {'anime' => '80'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 80})).to be_true

        params = {'anime' => '100'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'anime' => 100})).to be_true
      end
    end

    context 'after define rule of one limit free.' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.accept_range(:minnil, 50, nil, 100)
        Sanitizer.accept_range(:maxnil, 50, 0, nil)
        @rule = definitions[:accept_range]
      end

      it 'sanitize_accept_range! method sanitizes missing params.' do
        params = {'minnil' => '150'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => 50})).to be_true

        params = {'maxnil' => '-50'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => 50})).to be_true
      end

      it 'sanitize_accept_range! method does not sanitize params.' do
        params = {'minnil' => '-999'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'minnil' => -999, 'maxnil' => 50})).to be_true

        params = {'maxnil' => '999'}
        Sanitizer.new.send(:sanitize_accept_range!, params, @rule)
        expect(params.eql?({'minnil' => 50, 'maxnil' => 999})).to be_true
      end
    end

  end
end
