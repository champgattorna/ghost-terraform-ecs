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

2. **Initialize Terraform**:
    ```bash
    terraform init
    ```

3. **Deploy the infrastructure**:
    ```bash
    terraform apply -auto-approve
    ```

4. **Access the application**:
    After deployment, check the output for the Load Balancer URL. Visit that URL to access your Ghost blog.

5. **CI/CD Pipeline**:
    - When you open a pull request, tests will automatically run.
    - Once the PR is merged, the new application version will be deployed to ECS.
