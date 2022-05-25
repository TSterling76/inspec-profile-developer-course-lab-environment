# copyright: 2018, The Authors

control 'nginx-version' do
  impact 1.0
  title 'NGINX version'
  desc 'The required version of NGINX should be installed.'

  describe nginx do
    its('version') { should cmp >= input('nginx_version') }
  end
end


control 'nginx-modules' do
  impact 1.0
  title 'NGINX modules'
  desc 'The required NGINX modules should be installed.'
  ngm = input('nginx_modules')
  describe nginx do
    ngm.each do |current_module|
      its('modules') { should include current_module }
    #its('modules') { should include 'http_ssl'}
    #its('modules') { should include 'stream_ssl' }
    #its('modules') { should include 'mail_ssl' }
    end
  end
end

control 'nginx-conf' do
  impact 1.0
  title 'NGINX configuration'
  desc 'The NGINX config file should owned by root, be writable only by owner, and not writeable or and readable by others.'

  i_nginx_conf = input('nginx_conf')
  describe file(i_nginx_conf[:filename]) do
    it { should be_owned_by i_nginx_conf[:owngroup] }
    it { should be_grouped_into i_nginx_conf[:owngroup]}
    it { should_not be_readable.by(i_nginx_conf[:notallowed]) }
    it { should_not be_writable.by(i_nginx_conf[:notallowed]) }
    it { should_not be_executable.by(i_nginx_conf[:notallowed]) }
    it { should be_more_permissive_than(i_nginx_conf[:perms]) }
  end
end

