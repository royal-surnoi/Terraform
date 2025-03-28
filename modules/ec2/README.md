# EC2 Infrastructure with Terraform

## input
- ami
- instance_type
- vpc_security_group
- key_pair name
- subnet_id
- tags

## Outputs
| Name               | Description                        |
|--------------------|----------------------------------|
| `public_ip`        | Public IP of the EC2 instance    |

## Usage
1. Initialize Terraform:
   ```sh
   terraform init
   ```
2. Plan the deployment:
   ```sh
   terraform plan
   ```
   ```sh
    terraform plan
        var.key_pair_name
        key_pair_name

        Enter a value:
   ```
   **Note**: ``ENTER`` for By Default *.pem* will be created on EC2 instance name, for custom we can provide name ex: **sample.pem** , it will be saved current location. same for while ``terraform apply`` and ``terraform destroy``

3. Apply the changes:
   ```sh
   terraform apply -auto-approve
   ```
4. Destroy resources if needed:
   ```sh
   terraform destroy -auto-approve
   ```

