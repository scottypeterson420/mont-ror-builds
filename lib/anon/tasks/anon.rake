desc 'Run schema anonymization'
task anon: :environment do
  Anon::Script.new(Anon.config.script_path).run!
end
