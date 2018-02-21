require_relative 'src/_build/builder.rb'

desc "Rebuild Dockerfiles and supporting files"
task :build do
  scrub_dist_dir

  puts "Building."
  Builder.new.run
end


def scrub_dist_dir
  dist_dir = File.dirname(__FILE__) + '/dist'
  raise "Where is the dist dir (not #{dist_dir} it seems)?" unless File.directory?(dist_dir)

  puts "Scrubbing dist dir."
  %x(rm -rf #{dist_dir})
  %x(mkdir #{dist_dir})
end
