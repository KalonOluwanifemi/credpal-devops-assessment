# Credpal DevOps Assessment

A Node.js application deployment pipeline built with Docker, Terraform, and GitHub Actions on AWS.
## Note

This project is currently running in a **staging environment**. Due to subscription and cost constraints, the following features were not implemented in this assessment but will be available in the production setup:

- **HTTPS** via SSL/TLS certificate
- **Custom domain name** configured with Route 53 or any DNS provider
- **SSL Certificate** provisioned via AWS ACM or Certbot with Nginx
- **HTTP to HTTPS redirect** on the load balancer

The production environment will have all the necessary security features, a custom domain, and full HTTPS support configured end to end.

## Live Staging Environment

The application is currently deployed and accessible at the following endpoints:

| Endpoint | Description |
|----------|-------------|
| [/health](http://staging-alb-362296424.eu-north-1.elb.amazonaws.com/health) | Health check endpoint |
| [/process](http://staging-alb-362296424.eu-north-1.elb.amazonaws.com/process) | Process endpoint |
| [/status](http://staging-alb-362296424.eu-north-1.elb.amazonaws.com/status) | Status endpoint |

> **Note:** This is a staging environment running over HTTP. HTTPS and a custom domain will be configured in the production environment.

## Architecture Overview
```
Internet → ALB (Port 80) → EC2 Instance → Docker (Node.js App :3000 + Redis :6379)
```

### Infrastructure Components
- **VPC** with public subnets across 2 availability zones
- **EC2 Instance** (Amazon Linux 2023) with Elastic IP
- **Application Load Balancer** for traffic distribution
- **Security Groups** for ALB and EC2 with least privilege access
- **S3 Backend** for Terraform state management

## Tech Stack

- **Runtime**: Node.js 18
- **Containerization**: Docker + Docker Compose
- **Infrastructure**: Terraform
- **CI/CD**: GitHub Actions
- **Cloud**: AWS (EC2, ALB, VPC, S3)
- **Registry**: DockerHub

## Project Structure
```
├── app/                          # Node.js application
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── terraform/
│   ├── main.tf                   # Root module
│   ├── variables.tf              # Root variables
│   ├── outputs.tf                # Root outputs
│   ├── backend.tf                # S3 backend configuration
│   ├── staging.tfvars            # Staging environment values
│   └── modules/
│       └── app-infra/
│           ├── main.tf           # All AWS resources
│           ├── variables.tf      # Module variables
│           └── outputs.tf        # Module outputs
└── .github/
    └── workflows/
        └── staging.yaml          # CI/CD pipeline
```

## CI/CD Pipeline

The pipeline runs automatically on every push to the `staging` branch and consists of three jobs that run sequentially:

### 1. Build
- Installs Node.js dependencies
- Runs tests
- Builds Docker image tagged with Git SHA
- Pushes image to DockerHub

### 2. Deploy Infrastructure
- Configures AWS credentials
- Runs `terraform init`, `plan` and `apply`
- Only applies if there are infrastructure changes

### 3. Deploy App
- SSHs into EC2 instance as `credpal` user
- Stops and removes old containers
- Pulls latest Docker image
- Starts Redis and application containers

## Infrastructure

### Networking
- VPC with CIDR `10.0.0.0/16`
- 2 public subnets across different availability zones
- Internet Gateway and public route table

### Security Groups
- **ALB**: Allows inbound HTTP (80) and HTTPS (443) from anywhere
- **EC2**: Allows SSH (22), HTTP (80), HTTPS (443) and app port (3000) from ALB only

### EC2 Instance
- Amazon Linux 2023
- Docker and Docker Compose installed via user data script
- Elastic IP for stable public access
- Registered to ALB target group

## Prerequisites

### GitHub Secrets
Add the following secrets to your GitHub repository under **Settings → Secrets → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `DOCKERHUB_USERNAME` | DockerHub username |
| `DOCKERHUB_TOKEN` | DockerHub access token |
| `EC2_PUBLIC_IP` | Elastic IP of EC2 instance |
| `EC2_PRIVATE_KEY` | Private SSH key for credpal user |

### AWS Resources Required
- S3 bucket for Terraform state (`credpal-terraform-state`)
- IAM user with EC2, VPC, ALB and S3 permissions

## Local Development

### Requirements
Make sure you have the following installed on your machine:
- [Node.js 18](https://nodejs.org/en/download)
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Environment Variables
Create a `.env` file in the `app/` directory with the following:
```bash
PORT=3000
REDIS_HOST=redis
REDIS_PORT=6379
NODE_ENV=development
```

### Option 1 - Run with Node.js directly
```bash
# Clone the repository
git clone https://github.com/KalonOluwanifemi/credpal-devops-assessment.git
cd credpal-devops-assessment

# Install dependencies
cd app
npm install

# Run tests
npm test

# Start the application
npm start
```

The app will be available at `http://localhost:3000`

### Option 2 - Run with Docker
```bash
# Clone the repository
git clone https://github.com/KalonOluwanifemi/credpal-devops-assessment.git
cd credpal-devops-assessment

# Build the Docker image
docker build -t credpal-app .

# Start Redis container
docker run -d --name redis -p 6379:6379 redis:latest

# Start the application container
docker run -d \
  --name credpal-app \
  --link redis:redis \
  -p 3000:3000 \
  credpal-app
```

The app will be available at `http://localhost:3000`

### Option 3 - Run with Docker Compose
```bash
# Clone the repository
git clone https://github.com/KalonOluwanifemi/credpal-devops-assessment.git
cd credpal-devops-assessment

# Start all services
docker-compose up -d
```

The app will be available at `http://localhost:3000`

### Verify the App is Running
```bash
# Check the app is responding
curl http://localhost:3000

# Check the health endpoint
curl http://localhost:3000/health
```

### View Application Logs
```bash
# View logs with Node.js
npm start

# View Docker container logs
docker logs credpal-app

# Follow Docker container logs in real time
docker logs -f credpal-app

# View Docker Compose logs
docker-compose logs -f
```

### Stopping the Application
```bash
# Stop Docker containers
docker stop credpal-app redis

# Remove Docker containers
docker rm credpal-app redis

# Stop and remove Docker Compose services
docker-compose down
```

### Running Tests
```bash
cd app

# Run all tests
npm test

# Run tests in watch mode
npm run test:watch
```

## Deployment

Push to the `staging` branch to trigger the pipeline:
```bash
git push origin staging
```

Monitor the pipeline at:
```
https://github.com/KalonOluwanifemi/credpal-devops-assessment/actions
```

## Health Check

The application exposes a health check endpoint:
```bash
# Via Elastic IP
curl http://YOUR_ELASTIC_IP:3000/health

# Via ALB DNS
curl http://YOUR_ALB_DNS/health
```

## Infrastructure Management
```bash
cd terraform

# Initialize
terraform init

# Plan changes
terraform plan -var-file=staging.tfvars -var="docker_image=placeholder"

# Apply changes
terraform apply -var-file=staging.tfvars -var="docker_image=placeholder"

# View outputs
terraform output

# Destroy all infrastructure
terraform destroy -var-file=staging.tfvars -var="docker_image=placeholder"
```

## Troubleshooting

### Pipeline fails at deploy-app step
- Verify `EC2_PRIVATE_KEY` secret is correctly set in GitHub
- Verify `EC2_PUBLIC_IP` secret matches your current Elastic IP
- Check the `credpal` user exists on the EC2 instance and is in the docker group

### Docker permission denied on EC2
- SSH into the instance and run:
```bash
sudo usermod -aG docker credpal
echo "credpal ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/credpal
sudo systemctl restart docker
```

### ALB returning 502 Bad Gateway
- Check the app is running on port 3000 on the EC2 instance
- Verify the target group health check is passing
- Check the EC2 security group allows traffic from the ALB on port 3000

### Terraform state not found
- Make sure the S3 bucket `credpal-terraform-state` exists
- Verify AWS credentials have access to the S3 bucket
- Run `terraform init` before any other terraform commands
