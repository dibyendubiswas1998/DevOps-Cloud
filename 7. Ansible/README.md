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

## Error Handling:
* Suppose you have 3 different managed nodes and 4 different tasks in ansible.
    * If first task is failed all the managed nodes then reset of tasks are not executed.
    * If first task is failed in first managed node, then it might be all the tasks are executed rest of managed nodes.
* use **`ignore_errors:` `yes`**
    ```yaml
        ---
        - hosts: all
          become: true

          tasks:
            - name: Install security updates
              ansible.builtin.apt:
                name: "{{ item }}"
                state: latest
              loop:
                - openssl
                - openssh
              ignore_errors: yes 

            - name: Check if docker is installed
              ansible.builtin.command: docker --version
              register: output
              ignore_errors: yes    
            
            - ansible.builtin.debug:
                var: output
            
            - name: Install docker
              ansible.builtin.apt:
                name: docker.io
                state: present
              when: output.failed
    ```
* Execute the command:
    ```bash
        ansible-playbook -i inventory.ini playbook.yaml
    ```

## Ansible Vault:
* Command:
    ```bash
        ansible-vault
    ```
    * Vault Operations:
        * **create**          Create new vault encrypted file
        * **decrypt**         Decrypt vault encrypted file
        * **edit**            Edit vault encrypted file
        * **view**            View vault encrypted file
        * **encrypt**         Encrypt YAML file
        * **encrypt_string**  Encrypt a string
        * **rekey**           Re-key a vault encrypted file

* Setup Vault:
    * Create a Password for Vault
        ```bash
            openssl rand --base64 2048 > vault.pass
        ```
    * Create a Ansible-Vault
        ```bash
            ansible-vault create group_vars/all/pass.yml --vault-password-file vault.pass # create
            # Add the secrects in this Ansible vault

            ansible-vault edit group_vars/all/pass.yml --vault-password-file vault.pass # edit
            # Edit the secrects in these vault.

            # view the Secrects in this vault
            ansible-vault view group_vars/all/pass.yml --vault-password-file vault.pass
        ```
    * After that you add Access and Secrect key or others secrects in these valut.

* Suppose you have a secrects in **secrects.yaml** file, then how to encrypt, here are the process:
    * Create a **secrects.yaml** file and add the secrects.
    * Create a password for vault
        ```bash
            openssl rand --base64 2048 > vault.pass
        ```
    * Encrypy the secrect, **secrects.yaml**:
        ```bash
            ansible-vault encrypt secrects.yaml --vault-password-file vault.pass
        ```
    * Thats how you encrypts the existing file, which will be secure.
    * **Now** for decrypt the **secrects.yaml** file, you can use below command with password:
        ```bash
            ansible-vault decrypt secrects.yaml --vault-password-file vault.pass
        ```
* **Note:** Suppose you have 1000 different roles and playbooks, then it is not recommeded that you can use use different password (vault.pass) for each role and playbook. For that you can do, **dev** enviroment you can use one password (vault.pass), **staging** enviroment you can use another password (vault.pass) and for **production** enviroment you can use another password (vault.pass). Also you can store your secrects in different files.

## Plicy as Code:
Policy as Code (PaC) in DevSecOps refers to the practice of defining and managing security policies through code. This approach enables automated, consistent, and scalable enforcement of security controls and compliance requirements across the software development lifecycle.<Br>

* **Key Concepts of Policy as Code:**
    * **Codification of Policies:** Security policies, compliance requirements, and governance rules are written in code, similar to how infrastructure is defined in Infrastructure as Code (IaC). Policies are typically defined using declarative languages or scripts.
    * **Automation:** Policies are automatically enforced through CI/CD pipelines. Tools continuously monitor and ensure compliance with the defined policies.
    * **Version Control:** Policies as code are stored in version control systems (e.g., Git), allowing for versioning, auditing, and change tracking. This ensures that any changes to policies are transparent and traceable.
    * **Integration with DevOps Tools:** PaC integrates with DevOps tools and platforms, enabling seamless policy enforcement across development, testing, and production environments. Common integrations include CI/CD tools, configuration management tools, and cloud management platforms.

* **Benefits of Policy as Code:**
    * **Consistency and Accuracy:** Policies are applied consistently across environments, reducing the risk of human error. Automated checks and enforcement ensure that policies are adhered to accurately.
    * **Scalability:** PaC enables scalable policy enforcement across multiple environments and numerous resources. It supports the rapid deployment and scaling of applications while maintaining compliance.
    * **Auditability and Transparency:** Policies as code provide an auditable trail of policy definitions and changes. This transparency is crucial for compliance and regulatory requirements.
    * **Shift-Left Security:** By integrating security policies early in the development process, PaC promotes the shift-left security approach. It helps identify and remediate security issues early, reducing the cost and impact of security vulnerabilities.

* **Example Use Cases:**
    * **Infrastructure Security:** Ensure that cloud resources (e.g., AWS S3 buckets, IAM roles) comply with security best practices. Automatically remediate non-compliant resources.
    * **Application Security:** Enforce secure coding practices and compliance checks during the build and deployment stages. Prevent deployment of applications with known vulnerabilities.
    * **Compliance and Governance:** Implement regulatory compliance requirements (e.g., GDPR, HIPAA) as code. Continuously monitor and enforce compliance across the organization.