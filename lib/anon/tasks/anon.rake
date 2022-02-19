desc 'Run schema anonymization'
task anon: :environment do
  path = Rails.root.join(Anon.config.script_path)
  Anon::Script.new(path).run!
end
