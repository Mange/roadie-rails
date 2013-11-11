guard :rspec, cli: "--format nested", all_after_pass: true, all_on_start: true, keep_failed: true, run_all: {cli: "--format progress"} do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/support/.+\.rb$}) { "spec" }
end

