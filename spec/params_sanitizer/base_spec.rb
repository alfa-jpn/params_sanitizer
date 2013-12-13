require 'rspec'
require 'spec_helper'

describe ParamsSanitizer::Base do

  it 'Definitions instance was defined each class.' do
    sanitizer1 = Class.new(ParamsSanitizer::Base)
    sanitizer2 = Class.new(ParamsSanitizer::Base)

    expect(sanitizer1.definitions.equal?(sanitizer2.definitions)).to be_false
  end

  it 'included sanitizers' do
    expect(ParamsSanitizer::Base.methods.include?(:accept_value)).to be_true
  end

  it 'check_duplicated_definition! method can check duplicated.' do
    ParamsSanitizer::Base.stub(:definitions).and_return(
        {
            accept_value:{
                'name'  =>  nil,
                'email' => nil,
            }
        }
    )

    expect {
      ParamsSanitizer::Base.check_duplicated_definition!('safe')
    }.not_to raise_error

    expect {
      ParamsSanitizer::Base.check_duplicated_definition!('email')
    }.to raise_error
  end

  it 'permit_filter called after call sanitize.' do
    sanitizer = Class.new(ParamsSanitizer::Base)
    params    = ActionController::Parameters.new({nyaruko: 'kawaii', suiginto: 'kaminoryouiki'})

    ParamsSanitizer::Base.should_receive(:permit_filter).and_return([:nyaruko])
    params.should_receive(:permit).with([:nyaruko]).and_return(params)

    sanitizer.sanitize(params)
  end

  it 'sanitize_params call sanitizer.' do
    params = {'nyarukosan' => 'w'}

    ParamsSanitizer::Base.stub(:definitions).and_return(
        {
            anime_value: 'rules'
        }
    )

    sanitizer_inst = ParamsSanitizer::Base.new
    sanitizer_inst.should_receive(:sanitize_anime_value!).with(params, 'rules')

    sanitized = sanitizer_inst.sanitize_params(params)

    # return symbol key.
    expect(sanitized.eql?({nyarukosan: 'w'})).to be_true
  end

end
