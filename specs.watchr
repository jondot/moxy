# Run me with:
#   $ watchr specs.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch( '^spec.*/.*_spec\.rb'                 )  { |m| ruby tests }
watch( '^lib/(.*)\.rb'                       )  { |m| ruby tests }
watch( '^spec/helper\.rb'               )  { ruby tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
Signal.trap('QUIT') { ruby tests  } # Ctrl-\
Signal.trap('INT' ) { abort("\n") } # Ctrl-C

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ruby(*paths)
  run "ruby #{gem_opt} -I.:lib:spec -e'%w( #{paths.flatten.join(' ')} ).each {|p| require p }'"
end

def tests
  Dir['spec/**/*_spec.rb'] - ['spec/helper.rb']
end

def run( cmd )
  puts   cmd
  system cmd
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end
puts 'watching...'
