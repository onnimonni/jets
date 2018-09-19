module Jets::Resource::CustomDomain
  class RestApi < Jets::Resource::Base
    extend Memoist
    include AwsServices

    def definition
      {
        rest_api: {
          type: "AWS::ApiGateway::CustomDomain",
          properties: {
            host_zone_id: hosted_zone_id,
            # domain: domain,
            # name: Jets::Naming.gateway_api_name,
            # binary_media_types: ['*/*'], # TODO: comment out, breaking form post
          }
        }
      }
    end

    def hosted_zone_id
      zone = hosted_zones.find do |z|
        z.domain == custom_domain
      end
      zone.hosted_zone_id
    end

    def hosted_zones
      zones, options, next_token = [], {}, true
      while next_token
        next_token = nil if next_token == true
        options[:next_token] = next_token if next_token
        resp = r53.list_hosted_zones(options)
        zones += resp.hosted_zones
        next_token = resp.next_token
      end
      zones
    end
    memoize :hosted_zones

    def custom_domain
      domain = Jets.config.custom_domain
      domain.ends_with?('.') ? domain : "#{domain}."
    end
  end
end
