# Steps:
```bash
    # Install boto3
    pip install boto3

    # install amazon collection
    ansible-galaxy collection install amazon.aws

    # Create a password "vault.pass"
    openssl rand -base64 2048 > vault.pass

    # Add Secrects into vault
    ansible-vault create group_vars/all/pass.yml --vault-password-file vault.pass

    # Execute the playbook:
    ansible-playbook -i init s3_playbook.yaml --vault-password-file vault.pass
````