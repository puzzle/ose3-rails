require 'erb'
require 'tilt'
require 'pp'
require 'pathname'

class Builder
  SOURCE_DIR = Pathname.new(__FILE__).parent.parent

  def run
    templates.each do |t|
      src_path = Pathname.new(t)
      dest_path = Pathname.new(destination_file(t))

      render(src_path, dest_path)

      if dockerfile?(dest_path)
        copy_context(src_path, dest_path.dirname)
      end
    end
  end

  private
  def render(in_path, out_path)
    puts [in_path, out_path].map{ |p| relative(p) }.join(' → ')

    FileUtils.mkdir_p(out_path.dirname)

    content = Renderer.new(in_path).render
    File.write(out_path, content)
  end

  def copy_context(src_file, dest_dir)
    deepest_first = DirectoryAncestry.new(src_file).directories
    shallowest_first = deepest_first.reverse
    context_paths = shallowest_first.map { |path| path.join('_context') }
    existing_contexts = context_paths.select { |path| path.exist? && path.directory? }

    existing_contexts.each do |path|
      puts "  adding context from #{relative(path)}"
      FileUtils.cp_r(Dir[path.to_s + '/*'], dest_dir)
    end
  end

  def relative(path)
    path.relative_path_from(SOURCE_DIR.parent)
  end

  def dockerfile?(path)
    path.basename.to_s == 'Dockerfile'
  end

  def templates
    # All erb files without partials.
    Dir.glob("#{SOURCE_DIR}/**/*.erb").map do |path|
      Pathname.new(path)
    end.reject{ |path| path.basename.to_s[0] == '_' }
  end

  # Where to render a template to.
  def destination_file(template)
    template.sub('/src/', '/dist/').sub(/\.erb$/, '')
  end

  # Renders an erb file. The file receives a PartialHelper p to render partials.
  class Renderer
    def initialize(path)
      @path = path
    end

    def render
      Tilt.new(@path).render(PartialHelper.new(@path))
    end
  end

  # Lists all parent directories of path up to (and not including)
  # the SOURCE_DIR.
  class DirectoryAncestry
    def initialize(path)
      @path ||= path
    end

    def directories(&block)
      ancestors = []
      directory = @path.dirname

      while directory != SOURCE_DIR
        ancestors << directory
        directory = directory.parent
      end

      ancestors
    end
  end

  # Finds partials in scope of a template and renders them
  class PartialHelper
    def initialize(path)
      @partials = find_partials(path)
    end

    def partial(name)
      partial_name = "_#{name}.erb"
      file = @partials.find{ |path| path.basename.to_s == partial_name }

      raise ArgumentError.new("No partial #{name.inspect} found") if file.nil?

      Renderer.new(file).render
    end

    private

    # Compiles a list of partials, ordered by visibility
    # (Closer ancestors with same name come first)
    def find_partials(template_path)
      DirectoryAncestry.new(template_path).directories.map do |path|
        partials_path = path.join('_partials')
        next unless partials_path.exist? && partials_path.directory?

        # Keep only .erb files that start with '_'
        partials_path.children.select(&:file?).select do |file|
          file.basename.to_s[0] == '_' && file.extname == '.erb'
        end
      end.compact.flatten
    end
  end
end
