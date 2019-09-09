require 'yaml'

class Parser
  def self.call(*args)
    new(*args).call
  end

  def initialize(file_path = __dir__+'/config.yml')
    @file_path = file_path
  end

  def call
    [].tap do |code|
      code << "set_state '#{config['default_view']}'"
      code << views_functions
      code << define_views_functions
      code << main_function
    end.join("\n\n")
  end

  private

  attr_reader :file_path

  def create_key_pattern(key, value)
    command = value['view'] ? "#{value['view']}_view" : value['command']

    "\tcreate_key #{key} '#{value['text']}' '#{command}'".tap do |code|
      code << " '-s'" if value['command']
    end if (1..12).include?(key)
  end

  def function_pattern(view, commands, back = nil)
    [].tap do |code|
      code << "function #{view}_view() {"
      code << "\tremove_and_unbind_keys\n"
      code << "\tset_state '#{view}'\n"
      code << commands.join("\n")
      code << "\n\tset_state '#{back}'" if back
      code << "}"

    end.join("\n")
  end

  def views_functions
    config['views'].map do |view, keys|
      commands = keys.map { |k, v| create_key_pattern(k, v) }.compact

      function_pattern(view, commands, keys['back'])
    end.join("\n\n")
  end

  def define_views_functions
    config['views'].keys.map do |view|
      "zle -N #{view}_view"
    end.join("\n")
  end

  def main_function
    [].tap do |code|
      code << 'precmd_apple_touchbar() {'
      code << "\tcase $state in"
      code << config['views'].keys.map { |view| "\t\t#{view}) #{view}_view ;;"}.join("\n")
      code << "\tesac"
      code << '}'
    end.join("\n")
  end

  def config
    @config ||= YAML.load(File.read(file_path))
  end
end

File.open(__dir__+'/touchbar-mappings.zsh', 'w') {|f| f.write(Parser.call) }
