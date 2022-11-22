require 'spec_helper'

describe package('git') do
  it { should be_installed }
end
describe package('make') do
  it { should be_installed }
end
describe package('patch') do
  it { should be_installed }
end
describe package('rsync') do
  it { should be_installed }
end

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe package('mariadb-server') do
  it { should be_installed }
end
describe service('mariadb') do
  it { should be_enabled }
  it { should be_running }
end
describe port(3306) do
  it { should be_listening }
end
describe package('postgresql-server') do
  it { should be_installed }
end
describe service('postgresql') do
  it { should be_enabled }
  it { should be_running }
end
describe port(5432) do
  it { should be_listening }
end

describe package('php') do
  it { should be_installed }
end
describe service('php-fpm') do
  it { should be_enabled }
  it { should be_running }
end
describe 'PHP config parameters' do
  context php_config('memory_limit') do
    its(:value) { should eq '384M' }
  end
  context php_config('post_max_size') do
    its(:value) { should eq '50M' }
  end
  context php_config('upload_max_filesize') do
    its(:value) { should eq '50M' }
  end
  context php_config('expose_php') do
    its(:value) { should eq '' }
  end
end

describe package('certbot') do
  it { should be_installed }
end

describe file('/etc/cron.weekly/certbot_renew') do
  it { should be_file }
  it { should be_executable }
  it { should contain 'certbot renew' }
end

describe file('/etc/httpd/conf.d/dirs.conf') do
  it { should be_file }
  it { should contain 'Timeout 600' }
  it { should contain 'DirectoryMatch \\.git' }
  it { should contain 'FilesMatch \\.env' }
end

describe file('/usr/bin/composer') do
  it { should be_file }
  it { should be_executable }
end

describe package('libssh2') do
  it { should be_installed }
end
describe package('libssh2-devel') do
  it { should be_installed }
end

describe file('/var/www/.ssh') do
  it { should be_directory }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
  it { should be_mode 700 }
end
describe file('/var/www/.ssh/id_rsa') do
  it { should be_file }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
  it { should be_mode 600 }
end
describe file('/var/www/.ssh/id_rsa.pub') do
  it { should be_file }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
  it { should be_mode 644 }
end
describe file('/usr/share/httpd/.ssh') do
  it { should be_directory }
  it { should be_owned_by 'apache' }
  it { should be_grouped_into 'apache' }
  it { should be_mode 700 }
end
describe file('/usr/share/httpd/.ssh/known_hosts') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 444 }
end
