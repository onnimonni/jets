module Jets
  class SharedTemplate
    module Parameter
      def parameter(*definition)
        register_parameter(*definition)
      end

      def register_parameter(*definition)
        @parameters ||= []
        @parameters << definition
      end

      def parameters
        @parameters.map { |definition| standardize_parameter(definition) }
      end

      def standardize_parameter(args)
        if args.size == 1
          hash = args.first
          logical_id = hash.keys.first
          properties = hash.values.first
        else
          logical_id = args.first
          last = args.last
          if last.is_a?(Hash)
            properties = last
          else
            properties = {default: last}
          end
        end
        {
          logical_id => properties
        }
      end
    end
  end
end