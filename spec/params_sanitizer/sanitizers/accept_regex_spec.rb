require 'rspec'

describe ParamsSanitizer::Sanitizers::AcceptRegex do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::AcceptRegex
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have accept_regex methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_accept_regex!)).to be_true
      expect(Sanitizer.methods.include?(:accept_regex)).to                  be_true
    end

    it 'accept_regex method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.accept_regex(:anime, '100', /^\d+$/)
    end

    it 'accept_regex method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.accept_regex(:anime, '100', /^\d+$/)
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          accept_regex: { 'anime' => { default_value: '100', regex: /^\d+$/ } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.accept_regex(:anime, '100', /^\d+$/)
        @rule = definitions[:accept_regex]
      end

      it 'sanitize_accept_regex! method sanitizes missing params.' do
        params = {'anime' => '-'}
        Sanitizer.new.send(:sanitize_accept_regex!, params, @rule)
        expect(params.eql?({'anime' => '100'})).to be_true

        params = {'anime' => '-100'}
        Sanitizer.new.send(:sanitize_accept_regex!, params, @rule)
        expect(params.eql?({'anime' => '100'})).to be_true

        params = {'anime' => 'あいうえお'}
        Sanitizer.new.send(:sanitize_accept_regex!, params, @rule)
        expect(params.eql?({'anime' => '100'})).to be_true
      end

      it 'sanitize_accept_regex! method does not sanitize params.' do
        params = {'anime' => '9999'}
        Sanitizer.new.send(:sanitize_accept_regex!, params, @rule)
        expect(params.eql?({'anime' => '9999'})).to be_true

        params = {'anime' => '1234567890'}
        Sanitizer.new.send(:sanitize_accept_regex!, params, @rule)
        expect(params.eql?({'anime' => '1234567890'})).to be_true
      end
    end
  end
end
