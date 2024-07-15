module Refer
  class Visit < ApplicationRecord
    belongs_to :referral_code, counter_cache: true

    normalizes :ip, with: ->{ Refer.mask_ip(_1) }

    def self.from_request(request)
      new(
        ip: request.ip,
        user_agent: request.user_agent,
        referrer: request.referrer,
        referring_domain: (URI.parse(request.referrer).try(:host) rescue nil)
      )
    end
  end
end
