require 'chefspec'

describe 'cloudpassage-halo' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'Installs CloudPassage Halo on Debian' do
    chef_run.node.set['platform_family'] = 'debian'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('cphalo')
  end

  it 'Installs CloudPassage Halo on RedHat' do
    chef_run.node.set['platform_family'] = 'rhel'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('cphalo')
  end

  it 'Installs CloudPassage Halo on Windows' do
    chef_run.node.set['platform_family'] = 'windows'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('cphalo')
  end

  it 'Upgrades CloudPassage Halo on Debian' do
    chef_run.node.set['platform_family'] = 'debian'
    chef_run.converge(described_recipe)
    expect(chef_run).to upgrade_package('cphalo').with(version: '1.0')
  end

  it 'Upgrades CloudPassage Halo on RedHat' do
    chef_run.node.set['platform_family'] = 'rhel'
    chef_run.converge(described_recipe)
    expect(chef_run).to upgrade_package('cphalo').with(version: '1.0')
  end

  it 'Upgrades CloudPassage Halo on Windows' do
    chef_run.node.set['platform_family'] = 'windows'
    chef_run.converge(described_recipe)
    expect(chef_run).to upgrade_package('CloudPassage Halo')
      .with(version: '1.0')
  end


  it 'Does nothing if installed and running, with no available upgrade' do
    chef_run.node.set['platform_family'] = 'debian'
    chef_run.converge(described_recipe)

  end

  it 'Does not configure CloudPassage Halo if the store.db file exists' do
    # Mock up the store.db file
    allow(File).to receive(:exist?)
      .and_call_original
    allow(File).to receive(:exist?)
      .with('/opt/cloudpassage/data/store.db')
      .and_return(true)
    # Mock up the environment
    chef_run.node.set['platform_family'] = 'debian'

  end

end
