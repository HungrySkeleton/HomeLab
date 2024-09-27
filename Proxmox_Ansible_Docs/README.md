Proxmox Cluster Ansible Integration Documentation
Overview
This documentation provides a comprehensive guide for setting up and managing a Proxmox cluster using Ansible. It includes details on the inventory configuration, playbook structure, SSH setup, and the SSH key copying process from both WSL/Windows and Linux hosts to Proxmox machines.

Table of Contents
Proxmox Cluster Setup
Ansible Inventory Configuration
Ansible Playbook Structure
SSH Setup for Remote Access
SSH Key Copying Process
From WSL (Windows)
From Linux Host
Ansible Process Diagram
Test Cases
Conclusion
Proxmox Cluster Setup
The Proxmox cluster consists of three Dell OptiPlex 7050 machines with the following IP addresses:

Node 1: Proxmox (10.0.0.2)
Node 2: Proxmox (10.0.0.5)
Node 3: Proxmox (10.0.0.6)
Ansible Inventory Configuration
Create an inventory file (e.g., inventory.ini):

ini
Copy code
[proxmox_cluster]
proxmox-node1 ansible_host=10.0.0.2
proxmox-node2 ansible_host=10.0.0.5
proxmox-node3 ansible_host=10.0.0.6

[all:vars]
ansible_user=ansible 
ansible_ssh_private_key_file=~/.ssh/id_rsa
Explanation of Inventory File
[proxmox_cluster]: Defines a group of Proxmox nodes.
ansible_host: Specifies the IP address for each node.
ansible_user: Sets the user for SSH connections.
ansible_ssh_private_key_file: Specifies the private key for SSH authentication.
Ansible Playbook Structure
An example playbook (proxmox_setup.yml):

yaml
Copy code
---
- name: Setup Proxmox Nodes
  hosts: proxmox_cluster
  tasks:
    - name: Update package index
      apt:
        update_cache: yes

    - name: Install required packages
      apt:
        name:
          - qemu-server
          - proxmox-ve
        state: present
Explanation of Playbook
name: Describes the purpose of the playbook.
hosts: Specifies the group of hosts the tasks will run on.
tasks: Contains a list of actions to perform on the hosts.
SSH Setup for Remote Access
Step 1: Generate SSH Key Pair
On your local machine, generate an SSH key pair:

bash
Copy code
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Step 2: Copy Public Keys to Proxmox Nodes
Use ssh-copy-id to copy your public key:

bash
Copy code
ssh-copy-id user@10.0.0.2
ssh-copy-id user@10.0.0.5
ssh-copy-id user@10.0.0.6
Step 3: Verify SSH Access
Try logging into one of the Proxmox nodes:

bash
Copy code
ssh user@10.0.0.2
SSH Key Copying Process
From WSL (Windows)
Open WSL: Launch your WSL terminal.
Generate SSH Key Pair:
bash
Copy code
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Copy Public Key to Proxmox Nodes:
bash
Copy code
ssh-copy-id user@10.0.0.2
ssh-copy-id user@10.0.0.5
ssh-copy-id user@10.0.0.6
Verify SSH Access:
bash
Copy code
ssh user@10.0.0.2
From Linux Host
Open Terminal.
Generate SSH Key Pair:
bash
Copy code
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Copy Public Key to Proxmox Nodes:
bash
Copy code
ssh-copy-id user@10.0.0.2
ssh-copy-id user@10.0.0.5
ssh-copy-id user@10.0.0.6
Verify SSH Access:
bash
Copy code
ssh user@10.0.0.2
Ansible Process Diagram
plaintext
Copy code
                      +----------------------+
                      |   Local Machine      |
                      |  (Ansible Control)   |
                      +----------------------+
                               |
                               | 1. Execute Ansible Playbook
                               |
                               v
                      +----------------------+
                      |      Ansible         |
                      |  (Inventory & Tasks) |
                      +----------------------+
                               |
                               | 2. Establish SSH Connection
                               |
                               v
          +-------------------------+-------------------------+
          |                         |                         |
          |                         |                         |
          v                         v                         v
+------------------+     +------------------+     +------------------+
|  Proxmox Node 1  |     |  Proxmox Node 2  |     |  Proxmox Node 3  |
|    (10.0.0.2)    |     |    (10.0.0.5)    |     |    (10.0.0.6)    |
+------------------+     +------------------+     +------------------+
          |                         |                         |
          | 3. Execute Tasks       | 3. Execute Tasks       | 3. Execute Tasks
          |                         |                         |
          v                         v                         v
+------------------+     +------------------+     +------------------+
|  Task Results     |     |  Task Results     |     |  Task Results     |
|  (Success/Fail)   |     |  (Success/Fail)   |     |  (Success/Fail)   |
+------------------+     +------------------+     +------------------+
          |                         |                         |
          | 4. Aggregate Results    |                         |
          +-------------------------+-------------------------+
                               |
                               v
                      +----------------------+
                      |   Display Summary    |
                      |   (Success/Fail)     |
                      +----------------------+
Test Cases
SSH Access Test:

bash
Copy code
ssh user@10.0.0.2
Ansible Ping Test:

bash
Copy code
ansible all -m ping -i inventory.ini
Conclusion
You have successfully set up a Proxmox cluster with Ansible integration. This documentation covers inventory configuration, playbook structure, SSH setup, and the overall Ansible process. For further queries or assistance, feel free to reach out!



Inventory Conf
## Inventory Configuration

Please create an `inventory.ini` file with the following structure:

```ini
[proxmox_cluster]
proxmox-node1 ansible_host=<YOUR_PROXMOX_IP_1>
proxmox-node2 ansible_host=<YOUR_PROXMOX_IP_2>
proxmox-node3 ansible_host=<YOUR_PROXMOX_IP_3>

[all:vars]
ansible_user=<YOUR_ANSIBLE_USER>
ansible_ssh_private_key_file=<PATH_TO_YOUR_PRIVATE_KEY>
