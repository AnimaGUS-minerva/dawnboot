require 'net/http'

module DawnBoot
  class Configuration < ApplicationRecord
    has_many :system_variables

    class BadNightClerk < Exception; end

    def self.default
      self.where(:active => true).order("dawn_boot_configurations.lastused_at DESC").first
    end

    def self.create_first
      cf = create(:active => true,
             :name   => "initial",
             :lastused_at => DateTime::now)
      cf.save!
      cf
    end

    def self.finddefault
      default || create_first
    end

    def admin_email=(x)
      system_variables.setvalue(:admin_email, x)
    end
    def admin_email
      string(:admin_email)
    end

    def lookup(x)
      system_variables.lookup(x)
    end
   def string(x)
      system_variables.string(x)
    end

    def http_handler(url)
      # open code rather than use .start(), so that debug output can be set
      unless @http_handler
        @http_handler = Net::HTTP.new(url.host, url.port)
        #@http_handler.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @http_handler.use_ssl     = url.scheme == 'https'
        #@http_handler.cert        = FountainKeys.ca.jrc_pub_key
        #@http_handler.key         = FountainKeys.ca.jrc_priv_key
        @http_handler.set_debug_output($stderr) if ENV['HTTP_DEBUG']
      end
      @http_handler
    end

    def onboard!(url = lookup(:onboard_url))
      params = Hash.new
      params[:email] = admin_email

      url = URI(url)
      request = Net::HTTP::Post.new(url)
      body    = params.to_json
      request.content_type = "application/json"
      request.add_field("Accept", "application/json")

      begin
        response = http_handler(url).request(request, body)     # Net::HTTPResponse object

      rescue OpenSSL::SSL::SSLError
        logger.error "failed to negotiate with to #{url} due to #{$!}"
        raise BadNightClerk.new("TLS connection error: #{$!}")

      rescue SocketError
        logger.error "Failed to connect to #{url}"
        raise BadNightClerk.new("DNS or connection error: #{$!}")

      rescue
        logger.error "Error #{$!} was raised"
        raise $!
      end

      case response.code
      when "201"
        location = response.header[:location]
        logger.info "NightClerk at #{url} says #{response.message} #{location}"

        system_variables.setvalue(:enroll_activity, location)
      end

    end

  end
end
