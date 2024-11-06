# ANSIBLE:

## Connect VS Code to EC2 Control Node:
* Install Remote-SSH on VS-Code, 
* Change the permission of .pem file
    ```bash
        chmod 400 file.pem
    ```
* Configure the EC2 instance in .ssh/config:
    ```bash
        Host ansible-ec2-instance-control-node
            HostName ec2-15-207-88-94.ap-south-1.compute.amazonaws.com
            User ubuntu
            IdentityFile C:\Users\dibye\Downloads\file.pem
    ```
* Finally, connect to VS Code & EC2.

## Ansible config file location:
* ```bash
      /etc/ansible/ansible_config
      /etc/ansible/hosts # here inventory is present
  ```


## Passwordless Authentication:
* Step 1: Generate SSH
    ```bash
        ssh-keygen
    ```
* Step 2: Two way to connect:
    * Using Public SSH Key:
        ```bash
            ssh-copy-id -f "-o IdentityFile <PATH TO PEM FILE>" ubuntu@<INSTANCE-PUBLIC-IP>
        ```
        * Now connect (passwordless auth):
            ```bash
                ssh ubuntu<ip_address?>
            ```

    * Using Password:
        * Go to particular Managed Node(s).
            * got to files (/etc/ssh/sshd_config.d/60-cloudimg-settings.conf) and edit **PasswordAuthentication** as  **yes** 
                ```bash
                    sudo vim /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
                ```
            * go to another file (/etc/ssh/sshd_config) and edit **PubkeyAuthentication** as **yes**
                ```bash
                    sudo vim /etc/ssh/sshd_config
                ```
            * Restart the ssh
                ```bash
                    sudo systemctl restart ssh
                ```
            * Create a Password for ubuntu user:
                ```bash
                    sudo passwd ubuntu
                ```
            * logout from this instance
            * Now login or connect to instance by the command:
                ```bash
                    ssh-copy-id ubuntu@<ip_address>
                ```
                * provide the password
        * Now connect (passwordless auth):
            ```bash
                ssh ubuntu<ip_address>
            ```

## Inventory:
* create file inventory.ini:
* Store Manage nodes info:
    ```bash
        ubuntu@13.234.76.76
        ubuntu@43.204.115.191
    ```
* ping the both the server:
    ```bash
        ansible -i inventory_1.ini -m ping all
        # all, means all the servers
    ```
* install git **all** the servers:
    ```bash
        ansible -i inventory_1.ini -m shell -a "sudo apt install git" all
    ```
* Install git one server:
    ```bash
        ansible -i inventory_1.ini -m shell -a "sudo apt install git" ubuntu@43.204.115.191
    ```
* Install git/update server on **app** server (group server)
    ```bash
        ansible -i inventory_1.ini -m shell -a "sudo apt update -y" app
        ansible -i inventory_1.ini -m ping app
    ```

## AD HOC Commands:
* https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html
* Get the list of files from all the servers:
    ```bash
        ansible -i inventory_1.ini -m shell -a "sudo ls /etc/" all
    ```

## Playbook:
* **Ansible Playbook:** https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html
* **Ansible Module:** https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html#description
* Commnad to execute Playbook:
    ```bash
        ansible-playbook -i /path/inventory.ini first_playbook.yaml 
    ```

## Ansible Roles:
* create a role named **test**:
    ```bash
        ansible-galaxy role init test
    ```
* add tasks to the role **test/tasks**
    ```yaml
        ---
        # tasks file for test
        - name: Install apache httpd
        ansible.builtin.apt:
            name: apache2
            state: present
            update_cache: yes    
        - name: Copy file with owner and permissions
        ansible.builtin.copy:
            src: files/index.html
            dest: /var/www/html
            owner: root
            group: root
            mode: '0644'
    ```
* add **index.html** file to the role **test.files**
* update the playbook
    ```yaml
        ---
        - hosts: all
        become: true
        roles:
            - test
    ```
* Run the Commands:
    ```bash
        ansible-playbook -i inventory.ini playbook.yaml 
    ```