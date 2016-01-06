# We have our helpers here.
#

class Chef
  class CloudPassage
    # This class accepts variables pertinent to configuring the Halo agent.
    # The windows and linux configuration lines can be queried using
    # windows_configuration_variables and linux_configuration_variables,
    # respectively
    class ConfigHelper
      def initialize(agent_key, opt = {})
        @agent_key = agent_key
        initialize_params(opt)
        @win_conf = WinConfig.new(opt)
        @lin_conf = LinConfig.new(opt)
      end

      def initialize_params(params = {})
        params.each do |key, val|
          instance_variable_set("@#{key}", val) unless params.empty?
        end
      end

      def windows_installation_path
        [
          @windows_installer_protocol, '://',
          @windows_installer_host, ':',
          @windows_installer_port,
          @windows_installer_path, @windows_installer_file_name
        ].join('')
      end

      def windows_configuration
        [
          '/S ',
          "/AGENT-KEY=#{@agent_key}", @win_conf.grid,
          @win_conf.server_label,
          @win_conf.server_tag,
          @win_conf.read_only,
          @win_conf.proxy_host,
          @win_conf.proxy_user,
          @win_conf.proxy_pass,
          @win_conf.dns, ' /NOSTART'].join('')
      end

      def linux_configuration
        [
          "--agent-key=#{@agent_key}", @lin_conf.grid,
          @lin_conf.server_label,
          @lin_conf.server_tag,
          @lin_conf.read_only,
          @lin_conf.proxy_host,
          @lin_conf.proxy_user,
          @lin_conf.proxy_pass,
          @lin_conf.dns].join('')
      end
    end

    # This class contains functionality to build Windows-specific configuration
    # arguments
    class WinConfig
      def initialize(opt = {})
        initialize_params(opt)
      end

      def initialize_params(params = {})
        @grid_url = 'https://grid.cloudpassage.com/grid'
        @proxy_host = ''
        @proxy_port = ''
        @proxy_user = ''
        @proxy_password = ''
        @read_only = false
        @server_tag = ''
        @server_label = ''
        @dns = ''
        params.each { |key, val| instance_variable_set("@#{key}", val) }
      end

      def grid
        " /grid=\"#{@grid_url}\""
      end

      def dns
        # Build the DNS switch for the Windows configuration string
        if @dns == false
          dns_string = ' /DNS=false'
        elsif @dns == true
          dns_string = ' /DNS=true'
        end
        dns_string
      end

      def read_only
        # Build the read-only switch for the Windows configuration string
        if @read_only == false
          read_only_string = ' /read-only=false'
        elsif @read_only == true
          read_only_string = ' /read-only=true'
        end
        read_only_string
      end

      def server_label
        # Build the server label switch for the Windows configuration string
        if @server_label != ''
          server_label_string = " /SERVER-LABEL=\"#{@server_label}\""
        else
          server_label_string = ''
        end
        server_label_string
      end

      def server_tag
        # Build the server tag switch for the Windows configuration string
        if @server_tag != ''
          server_tag_string = [' /TAG=', '"', @server_tag, '"'].join('')
        else
          server_tag_string = ''
        end
        server_tag_string
      end

      def proxy_host
        if @proxy_host != '' && @proxy_port != ''
          proxy_host_portion = " /proxy=#{@proxy_host}:#{@proxy_port}"
        else
          proxy_host_portion = ''
        end
        proxy_host_portion
      end

      def proxy_user
        if @proxy_user != ''
          proxy_user_portion = " /proxy-user=\"#{@proxy_user}\""
        else
          proxy_user_portion = ''
        end
        proxy_user_portion
      end

      def proxy_pass
        if @proxy_password != '' && @proxy_user != ''
          proxy_password_portion = " /proxy-password=\"#{@proxy_password}\""
        else
          proxy_password_portion = ''
        end
        proxy_password_portion
      end
    end

    # This class contains functionality to build Linux-specific configuration
    # arguments
    class LinConfig
      def initialize(opt = {})
        initialize_params(opt)
      end

      def initialize_params(params = {})
        @grid_url = 'https://grid.cloudpassage.com/grid'
        @proxy_host = ''
        @proxy_port = ''
        @proxy_user = ''
        @proxy_password = ''
        @read_only = false
        @server_tag = ''
        @server_label = ''
        @dns = ''
        params.each { |key, val| instance_variable_set("@#{key}", val) }
      end

      def grid
        " --grid=\"#{@grid_url}\""
      end

      def dns
        # Build the DNS switch for the Linux configuration string
        if @dns == false
          dns_string = ' --dns=false'
        elsif @dns == true
          dns_string = ' --dns=true'
        end
        dns_string
      end

      def read_only
        # Build the read-only switch for the Linux configuration string
        if @read_only == false
          read_only_string = ' --readonly=false'
        elsif @read_only == true
          read_only_string = ' --readonly=true'
        end
        read_only_string
      end

      def server_label
        # Build the server label switch for the Linux configuration string
        if @server_label != ''
          server_label_string = " --server-label=\"#{@server_label}\""
        else
          server_label_string = ''
        end
        server_label_string
      end

      def server_tag
        # Build the server tag switch for the Windows configuration string
        if @server_tag != ''
          server_tag_string = [' --tag=', '"', @server_tag, '"'].join('')
        else
          server_tag_string = ''
        end
        server_tag_string
      end

      def proxy_host
        if @proxy_host != '' && @proxy_port != ''
          proxy_host_portion = " --proxy=#{@proxy_host}:#{@proxy_port}"
        else
          proxy_host_portion = ''
        end
        proxy_host_portion
      end

      def proxy_user
        if @proxy_user != ''
          proxy_user_portion = " --proxy-user=\"#{@proxy_user}\""
        else
          proxy_user_portion = ''
        end
        proxy_user_portion
      end

      def proxy_pass
        if @proxy_password != '' && @proxy_user != ''
          proxy_password_portion = " --proxy-password=\"#{@proxy_password}\""
        else
          proxy_password_portion = ''
        end
        proxy_password_portion
      end
    end
  end
end
