
Vagrant.configure("2") do |config|

  # 1. Віртуальна машина для застосунку (APP_VM)
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/jammy64"
    app.vm.network "forwarded_port", guest: 8080, host: 8080

    app.vm.provider "virtualbox" do |vb|
      vb.name = "APP_VM"
      vb.memory = "2048"
      vb.cpus = 2
    end
  app.vm.provision "shell", path: "provision_app.sh", env: {
        "APP_USER" => "appuser",
        "PROJECT_DIR" => "/opt/petclinic-src",
        "APP_DIR" => "/home/appuser/app",
        "DB_HOST" => "192.168.56.10",
        "DB_NAME" => "petclinic",
        "DB_USER" => "petclinic_user",
        "DB_PASS" => "secretpassword"
      }
  end

  # 2. Віртуальна машина для бази даних (DB_VM)
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/jammy64"
    db.vm.network "private_network", ip: "192.168.56.10"

    db.vm.provider "virtualbox" do |vb|
      vb.name = "DB_VM"
      vb.memory = "1024"
      vb.cpus = 1
    end

    db.vm.provision "shell", path: "provision_db.sh", env: {
      "DB_NAME" => "petclinic",
      "DB_USER" => "petclinic_user",
      "DB_PASS" => "secretpassword"
    }
  end

end
