require 'rspec'

describe ParamsSanitizer::Sanitizers::AcceptValue do

  context 'after include' do
    before(:each) do
      class Sanitizer
        include ParamsSanitizer::Sanitizers::AcceptValue
      end
      Sanitizer.stub(:check_duplicated_definition!)
    end

    it 'have accept_value methods.' do
      expect(Sanitizer.private_method_defined?(:sanitize_accept_value!)).to be_true
      expect(Sanitizer.methods.include?(:accept_value)).to                  be_true
    end

    it 'accept_value method call check_duplicated_definition!' do
      Sanitizer.stub(:definitions).and_return(Hash.new)
      Sanitizer.should_receive(:check_duplicated_definition!).with(:anime)
      Sanitizer.accept_value(:anime, 'nyaruko', ['nyaruko', 'kmb'])
    end

    it 'accept_value method add rule.' do
      definition = Hash.new
      Sanitizer.stub(:definitions).and_return(definition)

      expect {
        Sanitizer.accept_value(:anime, 'nyaruko', ['nyaruko', 'kmb'])
      }.to change{definition.count}.by(1)

      expect(definition.eql?(
        {
          accept_value: { 'anime' => { default_value: 'nyaruko', accept_values: ['nyaruko', 'kmb'] } }
        })).to be_true
    end

    context 'after define rule' do
      before(:each) do
        definitions = Hash.new
        Sanitizer.stub(:definitions).and_return(definitions)

        Sanitizer.accept_value(:anime, 'nyaruko', ['nyaruko', 'kmb'])
        @rule = definitions[:accept_value]
      end

      it 'sanitize_accept_value! method sanitizes missing params.' do
        params = {'anime' => 'boku ha tomodachi ga suku nai.'}
        Sanitizer.new.send(:sanitize_accept_value!, params, @rule)

        expect(params.eql?({'anime' => 'nyaruko'})).to be_true
      end

      it 'sanitize_accept_value! method does not sanitize params.' do
        params = {'anime' => 'kmb'}
        Sanitizer.new.send(:sanitize_accept_value!, params, @rule)

        expect(params.eql?({'anime' => 'kmb'})).to be_true
      end

    end
  end
end
