desc 'Run schema processing'
task remont: :remonte_env do
  path = Rails.root.join(Remont.config.script_path)
  Remont::Script.new(path).run!
end

task :remont_env do # rubocop:disable Rails/RakeEnvironment
  Rake::Task['environment'].invoke
rescue StandardError # rubocop:disable Lint/SuppressedException
end
