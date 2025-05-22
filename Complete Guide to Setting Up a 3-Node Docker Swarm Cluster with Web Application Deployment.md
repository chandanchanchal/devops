# Complete Guide to Setting Up a 3-Node Docker Swarm Cluster with Web Application Deployment

This comprehensive guide will walk you through the process of creating a 3-node Docker Swarm cluster and deploying a web application with frontend, backend, and database components. Each step is explained in detail to ensure a smooth setup process.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Docker Swarm Cluster Setup](#docker-swarm-cluster-setup)
3. [Web Application Architecture](#web-application-architecture)
4. [Deploying the Application Stack](#deploying-the-application-stack)
5. [Required Ports List](#required-ports-list)
6. [Maintenance and Troubleshooting](#maintenance-and-troubleshooting)

## Prerequisites

Before setting up a Docker Swarm cluster, ensure you have the following:

- Three servers/VMs with the following minimum specifications:
  - 2 CPU cores
  - 2GB RAM
  - 20GB storage
  - Ubuntu 20.04 LTS or newer (or any Linux distribution that supports Docker)
- Docker Engine installed on all nodes (version 19.03 or newer)
- Network connectivity between all nodes
- Static IP addresses assigned to all nodes
- SSH access to all nodes
- Sudo/root privileges on all nodes
- Firewall configured to allow necessary ports (detailed in the [Required Ports List](#required-ports-list) section)

## Docker Swarm Cluster Setup

### Step 1: Install Docker on All Nodes

First, ensure Docker is installed on all three nodes. Run the following commands on each node:

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package index again
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group (optional, for convenience)
sudo usermod -aG docker $USER

# Verify Docker installation
docker --version
```

After running these commands, you may need to log out and log back in for the group changes to take effect.

### Step 2: Initialize the Swarm on the Manager Node

Choose one of your nodes to be the Swarm manager. This node will be responsible for managing the cluster. On this node, run:

```bash
# Initialize the swarm with the manager node's IP address
# Replace 192.168.1.10 with your manager node's actual IP address
docker swarm init --advertise-addr 192.168.1.10
```

This command initializes a new Swarm and makes the current node a manager. The output will include a token that worker nodes need to join the Swarm. It will look something like this:

```
Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c 192.168.1.10:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Make note of the join command as you'll need it for the worker nodes.

### Step 3: Add Worker Nodes to the Swarm

On each of your worker nodes, run the join command that was output when you initialized the Swarm:

```bash
# Replace with the actual token and IP address from your manager node
docker swarm join --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c 192.168.1.10:2377
```

If you lost the token, you can retrieve it on the manager node by running:

```bash
docker swarm join-token worker
```

### Step 4: Verify the Swarm Cluster

On the manager node, run the following command to verify that all nodes have joined the Swarm:

```bash
docker node ls
```

You should see output similar to this:

```
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
dxn1zf6l61qsb1josjja83ngz *  manager             Ready               Active              Leader              19.03.13
jt30j8zms2r2oz1hpuget0xqg    worker1             Ready               Active                                  19.03.13
c54o75tl5xfo9n7a8cmrwlxdg    worker2             Ready               Active                                  19.03.13
```

This confirms that your 3-node Swarm cluster is now operational, with one manager and two worker nodes.

### Step 5: Configure Swarm for High Availability (Optional)

For production environments, it's recommended to have multiple manager nodes for high availability. To promote a worker node to a manager, run the following on the manager node:

```bash
# Replace worker1 with the hostname or node ID of the worker you want to promote
docker node promote worker1
```

For a 3-node cluster, having 3 managers provides the highest fault tolerance, allowing the cluster to continue functioning even if one node fails.

## Web Application Architecture

For our web application deployment, we'll use a typical three-tier architecture:

1. **Frontend Container**: A web UI container that serves the user interface
2. **Backend Container**: An application server that processes business logic
3. **Database Container**: A database for persistent storage

This architecture will be deployed as a Docker stack, which is a collection of services defined in a Docker Compose file and deployed to a Swarm.

### Architecture Diagram

```
                    +----------------+
                    |  Load Balancer |
                    +----------------+
                            |
                            v
                +------------------------+
                |                        |
                |   Frontend Container   |
                |                        |
                +------------------------+
                            |
                            v
                +------------------------+
                |                        |
                |   Backend Container    |
                |                        |
                +------------------------+
                            |
                            v
                +------------------------+
                |                        |
                |  Database Container    |
                |                        |
                +------------------------+
```

## Deploying the Application Stack

### Step 1: Create a Docker Compose File

On the manager node, create a file named `docker-compose.yml` with the following content:

```yaml
version: '3.8'

services:
  frontend:
    image: nginx:latest
    ports:
      - "80:80"
    networks:
      - webnet
    deploy:
      replicas: 2
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    volumes:
      - frontend_data:/usr/share/nginx/html
    depends_on:
      - backend

  backend:
    image: node:14-alpine
    command: sh -c "npm install && npm start"
    working_dir: /app
    volumes:
      - backend_data:/app
    networks:
      - webnet
      - backnet
    deploy:
      replicas: 2
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    environment:
      - DB_HOST=database
      - DB_PORT=5432
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_NAME=myapp
    depends_on:
      - database

  database:
    image: postgres:13
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - backnet
    deploy:
      placement:
        constraints:
          - node.role == manager
      restart_policy:
        condition: on-failure
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=myapp

networks:
  webnet:
  backnet:

volumes:
  frontend_data:
  backend_data:
  db_data:
```

This Docker Compose file defines three services:

1. **Frontend**: An Nginx web server that serves the user interface
2. **Backend**: A Node.js application server that handles business logic
3. **Database**: A PostgreSQL database for persistent storage

The services are connected through two networks:
- `webnet`: Connects the frontend and backend
- `backnet`: Connects the backend and database

Each service has specific deployment configurations, including replica count, update policy, and restart policy.

### Step 2: Deploy the Stack

On the manager node, deploy the stack using the following command:

```bash
docker stack deploy -c docker-compose.yml myapp
```

This command deploys the stack defined in the Docker Compose file with the name "myapp".

### Step 3: Verify the Deployment

Check the status of the services in the stack:

```bash
docker stack services myapp
```

You should see output similar to this:

```
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
bvf0qpky0z88        myapp_backend       replicated          2/2                 node:14-alpine      
n3q46bxj8d7n        myapp_database      replicated          1/1                 postgres:13         
xnvl86d5cvxg        myapp_frontend      replicated          2/2                 nginx:latest        *:80->80/tcp
```

This confirms that all services are running with the specified number of replicas.

### Step 4: Access the Application

You can now access the web application by navigating to the IP address of any node in the Swarm on port 80:

```
http://192.168.1.10
```

The Swarm's built-in routing mesh will route the request to one of the frontend containers, regardless of which node it's running on.

## Required Ports List

For a Docker Swarm cluster to function properly and for the web application to be accessible, the following ports need to be open:

| Port    | Protocol | Direction | Purpose                                      | Notes                                      |
|---------|----------|-----------|----------------------------------------------|-------------------------------------------|
| 2377    | TCP      | Inbound   | Swarm cluster management communications      | Only on manager nodes                      |
| 7946    | TCP/UDP  | Bi-directional | Communication among nodes               | All nodes                                  |
| 4789    | UDP      | Bi-directional | Overlay network traffic                 | All nodes                                  |
| 50     | TCP      | Inbound   | Overlay network traffic (Windows nodes)      | Only if using Windows nodes                |
| 80      | TCP      | Inbound   | Web application frontend access              | All nodes (for external access)            |
| 443     | TCP      | Inbound   | Secure web application access (if using SSL) | All nodes (for external access)            |
| 22      | TCP      | Inbound   | SSH access for management                    | All nodes (for administration)             |
| 5432    | TCP      | Internal  | PostgreSQL database access                   | Internal only (not exposed externally)     |

### Explanation of Required Ports:

1. **Port 2377 (TCP)**: This port is used for communication between the Swarm manager and worker nodes. It's essential for cluster management operations like node joining, leaving, and updates.

2. **Port 7946 (TCP/UDP)**: This port is used for communication among nodes for node discovery and cluster management. Both TCP and UDP protocols are used.

3. **Port 4789 (UDP)**: This port is used for overlay network traffic, which allows containers on different nodes to communicate with each other.

4. **Port 50 (TCP)**: This port is used for overlay network traffic on Windows nodes. It's only necessary if you're using Windows nodes in your Swarm.

5. **Port 80 (TCP)**: This port is used for HTTP traffic to the web application frontend. It needs to be open on all nodes to allow external access to the application.

6. **Port 443 (TCP)**: This port is used for HTTPS traffic if you're using SSL/TLS for secure communication. It's recommended for production environments.

7. **Port 22 (TCP)**: This port is used for SSH access to the nodes for administration purposes. It's not directly related to Docker Swarm but is necessary for managing the nodes.

8. **Port 5432 (TCP)**: This port is used for PostgreSQL database access. It's only used internally within the Swarm and doesn't need to be exposed externally.

### Firewall Configuration Example (UFW)

Here's an example of how to configure the firewall using UFW (Uncomplicated Firewall) on Ubuntu:

On manager nodes:

```bash
# Allow SSH
sudo ufw allow 22/tcp

# Allow Swarm ports
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

# Allow web application ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable the firewall
sudo ufw enable
```

On worker nodes:

```bash
# Allow SSH
sudo ufw allow 22/tcp

# Allow Swarm ports
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

# Allow web application ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable the firewall
sudo ufw enable
```

## Maintenance and Troubleshooting

### Scaling Services

To scale a service up or down, use the `docker service scale` command:

```bash
# Scale the frontend service to 5 replicas
docker service scale myapp_frontend=5
```

### Updating Services

To update a service with a new image or configuration:

```bash
# Update the backend service with a new image
docker service update --image node:16-alpine myapp_backend
```

### Viewing Logs

To view logs for a service:

```bash
# View logs for the frontend service
docker service logs myapp_frontend
```

### Troubleshooting Common Issues

1. **Nodes can't join the Swarm**: Ensure that the required ports are open and that the nodes can communicate with each other.

2. **Services not starting**: Check the service logs for error messages:
   ```bash
   docker service logs <service_name>
   ```

3. **Application not accessible**: Verify that the services are running and that the ports are correctly mapped:
   ```bash
   docker stack services myapp
   ```

4. **Database connection issues**: Check the environment variables in the backend service to ensure they match the database configuration.

5. **Node failures**: If a node fails, the Swarm will automatically reschedule the containers to other nodes. To remove a failed node:
   ```bash
   docker node rm <node_id>
   ```

### Backing Up the Swarm Configuration

To back up the Swarm configuration:

```bash
# On a manager node
sudo tar -czvf swarm-backup.tar.gz /var/lib/docker/swarm
```

This backs up the Swarm state, which can be restored if needed.

## Conclusion

You have now successfully set up a 3-node Docker Swarm cluster and deployed a web application with frontend, backend, and database components. This setup provides high availability, scalability, and ease of management for your application.

Remember to regularly update your Docker engine and images to ensure security and stability. Also, consider implementing monitoring and logging solutions to keep track of your cluster's health and performance.

For production environments, you may want to consider additional features such as:
- Implementing secrets management for sensitive data
- Setting up a CI/CD pipeline for automated deployments
- Configuring backups for your database and application data
- Implementing a monitoring solution like Prometheus and Grafana
