require 'serverspec'

if ENV['OS'] == 'Windows_NT'
  set :backend, :cmd
else
  set :backend, :exec
end

describe 'CloudPassage Halo agent for Linux' do
  if os[:family] != 'windows'
    it 'is installed' do
      expect(package('cphalo')).to be_installed
    end
    it 'is configured' do
      expect(file('/opt/cloudpassage/data/store.db')).to exist
    end
    it 'is running' do
      expect(service('cphalod')).to be_running
    end
  end
end

describe 'CloudPassage Halo agent for Windows' do
  if os[:family] == 'windows'
    progfiles = ENV['PROGRAMW6432']
    it 'is installed' do
      expect(package('CloudPassage Halo')).to be_installed
    end
    it 'is configured' do
      expect(file("#{progfiles}\\CloudPassage\\data\\store.db")).to exist
    end
    it 'is enabled' do
      expect(service('cphalo')).to be_enabled
    end
    it 'is running' do
      expect(service('cphalo')).to be_running
    end
  end
end
