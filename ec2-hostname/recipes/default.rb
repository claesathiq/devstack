
directory "/usr/local/ec2" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

template "/usr/local/ec2/ec2-hostname.sh" do
	source "ec2-hostname.sh.erb"
	owner "root"
	group "root"
	mode "0744"
	variables(
		domain => node['ec2-hostname']['domain']
	)
end

# Add "/usr/local/ec2/ec2-hostname.sh" to file "/etc/rc.local", BEFORE the line "exit 0"

