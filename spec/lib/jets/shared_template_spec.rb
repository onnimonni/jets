require 'recursive-open-struct'

class ExampleTemplate < Jets::SharedTemplate
  # long form
  parameter(
    elb_port: {
      default: '80',
      type: "String",
      description: "desc...",
    }
  )
  # medium form
  parameter(:vpc_id,
    default: '80',
    type: "String",
    description: "desc...",
  )
  # medium form
  parameter(:ami_id, default: '80')
  # really short form
  parameter(:port, '80')

  # long form
  output(
    shared_resource_my_sns_topic: {
      description: 'desc..',
      value: "!Ref SharedResourceMySnsTopic"
    }
  )
  # medium form
  output(:shared_resource_my_sns_topic,
    description: 'desc..',
    value: "!Ref SharedResourceMySnsTopic"
  )
  # short form
  output(:my_sns_topic) # namescape to be added?
end

describe "shared template" do
  let(:template_class) do
    ExampleTemplate
  end

  it "shared_stack_arn" do
    # pp template_class.parameters
    pp template_class.outputs

    # scoped_resoures.each do |resource|
    #   add_resource(resource)
    #   add_outputs(resource.outputs)
    # end
  end
end