# Ghost Deployment on AWS ECS - Alasco Task Stage Problem
### Written and tested by Christian Hamp-Gattorna 24.09.2024

## Prerequisites
- Install Terraform
- AWS account with appropriate access rights
- GitHub repository with Secrets configured for AWS credentials

## Setup Instructions
1. **Clone the repository**:
    ```bash
    git clone https://github.com/champgattorna/ghost-poc.git
    cd ghost-poc
    ```

2. **Setup Backend (FIRST TIME ONLY)**:
    1. Comment out backend.tf
    2. Initialize Terraform
    ```bash
    terraform init
    ```
    3. Run Apply
    ```bash
    terraform apply
    ```
    4. Once backend is setup, uncomment backend.tf
    5. Initialize Terraform again
    ```bash
    terraform init
    ```
    6. When prompted to migrate state, write `yes`


***After First Setup***

1. **Initialize Terraform**:
    ```bash
    terraform init
    ```

2. **Deploy the infrastructure**:
    ```bash
    terraform apply -auto-approve
    ```

3. **Access the application**:
    After deployment, check the output for the Load Balancer URL. Visit that URL to access your Ghost blog. Ensure to use HTTP instead of HTTPS.

4. **CI/CD Pipeline**:
    - Opening a pull request, will start the execution of the mock tests, which for the purpose of this task, will automatically "pass".
    - Once the PR is merged, the new application version will be deployed to ECS.
