# Project:
## Tasks:
### Task 1
Create three(3) EC2 instances on AWS using Ansible loops
* 2 Instances with Ubuntu Distribution
* 1 Instance with Centos Distribution
Hint: **`Use connection: local`** on Ansible Control node.

### Task 2
Set up passwordless authentication between Ansible control node and newly created instances.

### Task 3
Automate the shutdown of Ubuntu Instances only using Ansible Conditionals

**Hint:** Use when condition on ansible **`gather_facts`**


## Solution:
### For Task 1:
* Create an IAM user: 
    * Provide the Atach Policies.
    * Generate the Access key and Secrect Key.

* Steup the Vault for storing Secrects
    ```bash
        openssl rand --base64 2048 > vault.pass
        ansible-vault create group_vars/all/pass.yml --vault-password-file vault.pass
    ```
* Create a role named **project1**:
    * Add the tasks:
        ```yaml
            ---
            # tasks file for project1

            - name: Create EC2 Instance
            vars:
                type: t2.micro
            amazon.aws.ec2_instance:
                name: "{{ item.name }}"
                key_name: "ansible-project-1" # provide key-pair from ec2
                # vpc_subnet_id: subnet-013744e41e8088axx
                instance_type: "{{ type }}"
                security_group: default
                region: ap-south-1
                aws_access_key: "{{aws_access_key}}"  # From vault as defined
                aws_secret_key: "{{aws_secrect_key}}"  # From vault as defined      
                network:
                    assign_public_ip: true
                image_id: "{{ item.image }}"
            loop:
                - {image: "ami-0dee22c13ea7a9a67", name: ec2-instance-ubuntu-1} # Ubuntu
                - {image: "ami-0dee22c13ea7a9a67", name: ec2-instance-ubuntu-2} # Ubuntu
                - {image: "ami-08bf489a05e916bbd", name: ec2-instance-Amazon-linux-1} # Amazon Linux
        ```
    * Write the Playbook:
        ```yaml
            --- 
            # Play 1:
            - hosts: localhost
            connection: local
            roles:
                - project1
        ```
* Execute the Command for creating the instances:
    ```bash
        ansible-playbook  ec2_playbook.yaml --vault-password-file vault.pass
    ```

### For Task 2:
* use ssh for password authentication:
    ```bash
        ssh-copy-id -f "-o IdentityFile ansible-project-1.pem" ec2-user@3.110.214.194 # Amazon Linux
        ssh-copy-id -f "-o IdentityFile ansible-project-1.pem" ubuntu@13.126.35.14 # Ubuntu 1
        ssh-copy-id -f "-o IdentityFile ansible-project-1.pem" ubuntu@13.201.33.158 # Ubuntu 2
    ```
* Add hosts into inventory.ini
    ```bash
        ec2-user@3.110.214.194
        ubuntu@13.126.35.14
        ubuntu@13.201.33.158
    ```

### For Task 3:
* Shut Down the ec2-instance:
    * Create playbook name **ec2_stop.yaml**
        ```yaml
            ---
            - hosts: all
              become: true

              tasks:
                - name: Print all the ansible gathered facts  # use for debugging
                  ansible.builtin.debug:
                  vars: ansible_facts

                - name: Shutdown ubuntu instances only
                  ansible.builtin.command: /sbin/shutdown -t now
                  when:
                    ansible_facts['os_family'] == "Debian"
        ```
    * Execute the command to shuddown the ec2:
        ```bash
            ansible-playbook -i inventory.init ec2_stop.yaml --vault-password-file vault.pass
        ```