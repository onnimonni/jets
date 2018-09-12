module Jets
  class SharedTemplate
    autoload :Parameter, 'jets/shared_template/parameter'

    class << self
      include Parameter
    end
  end
end