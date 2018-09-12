module Jets
  class SharedTemplate
    module Output
      def output(*definition)
        register_output(*definition)
      end

      def register_output(*definition)
        @outputs ||= []
        @outputs << definition
      end

      def outputs
        @outputs.map { |definition| standardize_output(definition) }
      end

      def standardize_output(args)
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