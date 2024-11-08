## Create a Resource on EC2 instance:

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
                    ansible-vault create path/group_vars/all/pass.yml --vault-password-file vault.pass # create

                    ansible-vault edit path/group_vars/all/pass.yml --vault-password-file vault.pass # edit
                ```
            * After that tou add Access and Secrect key or others secrects in these valut.
    * Now Create resource on AWS:
        ```bash
            ansible-playbook -i inventory.ini path/ec2_creation.yaml --vault-password-file vault.pass
        ```
