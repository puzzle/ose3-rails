desc "Rebuild Dockerfiles and supporting files"
task :build do
  require_relative 'src/_build/builder.rb'

  builder = Builder.new
  builder.scrub_dist_dir(File.dirname(__FILE__) + '/dist')

  builder.run
end
