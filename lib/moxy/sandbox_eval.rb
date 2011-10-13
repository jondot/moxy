require 'fakefs/safe'

module Moxy
  class SandboxEval
    def initialize(verbose=false)
      @verbose = verbose
    end
    def setup_code
      "include WebMock::API"
    end

    def evaluate(unsafe_code)
      # run something

      begin
        FakeFS.activate!
        cmd = <<-EOF
        #{setup_code}
        FakeFS::FileSystem.clear
        $SAFE = 3
        $stdout = StringIO.new
        begin
          #{unsafe_code}
        end
        EOF
        puts "evaling:\n-------->>\n#{cmd}\n-------->>" if @verbose

        stdout_id = $stdout.to_i
        $stdout = StringIO.new

        result = Thread.new { eval cmd, TOPLEVEL_BINDING }.value
        [:ok, result]
      rescue SecurityError => e
        return [:illegal, e]
      rescue Exception => e
        return [:error, e]
      ensure
        $stdout = IO.new(stdout_id)
        FakeFS.deactivate!
      end
    end

  
  end
end
