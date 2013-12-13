module ParamsSanitizer::Sanitizers
  module ExistValue

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of exist_value.
    def sanitize_exist_value!(params, rules)
      rules.each do |key, rule|
        params[key] = params[key] || rule[:default_value]
      end
    end

    module SanitizerMethods
      # Define rule of exist_value
      #
      # @example
      #   exist_value(:keyword, '')
      #
      # @param key           [String] key of parameter.
      # @param default_value [Object] default values when input not exist value or nil.
      def exist_value(key, default_value, min = nil, max = nil)
        check_duplicated_definition!(key)
        definitions[:exist_value] ||= Hash.new
        definitions[:exist_value][key.to_s] = { default_value: default_value }
      end
    end

    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end
