require "rbstruct/rbstruct"

def RbStruct(&block)
  c = Class.new(RbStruct::StructBase)
  c.class_eval &block if block_given?
  return c
end
