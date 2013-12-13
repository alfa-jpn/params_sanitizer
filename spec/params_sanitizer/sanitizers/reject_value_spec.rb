require 'rspec'

describe ParamsSanitizer::Sanitizers::RejectValue do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::RejectValue
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have reject_value methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_reject_value!)).to be_true
      expect(Sanitizer.methods.include?(:reject_value)).to                  be_true
    end

    it 'reject_value method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.reject_value(:anime, 'nyaruko', ['hoge', 'fuga'])
    end

    it 'reject_value method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.reject_value(:anime, 'nyaruko', ['hoge', 'fuga'])
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          reject_value: { 'anime' => { default_value: 'nyaruko', reject_values: ['hoge', 'fuga'] } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.reject_value(:anime, 'nyaruko', ['hoge', 'fuga'])
        @rule = definitions[:reject_value]
      end

      it 'sanitize_reject_value! method sanitizes missing params.' do
        params = {'anime' => 'hoge'}
        Sanitizer.new.send(:sanitize_reject_value!, params, @rule)

        expect(params.eql?({'anime' => 'nyaruko'})).to be_true
      end

      it 'sanitize_reject_value! method does not sanitize params.' do
        params = {'anime' => 'kmb'}
        Sanitizer.new.send(:sanitize_reject_value!, params, @rule)

        expect(params.eql?({'anime' => 'kmb'})).to be_true
      end

    end
  end
end
