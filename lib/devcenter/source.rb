module Devcenter
  class Source
    FUNCTIONS = %w{import}
    HIGHLIGHTS = {
      'erb'  => 'html',
      'ejs'  => 'html',
      'rb'   => 'ruby',
      'js'   => 'java_script',
      'term' => 'term',
      'clj'  => 'clojure',
      'py'   => 'python',
      'html' => 'html'
    }

    def initialize(source)
      @source = source
    end

    def to_s(root_dir = nil)
      @root_dir = root_dir
      @source.dup.tap do |output|
        FUNCTIONS.each do |f| 
          function_call = /( *)\!#{f}\(([^\)]+)\)/
          output.gsub!(function_call) do |token|
            matchdata = token.match(function_call)
            @indent = matchdata[1]
            send(f, *matchdata[2].split(','))
          end
        end
      end
    end

    ####
    private
    def import(filename, syntax = nil)
      filename = @root_dir + '/' + filename if @root_dir
      syntax ||= HIGHLIGHTS[File.extname(filename).gsub(".",'')]
      puts "importing #{filename} #{syntax && "with syntax: #{syntax}"}"

      source = syntax ? "#{@indent}:::#{syntax}\n" : ''
      source << File.read(filename).lines.map { |l| @indent.to_s + l }.join

      self.class.new(source).to_s(File.dirname(filename)) #recursion FTW
    end
  end
end
