# frozen_string_literal: true
# source: https://github.com/rails/rails/blob/19eebf6d33dd15a0172e3ed2481bec57a89a2404/activesupport/lib/active_support/core_ext/hash/keys.rb#L103

class Hash
  def deep_symbolize_keys
    deep_transform_keys { |key| key.to_sym rescue key }
  end

  def deep_transform_keys(&block)
    _deep_transform_keys_in_object(self, &block)
  end

  def deep_stringify_keys
    deep_transform_keys(&:to_s)
  end

  private
    # Support methods for deep transforming nested hashes and arrays.
    def _deep_transform_keys_in_object(object, &block)
      case object
      when Hash
        object.each_with_object(self.class.new) do |(key, value), result|
          result[yield(key)] = _deep_transform_keys_in_object(value, &block)
        end
      when Array
        object.map { |e| _deep_transform_keys_in_object(e, &block) }
      else
        object
      end
    end
end