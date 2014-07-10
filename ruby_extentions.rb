module ArrayExtentions
  def last=(element)
    self[-1] = element
  end
  def add_all(enum)
    for i in enum
      self << i
    end
    self
  end
end

module HashExtentions

  def with_symbolized_keys
    inject({}) do |new_hash, (key, value)|
      new_hash[key.to_sym] = value
      new_hash
    end
  end

end

module StringExtentions
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

module TrueFalseClassesExtentions
  def to_bool
    self
  end
end

class Array
  include ArrayExtentions
end

class Hash
  include HashExtentions
end

class String
  include StringExtentions
end

class TrueClass
  include TrueFalseClassesExtentions
end

class FalseClass
  include TrueFalseClassesExtentions
end

class StructBuilder < BasicObject
  def initialize
    @ostruct = ::OpenStruct.new
  end

  def method_missing(name, *args, &block)
    if name[-1] == "="
      message = name[0..-2]
    else
      message = name
    end
    @ostruct.__send__("#{message}=", args.first)
    return self
  end

  def struct
    @ostruct
  end
end

module Enumerable
  def map_by(symbol)
    map &symbol
  end

  # http://www.scala-lang.org/api/current/scala/collection/Iterable.html
  def flat_map(symbol = nil, &block)
    if block_given?
      ret = []
      self.each do |i|
        ret.add_all(block.call i)
      end
      return ret
    end
    flat_map(&symbol)

  end
end