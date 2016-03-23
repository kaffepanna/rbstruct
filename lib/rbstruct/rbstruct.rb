module RbStruct

  TYPES = {
            :float	=> {:size => 4, :str => 'f'},
            :int		=> {:size => 4, :str => 'i'},
            :short  => {:size => 2, :str => 's'},
            :char		=> {:size => 1, :str => 'c'},
            :unsigned_char => {:size => 1, :str => "C"},
            :unsigned_short => {:size => 2, :str => "S"},
            :unsigned_int => {:size => 4, :str => "I"},
            :unsigned_long => {:size => 8, :str => "L_"},
            :uint8_t => {:size => 1, :str => "C" },
            :uint16_t => {:size => 2, :str => "S" },
            :uint32_t => {:size => 8, :str => "L" },
            :uint64_t => {:size => 16, :str => "Q" },
            :int8_t => {:size => 1, :str => "c" },
            :int16_t => {:size => 2, :str => "s" },
            :int32_t => {:size => 8, :str => "l" },
            :int64_t => {:size => 16, :str => "q" }
          }



  class StructBase < Array
    class << self; attr_reader :format_string, :fields, :bsize, :size end

    protected

    TYPES.each_key do |type|
      class_eval  %{
        def self.#{type}(name, size=1)
          field_add(:#{type}, name, size)
        end
      }
    end

    def self.field_add(type, name, length)
      @fields ||= Array.new
      @bsize  ||= 0
      @size   ||= 0
      @format_string ||= String.new

      #calculate offset in array
      f = @fields.last
        if f == nil
          offset = 0
        elsif f[:type].class == Symbol
          offset = f[:offset] + f[:length]
        else
          offset = f[:offset] + f[:type].size * f[:length]
        end


      @fields << { :name => name, :type => type,
                 :length => length, :offset => offset }
      if type.class == Symbol
        @size += length
        @bsize += TYPES[type][:size]*length
        @format_string += "#{TYPES[type][:str]}#{length}"
      else
        @size += length * type.size
        @bsize += type.bsize*length
        @format_string += "#{type.format_string}"*length
      end

      #create getter/setters
      class_eval %{
        def #{name}()
          get_field(#{@fields.size-1})
        end

        def #{name}=(val)
          set_field(#{@fields.size-1}, val)
        end
      }
    end

    def self.struct(type, name, size=1)
      self.field_add(type, name, size)
    end

    def get_field(index)
      type = self.class.fields[index][:type]
      length = self.class.fields[index][:length]
      offset = self.class.fields[index][:offset]

      if type.class == Symbol
        return self[offset] if length == 1
        return self[offset...offset+length].to_a
      else
        return type.new(self[offset...offset+type.size]) if length == 1
        return (0...length).collect {|i|
          type.new(self[offset+i*type.size...offset+(1+i)*type.size])
        }
      end
    end

    def set_field(index, val)
      type = self.class.fields[index][:type]
      length = self.class.fields[index][:length]
      offset = self.class.fields[index][:offset]
      if type.class == Symbol
        self[offset...offset+length] = val
      else
        self[offset...offset+length*type.size] = val
      end
    end

    public

    def to_s
      pack(self.class.format_string)
    end

    def self.read(f, n=1)
      format = self.format_string*n
      len = self.bsize*n
      array = f.read(len).unpack(format)
      return self.new(array) if n == 1
      return Array.new(n) { self.new(array.slice!(0, self.size)) }
    end

    def inspect(d=0)
      self.class.to_s + " {\n" +
      self.class.fields.each_with_index.map {|f,n|
        field = self.get_field(n)
        "\t"*(d+1) + "#{f[:type]} #{f[:name]} = " +
          case field
          when StructBase
            "#{field.inspect(d+1)}"
          else
            field.inspect
          end

      }.join("\n") +
      "\n" + "\t"*d + "}"
    end
  end
end

