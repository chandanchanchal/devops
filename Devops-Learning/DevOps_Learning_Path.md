# DevOps Learning Path (AWS + Docker + Kubernetes Focus)

**Starting point:** Fresh CS grad, knows Python basics
**Goal:** Job-ready DevOps engineer in ~6–8 months of consistent study (10–12 hrs/week)

Structured in phases. Don't skip Phase 1 — most self-taught DevOps folks who get stuck have weak Linux/networking fundamentals.

---

## Phase 0: Prerequisites Check (1 week)
- Comfortable with Python basics ✅ (you already have this)
- Basic command line usage
- Understanding of what a server/client is

---

## Phase 1: Linux & Networking Fundamentals (3–4 weeks)

DevOps runs on Linux servers. This is non-negotiable.

| Topic | Resource |
|---|---|
| Linux basics (filesystem, permissions, processes) | [Linux Journey](https://linuxjourney.com/) — free, interactive |
| Shell scripting (bash) | [freeCodeCamp Bash Scripting](https://www.freecodecamp.org/news/bash-scripting-tutorial-linux-shell-script-and-command-line-for-beginners/) |
| Networking basics (TCP/IP, DNS, HTTP, ports) | [freeCodeCamp Networking Course (YouTube)](https://www.youtube.com/watch?v=IPvYjXCsTg8) |
| Practice | [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) — hands-on Linux CLI wargame |

**Checkpoint project:** Write 3–4 bash scripts (log rotation, backup script, disk usage alert) and push to GitHub.

---

## Phase 2: Git & Version Control (1 week)

| Topic | Resource |
|---|---|
| Git fundamentals | [Git official docs / Pro Git book](https://git-scm.com/book/en/v2) (free) |
| Hands-on practice | [Learn Git Branching](https://learngitbranching.js.org/) — interactive, excellent |
| GitHub workflows | [GitHub Skills](https://skills.github.com/) — free guided courses |

**Checkpoint:** Comfortable with branching, merging, rebasing, resolving conflicts, PRs.

---

## Phase 3: Python for DevOps (2 weeks)

Since you already know Python basics, focus on automation-specific skills.

| Topic | Resource |
|---|---|
| Scripting for automation (os, subprocess, argparse) | [Automate the Boring Stuff with Python](https://automatetheboringstuff.com/) — fully free online |
| Working with APIs (requests library) | [Real Python – requests tutorial](https://realpython.com/python-requests/) |
| Boto3 (AWS SDK for Python) — save for after Phase 4 | [Boto3 Docs](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html) |

**Checkpoint project:** Write a Python script that hits a public API, parses JSON, and logs results to a file.

---

## Phase 4: AWS Cloud (4–5 weeks) — YOUR PRIMARY FOCUS

### Step 1: Core Concepts
| Topic | Resource |
|---|---|
| AWS fundamentals | [AWS Skill Builder – Cloud Practitioner Essentials](https://skillbuilder.aws/) (free official course) |
| Structured free course | [freeCodeCamp AWS Certified Cloud Practitioner (YouTube, 14 hrs)](https://www.youtube.com/watch?v=SOTamWNgDKc) |

### Step 2: Core Services to Master Hands-On
Create a **free tier AWS account** (12 months free tier + always-free services) and actually build with:
- **IAM** — users, roles, policies (critical for everything else)
- **EC2** — launch instances, security groups, key pairs
- **S3** — buckets, static website hosting, versioning
- **VPC** — subnets, route tables, internet gateways, NAT
- **RDS** — managed databases
- **Lambda** — serverless functions
- **CloudWatch** — logging/monitoring
- **ELB/ASG** — load balancers & auto-scaling groups

| Resource | Link |
|---|---|
| Hands-on labs (some free tier) | [AWS Skill Builder Labs](https://skillbuilder.aws/) |
| Practice projects | [AWS Free Tier + AWS Workshops](https://workshops.aws/) — official, free, project-based |

### Step 3: Certification (optional but valuable early on)
- **AWS Certified Cloud Practitioner** → then **AWS Certified SysOps Administrator** or **AWS Certified DevOps Engineer – Professional** (later, after experience)
- Free study material: [Tutorials Dojo Free Practice Questions](https://tutorialsdojo.com/) (some free, some paid — worth checking free samples)

**Checkpoint project:** Host a static website on S3 + CloudFront, deploy a Python Flask app on EC2 behind an ELB with auto-scaling.

---

## Phase 5: Docker (2–3 weeks)

| Topic | Resource |
|---|---|
| Docker fundamentals | [Docker Official Docs — Get Started](https://docs.docker.com/get-started/) |
| Full course | [freeCodeCamp Docker Course (YouTube, 3 hrs)](https://www.youtube.com/watch?v=fqMOX6JJhGo) |
| Deeper dive | [TechWorld with Nana – Docker Tutorial (YouTube)](https://www.youtube.com/watch?v=3c-iBn73dDE) |

### Concepts to nail:
- Images vs containers
- Dockerfile best practices (multi-stage builds, layer caching)
- Docker Compose for multi-container apps
- Volumes & networking in Docker
- Pushing images to Docker Hub / AWS ECR

**Checkpoint project:** Containerize your Python Flask app, write a Dockerfile, use Docker Compose to add a database container (Postgres/MySQL), push image to Docker Hub and AWS ECR.

---

## Phase 6: Kubernetes (4–5 weeks)

This is the hardest phase conceptually — go slow.

| Topic | Resource |
|---|---|
| K8s fundamentals | [Kubernetes Official Docs Tutorials](https://kubernetes.io/docs/tutorials/) |
| Full course | [TechWorld with Nana – Kubernetes Course (YouTube, 4 hrs)](https://www.youtube.com/watch?v=X48VuDVv0do) |
| Hands-on interactive | [Killercoda Kubernetes Playgrounds](https://killercoda.com/kubernetes) — free interactive terminal, no setup |
| Local practice environment | [Minikube](https://minikube.sigs.k8s.io/docs/start/) or [Kind](https://kind.sigs.k8s.io/) — run K8s locally for free |

### Concepts to nail:
- Pods, Deployments, ReplicaSets, Services
- ConfigMaps & Secrets
- Namespaces, Labels, Selectors
- Ingress controllers
- Persistent Volumes
- Helm (package manager for K8s) — [Helm Docs](https://helm.sh/docs/)
- **AWS EKS** (Elastic Kubernetes Service) — running K8s on AWS specifically

**Checkpoint project:** Deploy your Dockerized Flask + DB app to a local Minikube cluster, then deploy the same setup to AWS EKS.

---

## Phase 7: CI/CD (2 weeks)

| Topic | Resource |
|---|---|
| CI/CD concepts | [freeCodeCamp CI/CD Explained (YouTube)](https://www.youtube.com/watch?v=1er2cjUq1UI) |
| GitHub Actions | [GitHub Actions Docs](https://docs.github.com/en/actions) — free for public repos |
| Jenkins (still widely used in industry) | [Jenkins Official Tutorials](https://www.jenkins.io/doc/tutorials/) |

**Checkpoint project:** Build a GitHub Actions pipeline that: runs tests → builds Docker image → pushes to ECR → deploys to EKS automatically on push to main.

---

## Phase 8: Infrastructure as Code (2–3 weeks)

| Topic | Resource |
|---|---|
| Terraform fundamentals | [HashiCorp Learn – Terraform](https://developer.hashicorp.com/terraform/tutorials) (official, free) |
| Full course | [TechWorld with Nana – Terraform Course (YouTube)](https://www.youtube.com/watch?v=SLB_c_ayRMo) |

**Checkpoint project:** Write Terraform scripts to provision your entire AWS setup (VPC, EC2/EKS, S3, IAM roles) instead of doing it manually via console.

---

## Phase 9: Monitoring & Observability (1–2 weeks)

| Topic | Resource |
|---|---|
| Prometheus & Grafana | [Prometheus Docs](https://prometheus.io/docs/introduction/overview/) + [Grafana Fundamentals (free course)](https://grafana.com/tutorials/) |
| Full course | [TechWorld with Nana – Prometheus/Grafana (YouTube)](https://www.youtube.com/watch?v=h4Sl21AKiDg) |

**Checkpoint project:** Set up Prometheus + Grafana to monitor your Kubernetes cluster and Flask app metrics.

---

## Phase 10: Capstone Project (2–3 weeks)

Combine everything into one portfolio project:

> **Example:** A Python microservice app, containerized with Docker, orchestrated on AWS EKS, provisioned via Terraform, deployed via a GitHub Actions CI/CD pipeline, monitored with Prometheus/Grafana, with logs centralized in CloudWatch.

Put this on GitHub with a clear README, architecture diagram, and write a blog post/LinkedIn post explaining it. This becomes your #1 talking point in interviews.

---

## Ongoing / Parallel Learning
- **YouTube channels to follow throughout:** TechWorld with Nana, freeCodeCamp, AWS Events (official)
- **Practice platforms:** [KillerCoda](https://killercoda.com/), [Katacoda-style labs], [AWS Workshops](https://workshops.aws/)
- **Community:** r/devops, r/aws, DevOps Discord servers, join AWS User Groups if any near you (Bengaluru has an active one)
- **Read weekly:** [DevOps Weekly Newsletter](https://www.devopsweekly.com/) (free)

---

## Suggested Timeline Summary

| Phase | Duration |
|---|---|
| Linux & Networking | 3–4 weeks |
| Git | 1 week |
| Python for DevOps | 2 weeks |
| AWS | 4–5 weeks |
| Docker | 2–3 weeks |
| Kubernetes | 4–5 weeks |
| CI/CD | 2 weeks |
| Terraform (IaC) | 2–3 weeks |
| Monitoring | 1–2 weeks |
| Capstone | 2–3 weeks |
| **Total** | **~24–30 weeks (6–8 months)** |

---

## Final Advice
- **Build in public** — push every project to GitHub, even small ones. Recruiters and hiring managers check this.
- **Don't chase certifications before hands-on skills** — certs help but real projects matter more for entry-level roles.
- **One cloud provider first** — you chose AWS, stick with it deeply before touching Azure/GCP.
- **Document as you learn** — write short notes/blogs on what you build. This reinforces learning and builds your portfolio simultaneously.
