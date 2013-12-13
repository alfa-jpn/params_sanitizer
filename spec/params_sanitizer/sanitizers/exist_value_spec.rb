require 'rspec'

describe ParamsSanitizer::Sanitizers::ExistValue do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::ExistValue
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have exist_value methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_exist_value!)).to be_true
      expect(Sanitizer.methods.include?(:exist_value)).to                  be_true
    end

    it 'exist_value method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.exist_value(:anime, 'nyaruko')
    end

    it 'exist_value method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.exist_value(:anime, 'nyaruko')
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          exist_value: { 'anime' => { default_value: 'nyaruko' } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.exist_value(:anime, 'nyaruko')
        @rule = definitions[:exist_value]
      end

      it 'sanitize_exist_value! method sanitizes missing params.' do
        params = {'anime' => nil}
        Sanitizer.new.send(:sanitize_exist_value!, params, @rule)
        expect(params.eql?({'anime' => 'nyaruko'})).to be_true

        params = {}
        Sanitizer.new.send(:sanitize_exist_value!, params, @rule)
        expect(params.eql?({'anime' => 'nyaruko'})).to be_true
      end

      it 'sanitize_exist_value! method does not sanitize params.' do
        params = {'anime' => 'kmb'}
        Sanitizer.new.send(:sanitize_exist_value!, params, @rule)
        expect(params.eql?({'anime' => 'kmb'})).to be_true
      end
    end
  end
end
