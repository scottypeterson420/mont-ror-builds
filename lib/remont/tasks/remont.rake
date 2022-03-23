desc 'Run schema processing'
task :remont, [:script_path] => :remont_env do |_, args|
  script_path = args[:script_path]
  abort 'Missing script path' unless script_path

  path = Rails.root.join(script_path)
  Remont::Script.new(path).run!
end

task :remont_env do # rubocop:disable Rails/RakeEnvironment
  Rake::Task['environment'].invoke
rescue StandardError # rubocop:disable Lint/SuppressedException
end
