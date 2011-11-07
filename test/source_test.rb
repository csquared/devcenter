require File.expand_path('../../lib/devcenter', __FILE__)
require 'test/unit'
require 'fakefs'

class String
  def strim
    self.gsub(/^ +\|/,' ')
  end
end

class SourceTest < Test::Unit::TestCase
  def setup
    FileUtils.mkdir("files")
    FileUtils.mkdir("files/nested")
    File.open("files/import.text", "w") do |f| 
      f << "test\n    !import(nested/import.rb)" 
    end
    File.open("files/nested/import.rb", "w") { |f| f << "puts 'hello'" }
  end

  def test_import_with_nesting
    source = <<-SOURCE.strim
    |## This is some markdown
    |
    |!import(files/import.text)
    SOURCE

    target = <<-SOURCE.strim
    |## This is some markdown
    |
    |test
    |    :::ruby
    |    puts 'hello'
    SOURCE

    assert_equal Devcenter::Source.new(source).to_s, target
  end
end
