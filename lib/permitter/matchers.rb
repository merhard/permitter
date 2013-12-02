Kernel.const_get(rspec_module)::Matchers.define :allow_action do |*args|
  match do |permission|
    expect(permission.allow_action?(*args)).to be true
  end
end

Kernel.const_get(rspec_module)::Matchers.define :allow_param do |*args|
  match do |permission|
    expect(permission.allow_action?(*args)).to be true
  end
end
