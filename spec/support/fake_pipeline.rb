# frozen_string_literal: true

class FakePipeline
  # Interface
  def [](name)
    @files.find { |file| file.matching_name == name }
  end

  ### Test helpers ###

  def initialize
    @files = []
  end

  def add_asset(matching_name, path, content)
    @files << AssetFile.new(matching_name, path, content)
  end

  AssetFile = Struct.new(:matching_name, :pathname, :to_s)
  private_constant :AssetFile
end
