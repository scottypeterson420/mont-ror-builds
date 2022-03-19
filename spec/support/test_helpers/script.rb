require 'tempfile'

module TestHelpers
  module Script
    BASENAME = 'remont'.freeze
    EXT = 'rake'.freeze

    # @param [String] script
    # @return [Object]
    def process(script)
      file = Tempfile.new([BASENAME, EXT])
      file.write(script)
      file.rewind

      Remont::Script.new(file.path).run!
    ensure
      file.close
      file.unlink
    end
  end
end
