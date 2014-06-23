rspec_options = {
  cmd: 'rspec -f documentation',
  fail_mode: :keep,
  all_after_pass: true,
  all_on_start: true,
  run_all: {cmd: 'rspec -f progress'}
}

guard :rspec, rspec_options do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/support/.+\.rb$}) { "spec" }
end

