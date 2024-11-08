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

## Ansible Galaxy:
* **Ansible Role Action:**
    ```bash
        ansible-galaxy -h # Perform various Role and Collection related operations
        # Get the role action info
        ansible-galaxy role -h
    ```
    * **init**       Initialize new role with the base structure of a role.
    * **remove**     Delete roles from roles_path.
    * **delete**     Removes the role from Galaxy. It does not remove or alter the actual GitHub repository.
    * **list**       Show the name and version of each role installed in the roles_path.
    * **search**     Search the Galaxy database by tags, platforms, author and multiple keywords.
    * **import**     Import a role into a galaxy server
    * **setup**      Manage the integration between Galaxy and the given source.
    * **info**       View more details about a specific role.
    * **install**    Install role(s) from file(s), URL(s) or Ansible Galaxy

* Install a roles from Ansible Galaxy:
    * Install docker role:
        ```bash
            ansible-galaxy role install bsmeding.docker
        ```
    * Find the roles path:
        ```bash
            ls ~/.ansible/roles/
            # bsmeding.docker
        ```
    * Creat a **docker_playbook.yaml** and mention the specific role:
        ```yaml
            ---
            - hosts: all
            become: true
            roles:
                - bsmeding.docker
        ```
    * Run the playbook:
        ```bash
            ansible-playbook -i inventory.ini docker_playbook.yaml
        ```
* Push your custom role into Ansible Galaxy:
    * Push all the role related stuff to GitHub
    * Come to CMD or terminal of Control Node:
        * Execute the command:
            ```bash
                ansible-galaxy import <github-user-name> <github-repo-name> --token <ansible-api-token>
            ```

## Ansible Collection:
* Install AWS Collection:
    ```bash
        ansible-galaxy collecction install amazon.aws
        ansible-galaxy collection install amazon.aws --force # install latest version
        pip install boto3 # you nedd to install some packages  also
        sudo pip3 install boto3 --break-system-packages
    ```
* Create Resources on AWS:
    * Write **ec2_creation.yaml** file
        ```yaml
            --- 
            - hosts: localhost # localhost means, in your control node
            connection: local # this tells ansible that playbook has to be execute on same machine (local)
            tasks:
            - name: start an instance with a public IP address
                amazon.aws.ec2_instance:
                name: "ansible-managed-node-instance"
                # key_name: "prod-ssh-key"
                # vpc_subnet_id: subnet-013744e41e8088axx
                instance_type: t2.micro
                security_group: default
                region: us-east-1
                aws_access_key: "{{ec2_access_key}}"  # From vault as defined
                aws_secret_key: "{{ec2_secret_key}}"  # From vault as defined      
                network:
                    assign_public_ip: true
                image_id: ami-04b70fa74e45c3917
                tags:
                    Environment: Testing
        ```
    * Or, create a custom role for creation of ec2:
        ```bash
            ansible-galaxy role init ec2
        ```
        * Mention the tasks, and mention the role in ec2_creation.yaml file
            ```yaml
                ---
                # tasks file for ec2
                - name: start an instance with a public IP address
                    amazon.aws.ec2_instance:
                        name: "ansible-managed-node-instance"
                        # key_name: "prod-ssh-key"
                        # vpc_subnet_id: subnet-013744e41e8088axx
                        instance_type: t2.micro
                        security_group: default
                        region: us-east-1
                        aws_access_key: "{{ec2_access_key}}"  # From vault as defined
                        aws_secret_key: "{{ec2_secret_key}}"  # From vault as defined      
                        network:
                            assign_public_ip: true
                        image_id: ami-04b70fa74e45c3917
                        tags:
                            Environment: Testing
            ```
    * Add AWS Secrect and Access Key in Ansible Vault:
        * Setup Vault:
            * Create a Password for Vault
                ```bash
                    openssl rand --base64 2048 > vault.pass
                ```
            * Create a Ansible-Vault
                ```bash
                    ansible-vault create group_vars/all/pass.yml --vault-password-file vault.pass # create

                    ansible-vault edit group_vars/all/pass.yml --vault-password-file vault.pass # edit
                ```
            * After that tou add Access and Secrect key or others secrects in these valut.
    * Now Create resource on AWS:
        ```bash
            ansible-playbook -i inventory.ini ec2_creation/ec2_creation.yaml --vault-password-file vault.pass
        ```

## Ansible Varibales:
* tasks in role:
    ```yaml
        # tasks file for ec2
        - name: start an instance with a public IP address
            amazon.aws.ec2_instance:
                name: "ansible-managed-node-instance"
                # key_name: "prod-ssh-key"
                # vpc_subnet_id: subnet-013744e41e8088axx
                instance_type: "{{ type }}" # pass the vars using jinja2 template
                security_group: default
                region: us-east-1
                aws_access_key: "{{ec2_access_key}}"  # From vault as defined
                aws_secret_key: "{{ec2_secret_key}}"  # From vault as defined      
                network:
                    assign_public_ip: true
                image_id: ami-04b70fa74e45c3917
                tags:
                    Environment: Testing
    ```
* Store or write variables in **vars** (heighest priority) or any 22 places:
    * https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html
* Dynamically pass the extra variables:
    ```bash
        ansible-playbook -i inventory.ini ec2_creation/ec2_creation.yaml --vault-password-file vault.pass -e type=t2.micro
        # here extra vars has heighest priority.
        # default (in role) has lowest priority
    ```
* You can define the variables in **tasks** for every play like (best practice):
    ```yaml
        # tasks file for ec2
        - name: start an instance with a public IP address
            vars:
                type: t2.micro
            amazon.aws.ec2_instance:
                name: "ansible-managed-node-instance"
                # key_name: "prod-ssh-key"
                # vpc_subnet_id: subnet-013744e41e8088axx
                instance_type: "{{ type }}" # pass the vars using jinja2 template
                security_group: default
                region: us-east-1
                aws_access_key: "{{ec2_access_key}}"  # From vault as defined
                aws_secret_key: "{{ec2_secret_key}}"  # From vault as defined      
                network:
                    assign_public_ip: true
                image_id: ami-04b70fa74e45c3917
                tags:
                    Environment: Testing
        
        # Another Play
        - name: start an instance with a public IP address
            vars:
                type: t2.xlarge
            amazon.aws.ec2_instance:
                name: "ansible-managed-node-instance"
                # key_name: "prod-ssh-key"
                # vpc_subnet_id: subnet-013744e41e8088axx
                instance_type: "{{ type }}" # pass the vars using jinja2 template
                security_group: default
                region: us-east-1
                aws_access_key: "{{ec2_access_key}}"  # From vault as defined
                aws_secret_key: "{{ec2_secret_key}}"  # From vault as defined      
                network:
                    assign_public_ip: true
                image_id: ami-04b70fa74e45c3917
                tags:
                    Environment: Testing
    ```
* Another oone is Create vars in **group_vars/all/** directory:
    * for app hosts, create **group_vars/all/app.yaml**
    * for db hosts, create **group_vars/all/db.yaml**