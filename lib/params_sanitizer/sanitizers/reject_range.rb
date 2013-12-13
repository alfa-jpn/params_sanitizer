module ParamsSanitizer::Sanitizers
  module RejectRange

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of reject_range.
    def sanitize_reject_range!(params, rules)
      rules.each do |key, rule|
        if params.has_key?(key)
          params[key] = check_reject_range(params[key].to_i, rule[:default_value], rule[:min], rule[:max])
        else
          params[key] = rule[:default_value]
        end
      end
    end

    # Check whether a value is admitted range.
    # @note return a default value when value is not admitted range.
    #
    # @param value          [Object]  value
    # @param default_value  [Object]  default_value
    # @param min            [Integer] range of min.(when do not set a limit, nil)
    # @param max            [Integer] range of max.(when do not set a limit, nil)
    # @return [Object] value or default_value.
    def check_reject_range(value, default_value, min, max)
      if min and value < min
        value
      elsif max and value > max
        value
      else
        default_value
      end
    end

    module SanitizerMethods
      # Define rule of reject range.
      #
      # @example
      #   reject_range(:age, 100, 100, nil)  # max 100.
      #
      # @param key           [String]        key of parameter.
      # @param default_value [Object]        default values when input not addmitted value.
      # @param min            [Integer] range of min.(when do not set a limit, nil)
      # @param max            [Integer] range of max.(when do not set a limit, nil)
      def reject_range(key, default_value, min = nil, max = nil)
        check_duplicated_definition!(key)
        definitions[:reject_range] ||= Hash.new
        definitions[:reject_range][key.to_s] = { default_value: default_value, min: min, max: max }
      end
    end

    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end
