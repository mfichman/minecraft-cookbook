action :start do
  bash "start minecraft" do
    code <<-EOH
    set -e
    cd /home/#{node[:minecraft][:user]}/server
    export S3_ACCESS_KEY=#{node[:s3][:access_key]}
    export S3_SECRET_KEY=#{node[:s3][:secret_key]}
    killall screen java || true
    python minecraft-s3.py download #{node[:minecraft][:savename]} 
    screen -S minecraft -d -m java -Xmx1034M -Xms1024M -jar minecraft_server.jar nogui
    EOH
  end
end
