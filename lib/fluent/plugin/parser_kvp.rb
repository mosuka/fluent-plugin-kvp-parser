module Fluent
  class TextParser
    class KVPParser < Parser
      include Configurable
      include TypeConverter

      Plugin.register_parser('kvp', self)

      config_param :key_char, :string, :default => '\w.-'
      config_param :key_prefix, :string, :default => ''
      config_param :key_value_pair_delimiter, :string, :default => '\t\s'
      config_param :key_value_delimiter, :string, :default => '='
      config_param :time_key, :string, :default => 'time'

      def configure(conf={})
        super
        if @key_value_pair_delimiter[0] == '/' and @key_value_pair_delimiter[-1] == '/'
          @kv_delimiter = @key_value_pair_delimiter[1..-2]
        end

        @kv_regex_str = '(?:^|[' + @key_value_pair_delimiter + ']+)(?:(?:([' + @key_char + ']+)\s*[' + @key_value_delimiter + ']\s*("(?:(?:\\\.|[^"])*)"|(?:[^"' + @key_value_pair_delimiter + ']*)))(?:|[' + @key_value_pair_delimiter + ']*))'
        @kv_regex = Regexp.new(@kv_regex_str)
      end

      def parse(text)
        record = {}

        text.scan(@kv_regex) do | m |
          k = @key_prefix + m[0]
          v = (m[1][0] == '"' and m[1][-1] == '"') ? m[1][1..-2] : m[1]
          record[k] = v
        end

        convert_field_type!(record) if @type_converters
        time = record.delete(@time_key)
        if time.nil?
          time = Engine.now
        elsif time.respond_to?(:to_i)
          time = time.to_i
        else
          raise RuntimeError, "The #{@time_key}=#{time} is a bad time field"
        end

        yield time, record
      end

      private

      def convert_field_type!(record)
        @type_converters.each_key { |key|
          if value = record[key]
            record[key] = convert_type(key, value)
          end
        }
      end

    end
    register_template('kvp', Proc.new { KVPParser.new })
  end
end