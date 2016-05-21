class Token
  def initialize(name)
    @name = name.to_sym
    @regexp = /(?:(#{Regexp.escape(@name)})[:|=]\s*)?(\S+)/
  end

  def ==(other)
    other.name == name && other.regexp == regexp
  end

  attr_reader :name, :regexp
end

class StaticToken < Token
  def initialize(string)
    @string = string.to_s.freeze
    @name = nil # not related to a parameter
    @regexp = /()(#{Regexp.escape(@string)})(?:\b|\s|\z)/i
  end

  def to_s
    @string
  end
  alias to_str to_s
end

class SplatToken < Token
  def initialize(*)
    super
    @regexp = /(?:(#{Regexp.escape(@name)})[:|=]\s*)?(.+?)\s*$/
  end
end

class NamedToken < Token
  NO_DEFAULT = Object.new

  def initialize(name, default = NO_DEFAULT)
    super(name)
    @default = default
    @regexp = /(?:(\S+)[:|=]\s*)?(\S*)/
  end

  def default
    @default unless @default == NO_DEFAULT
  end

  def ==(other)
    super && other.default == default
  end
end

class TokenBuilder
  def self.build(token)
    if token.start_with?(':')
      Token.new(token[1..-1])
    elsif token.start_with?('*')
      SplatToken.new(token[1..-1])
    elsif token.start_with?('[') && token.end_with?(']')
      NamedToken.new(*token[1..-2].split('=', 2))
    else
      StaticToken.new(token)
    end
  end
end
