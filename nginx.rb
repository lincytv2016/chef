# ubuntu 
# 
# installing 
package 'nginx' do
end

service 'nginx' do
action [:restart, :enable]
end

file '/var/www/html/index2.html' do
	content 'Hello World'
	mode '0755'
	owner 'root'
	group 'www-data'
end

execute 'command-test' do
	command 'echo hello >> /var/www/html/index.html'
	only_if 'test -r /var/www/html/index.html'
end
