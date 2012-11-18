class ZabbixApi
  class Host

    def initialize(options = {})
      @client = Client.new(options)
      @options = options
      @host_default_options = {
        :host => nil,
        :port => 10050,
        :status => 1,
        :useip => 1,
        :dns => '',
        :ip => '0.0.0.0',
        :proxy_hostid => 0,
        :groups => [],
        :useipmi => 0,
        :ipmi_ip => '',
        :ipmi_port => 623,
        :ipmi_authtype => 0,
        :ipmi_privilege => 0,
        :ipmi_username => '',
        :ipmi_password => ''
      }
    end

    def merge_params(params)
      result = JSON.generate(@host_default_options).to_s + "," + JSON.generate(params).to_s
      JSON.parse(result.gsub('},{', ','))
    end

    def create(data)
      result = @client.api_request(:method => "host.create", :params => [merge_params(data)])
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def add(data)
      create(data)
    end

    def delete(data)
      result = @client.api_request(:method => "host.delete", :params => [:hostid => data])
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def destroy(data)
      delete(data)
    end

    def update(data)
      result = @client.api_request(:method => "host.update", :params => data)
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def get_full_data(data)
      @client.api_request(:method => "host.get", :params => {:filter => data, :output => "extend"})
    end

    def get_id(data)
      result = get_full_data(data)
      result.empty? ? nil : result[0]['hostid'].to_i
    end

  end
end