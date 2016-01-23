describe Chef::CloudPassage::ConfigHelper do
  config = YAML.load_file(
    File.join(
      File.dirname(
        File.expand_path(__FILE__)), '../test/fixtures/unit_config.yaml'))
  describe '#initialize' do
    before :each do
      bag = {}
      ebag = {}
      xmas = {
        'grid_url' => config['grid_url'], 'proxy_host' => config['proxy_host'], 'proxy_port' => config['proxy_port'],
        'read_only' => config['read_only'], 'server_tag' => config['server_tag'],
        'server_label' => config['server_label'], 'proxy_user' => config['proxy_user'],
        'proxy_password' => config['proxy_password'], 'agent_key' => config['agent_key'] }
      bare = {
        'agent_key' => config['agent_key'], 'grid_url' => config['grid_url'],
        'windows_installer_protocol' => config['windows_installer_protocol'],
        'windows_installer_host' => config['windows_installer_host'],
        'windows_installer_port' => config['windows_installer_port'],
        'windows_installer_path' => config['windows_installer_path'],
        'windows_installer_file_name' => config['windows_installer_file_name'] }
      @xmas_helper = Chef::CloudPassage::ConfigHelper.new(base_config: xmas,
                                                          databag_config: bag, encrypted_databag_config: ebag)
      @bare_helper = Chef::CloudPassage::ConfigHelper.new(base_config: bare,
                                                          databag_config: bag, encrypted_databag_config: ebag)
    end

    it 'Bare takes one param' do
      expect(@bare_helper).to(
        be_an_instance_of Chef::CloudPassage::ConfigHelper)
    end

    it 'Xmas takes a bunch of params' do
      expect(@xmas_helper).to(
        be_an_instance_of Chef::CloudPassage::ConfigHelper)
    end

    it 'Produces Windows config line for xmas' do
      expect(@xmas_helper.windows_configuration).to(
        eql config['win_xmas_tree_config'])
    end

    it 'Produces bare Windows config line' do
      expect(@bare_helper.windows_configuration).to(
        eql config['win_bare_config'])
    end

    it 'Produces valid windows installation path' do
      expect(@bare_helper.windows_installation_path).to(
        eql config['win_full_install_path'])
    end

    it 'Produces valid linux bare config line' do
      expect(@bare_helper.linux_configuration).to(
        eql config['lin_bare_config'])
    end

    it 'Produces valid linux xmas config line' do
      expect(@xmas_helper.linux_configuration).to(
        eql config['lin_xmas_tree_config'])
    end
  end
end
