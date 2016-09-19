# We have our helpers here.
#

class Chef
  class CloudPassage
    # This class accepts variables pertinent to configuring the Halo agent.
    # The windows and linux configuration lines can be queried using
    # windows_configuration_variables and linux_configuration_variables,
    # respectively
    class ConfigHelper
      def initialize(opt)
        initialize_params(opt)
        @win_conf = WinConfig.new(opt)
        @lin_conf = LinConfig.new(opt)
      end

      def initialize_params(params)
        @config = params
      end

      def windows_installation_path
        [
          @config['windows_installer_protocol'], '://',
          @config['windows_installer_host'], ':',
          @config['windows_installer_port'],
          @config['windows_installer_path'], @config['windows_installer_file_name']
        ].join('')
      end

      def windows_configuration
        [
          '/S ',
          "/AGENT-KEY=#{@config['agent_key']}", @win_conf.grid,
          @win_conf.server_label,
          @win_conf.server_tag,
          @win_conf.read_only,
          @win_conf.proxy_host,
          @win_conf.proxy_user,
          @win_conf.proxy_pass,
          @win_conf.dns, ' /NOSTART'].join('')
      end

      def windows_reconfiguration
        [
          "/AGENT-KEY=#{@config['agent_key']}", @win_conf.grid,
          @win_conf.server_label,
          @win_conf.server_tag,
          @win_conf.read_only,
          @win_conf.proxy_host,
          @win_conf.proxy_user,
          @win_conf.proxy_pass,
          @win_conf.dns].join('')
      end

      def linux_configuration
        [
          "--agent-key=#{@config['agent_key']}", @lin_conf.grid,
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
      def initialize(opt)
        @config = {}
        initialize_params(opt)
      end

      def initialize_params(params)
        @config['grid_url'] = 'https://grid.cloudpassage.com/grid'
        @config['proxy_host'] = nil
        @config['proxy_port'] = nil
        @config['proxy_user'] = nil
        @config['proxy_password'] = nil
        @config['read_only'] = false
        @config['server_tag'] = nil
        @config['server_label'] = nil
        @config['dns'] = nil
        @config.merge!(params)
      end

      def grid
        " /grid=\"#{@config['grid_url']}\""
      end

      def dns
        # Build the DNS switch for the Windows configuration string
        if @config['dns'] == false
          dns_string = ' /DNS=false'
        elsif @config['dns'] == true
          dns_string = ' /DNS=true'
        end
        dns_string
      end

      def read_only
        # Build the read-only switch for the Windows configuration string
        if @config['read_only'] == false
          read_only_string = ' /read-only=false'
        elsif @config['read_only'] == true
          read_only_string = ' /read-only=true'
        end
        read_only_string
      end

      def server_label
        # Build the server label switch for the Windows configuration string
        if @config['server_label'].nil?
          server_label_string = ''
        else
          server_label_string = " /SERVER-LABEL=\"#{@config['server_label']}\""
        end
        server_label_string
      end

      def server_tag
        # Build the server tag switch for the Windows configuration string
        if @config['server_tag'].nil?
          server_tag_string = ''
        else
          server_tag_string = [' /TAG=', '"', @config['server_tag'], '"'].join('')
        end
        server_tag_string
      end

      def proxy_host
        if @config['proxy_host'].nil? && @config['proxy_port'].nil?
          proxy_host_portion = ''
        else
          proxy_host_portion = " /proxy=#{@config['proxy_host']}:#{@config['proxy_port']}"
        end
        proxy_host_portion
      end

      def proxy_user
        if @config['proxy_user'].nil?
          proxy_user_portion = ''
        else
          proxy_user_portion = " /proxy-user=\"#{@config['proxy_user']}\""
        end
        proxy_user_portion
      end

      def proxy_pass
        if @config['proxy_password'].nil? && @config['proxy_user'].nil?
          proxy_password_portion = ''
        else
          proxy_password_portion = " /proxy-password=\"#{@config['proxy_password']}\""
        end
        proxy_password_portion
      end
    end

    # This class contains functionality to build Linux-specific configuration
    # arguments
    class LinConfig
      def initialize(opt)
        @config = {}
        initialize_params(opt)
      end

      def initialize_params(params)
        @config['grid_url'] = 'https://grid.cloudpassage.com/grid'
        @config['proxy_host'] = nil
        @config['proxy_port'] = nil
        @config['proxy_user'] = nil
        @config['proxy_password'] = nil
        @config['read_only'] = false
        @config['server_tag'] = nil
        @config['server_label'] = nil
        @config['dns'] = nil
        @config.merge!(params)
      end

      def grid
        " --grid=\"#{@config['grid_url']}\""
      end

      def dns
        # Build the DNS switch for the Linux configuration string
        if @config['dns'] == false
          dns_string = ' --dns=false'
        elsif @config['dns'] == true
          dns_string = ' --dns=true'
        end
        dns_string
      end

      def read_only
        # Build the read-only switch for the Linux configuration string
        if @config['read_only'] == false
          read_only_string = ' --read-only=false'
        elsif @config['read_only'] == true
          read_only_string = ' --read-only=true'
        end
        read_only_string
      end

      def server_label
        # Build the server label switch for the Linux configuration string
        if @config['server_label'].nil?
          server_label_string = ''
        else
          server_label_string = " --server-label=\"#{@config['server_label']}\""
        end
        server_label_string
      end

      def server_tag
        # Build the server tag switch for the Windows configuration string
        if @config['server_tag'].nil?
          server_tag_string = ''
        else
          server_tag_string = [' --tag=', '"', @config['server_tag'], '"'].join('')
        end
        server_tag_string
      end

      def proxy_host
        if @config['proxy_host'].nil? && @config['proxy_port'].nil?
          proxy_host_portion = ''
        else
          proxy_host_portion = " --proxy=#{@config['proxy_host']}:#{@config['proxy_port']}"
        end
        proxy_host_portion
      end

      def proxy_user
        if @config['proxy_user'].nil?
          proxy_user_portion = ''
        else
          proxy_user_portion = " --proxy-user=\"#{@config['proxy_user']}\""
        end
        proxy_user_portion
      end

      def proxy_pass
        if @config['proxy_password'].nil? && @config['proxy_user'].nil?
          proxy_password_portion = ''
        else
          proxy_password_portion = " --proxy-password=\"#{@config['proxy_password']}\""
        end
        proxy_password_portion
      end
    end
  end
end
