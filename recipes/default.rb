execute "update package index" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end.run_action(:run)

package "openjdk-7-jre" do
  action :install
end

package "screen" do
  action :install
end

package "python-pip" do
  action :install
end

python_pip "tinys3" do
  action :install
end

username = node[:minecraft][:user]
home_dir = "/home/#{username}"

user username do
  action [:create]
end

directory home_dir do
  owner username
  mode 0700
end

directory "#{home_dir}/server" do
  owner username
  mode 0700
end

remote_file "#{home_dir}/server/minecraft_server.jar" do
  source "https://s3.amazonaws.com/Minecraft.Download/versions/1.8/minecraft_server.1.8.jar"
  mode 0700
end

file "#{home_dir}/server/eula.txt" do
    content "eula=true\n"
end

template "#{home_dir}/server/ops.txt" do
  owner username
  mode 0700
end

template "#{home_dir}/server/minecraft-s3.py" do
  owner username
  mode 0700
end

template "#{home_dir}/server/server.properties" do
  owner username
  mode 0700
  notifies :start, "minecraft_server[main]"
end

file "/root/.bashrc" do
  owner "root"
  content <<-EOH
  export S3_ACCESS_KEY=#{node[:s3][:access_key]}
  export S3_SECRET_KEY=#{node[:s3][:secret_key]}
  EOH
end

minecraft_server "main" do
  action [:start]
end

#iptables_rule "minecraft.rule"

