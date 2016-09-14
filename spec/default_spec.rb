require 'chefspec'
require 'chefspec/berkshelf'

ENV['PROGRAMW6432'] = 'C:\Program Files'
describe 'cloudpassage' do
  test_platforms = [['debian', '7.0', 'cphalod', 'cphalo'],
                    ['redhat', '6.0', 'cphalod', 'cphalo'],
                    ['redhat', '6.5', 'cphalod', 'cphalo'],
                    ['redhat', '7.0', 'cphalod', 'cphalo'],
                    ['windows', '2008R2', 'CloudPassage Halo Agent',
                     'CloudPassage Halo'],
                    ['windows', '2012', 'CloudPassage Halo Agent',
                     'CloudPassage Halo'],
                    ['windows', '2012R2', 'CloudPassage Halo Agent',
                     'CloudPassage Halo']]
  test_platforms.each do |platform, version, process, package|
    describe "for #{platform} #{version}. #{process}." do
      context 'Halo is not already configured.' do
        before(:all) do
          @chef_run = ChefSpec::ServerRunner.new(platform: "#{platform}",
                                                 version: "#{version}",
                                                 step_into: ['cloudpassage_agent'])
          @chef_run.converge(described_recipe)
        end
        it 'Sets up repo for Debian Linux.' do
          if platform == 'debian'
            expect(@chef_run).to add_apt_repository('cloudpassage')
          end
        end
        it 'Sets up repo for CentOS Linux.' do
          if platform == 'centos'
            expect(@chef_run).to add_yum_repository('cloudpassage')
          end
        end
        it 'Installs CloudPassage Halo.' do
          if platform != 'windows'
            expect(@chef_run).to upgrade_package(package)
          else
            expect(@chef_run).to install_windows_package(package)
          end
        end
        it 'Configures CloudPassage Halo.' do
          if platform != 'windows'
            expect(@chef_run).to run_execute('cphalo-config')
          end
        end
      end

      context 'Halo is already configured.' do
        before(:all) do
          @chef_run = ChefSpec::SoloRunner.new(platform: "#{platform}",
                                               version: "#{version}",
                                               step_into: ['cloudpassage_agent'])
          @chef_run.converge(described_recipe)
        end
        it 'Skips configuration if store.db exists.' do
          allow(File)
            .to receive(:exist?)
            .and_call_original
          allow(File)
            .to receive(:exist?)
            .with('C:\Program Files\CloudPassage\data\store.db')
            .and_return(true)
          allow(File)
            .to receive(:exist?)
            .with('/opt/cloudpassage/data/store.db')
            .and_return(true)
          @chef_run.converge(described_recipe)
          if platform != 'windows'
            expect(@chef_run).not_to run_execute('cphalo-config')
          end
          if platform == 'windows'
            expect(@chef_run)
              .to install_windows_package('CloudPassage Halo')
              .with(options: '/S')
          end
        end
      end

      context 'Halo repository links in attributes file are empty.' do
        before(:all) do
          @chef_run = ChefSpec::SoloRunner.new(step_into: ['cloudpassage_agent'])
          @chef_run.node.default['platform'] = "#{platform}"
          @chef_run.node.default['version'] = "#{version}"
          @chef_run.node.set['cloudpassage']['apt_repo_url'] = nil
          @chef_run.node.set['cloudpassage']['yum_repo_url'] = nil
          @chef_run.converge(described_recipe)
        end
        it 'Skips configuration of apt repo if repo link is empty.' do
          if platform == 'debian'
            expect(@chef_run).not_to add_apt_repository('cloudpassage')
          end
        end
        it 'Skips configuration of yum repo if repo link is empty' do
          if platform == 'centos'
            expect(@chef_run).not_to add_yum_repository('cloudpassage')
          end
        end
      end

      context 'Encrypted data bag is used for sensitive information.' do
        before(:all) do
          @chef_run = ChefSpec::SoloRunner.new(platform: "#{platform}",
                                               version: "#{version}",
                                               step_into: ['cloudpassage_agent'])
          @chef_run.converge(described_recipe)
        end
        it 'Uses secrets from databag.' do
          allow(Chef::EncryptedDataBagItem)
            .to receive(:load).with('credentials', 'halo')
            .and_return(
              'agent_key' => 'databag_secret_agent_key',
              'proxy_user' => 'databag_secret_proxy_user',
              'proxy_password' => 'databag_secret_proxy_password')
          @chef_run.converge(described_recipe)
          if platform != 'windows'
            expect(@chef_run)
              .to run_execute('cphalo-config')
              .with(command: /.*configure.*databag.*databag.*databag.*/)
          end
          if platform == 'windows'
            expect(@chef_run)
              .to install_windows_package('CloudPassage Halo')
              .with(options: /.*AGENT-KEY.*databag.*databag.*databag.*/)
          end
        end
      end

      context 'Data bag is used for sensitive information.' do
        before(:all) do
          @chef_run = ChefSpec::SoloRunner.new(platform: "#{platform}",
                                               version: "#{version}",
                                               step_into: ['cloudpassage_agent'])
          @chef_run.converge(described_recipe)
        end
        it 'Uses secrets from databag.' do
          stub_data_bag('cloudpassage')
            .and_return(
              'agent_key' => 'data_bag_agent_key',
              'proxy_user' => 'data_bag_proxy_user',
              'proxy_password' => 'data_bag_proxy_password')
          @chef_run.converge(described_recipe)
          if platform != 'windows'
            expect(@chef_run)
              .to run_execute('cphalo-config')
              .with(command: /.*configure.*data_bag.*data_bag.*data_bag.*/)
          end
          if platform == 'windows'
            expect(@chef_run)
              .to install_windows_package('CloudPassage Halo')
              .with(options: /.*AGENT-KEY.*data_bag.*data_bag.*data_bag.*/)
          end
        end
      end
    end
  end
end
