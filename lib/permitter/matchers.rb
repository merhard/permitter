RSpec::Matchers.define :allow_action do |*args|
  match do |permission|
    expect(permission.allowed_action?(*args)).to be true
  end
end

RSpec::Matchers.define :allow_param do |*args|
  match do |permission|
    expect(permission.allowed_param?(*args)).to be true
  end
end
