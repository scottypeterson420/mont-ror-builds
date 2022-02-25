desc 'Run schema processing'
task remont: :environment do
  path = Rails.root.join(Remont.config.script_path)
  Remont::Script.new(path).run!
end
