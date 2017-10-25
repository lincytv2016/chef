case node['platform']
when 'debian', 'ubuntu'
	execute "installing Datadog Agent on ubuntu" do
	command '"DD_API_KEY=31671308f852b47e8c80cab4dde17db0 bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)""'
	end
	execute "cp the process file" do
	command 'cp /etc/dd-agent/conf.d/process.yaml.example /etc/dd-agent/conf.d/process.yaml'
	end
	execute "restrting the seervice in redhat/centos" do
	command 'service dd-agent restart'
	end

when 'redhat', 'centos', 'fedora'
  	execute "installing Datadog Agent on redhat and centos" do
	command '"DD_API_KEY=31671308f852b47e8c80cab4dde17db0 bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)""'
	end
	execute "cp the process file" do
	command 'cp /etc/dd-agent/conf.d/process.yaml.example /etc/dd-agent/conf.d/process.yaml'
	end
	execute "restrting the seervice in redhat/centos" do
	command 'service dd-agent restart'
	end


when 'windows'
    remote_file "c:/windows/temp/ddagent-cli-latest.msi" do
    source "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli-latest.msi"
    end
    execute 'installing datadog agent' do
  	command 'msiexec /qn /i c:\windows\temp\ddagent-cli-latest.msi APIKEY="31671308f852b47e8c80cab4dde17db0"'
	end
   	  file 'C:\ProgramData\Datadog\conf.d\win32_event_log.yaml' do
	  content ::File.open('C:\ProgramData\Datadog\conf.d\win32_event_log.yaml.example').read
	  action :create
	  end
	  file 'C:\ProgramData\Datadog\conf.d\windows_service.yaml' do
	  content ::File.open('C:\ProgramData\Datadog\conf.d\windows_service.yaml.example').read
	  action :create
	  end
	  windows_service 'DataDogAgent' do
	  action :restart
	  end
end
