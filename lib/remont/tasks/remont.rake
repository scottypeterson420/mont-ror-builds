desc 'Run schema processing'
task :remont, [:script_path] => :environment do |_, args|
  script_path = args[:script_path]
  abort 'Missing script path' unless script_path

  path = Rails.root.join(script_path)
  Remont::Script.new(path).run!
end
