# Ansible Playbook for Docker Deployment

## Overview

This guide provides instructions for using an Ansible playbook to deploy Docker containers on a local Ubuntu server. The playbook will:

1. Check if Docker is installed.
2. Install Docker if it is not present.
3. Pull a Docker image from a container registry.
4. Run a Docker container with the specified configurations.

## Prerequisites

1. **Ubuntu Server**: Ensure you have an Ubuntu server (e.g., 20.04 or later).
2. **Ansible**: Ansible should be installed on your local machine. You can install it using:

   ```bash
   sudo apt update
   sudo apt-add-repository ppa:ansible/ansible
   sudo apt install ansible
   sudo nano /etc/ansible/hosts
   ```
   
   add this: 
   
   ```
   [servers]
   server1 ansible_host=203.0.113.111
   server2 ansible_host=203.0.113.112
   server3 ansible_host=203.0.113.113

   [all:vars]
   ansible_python_interpreter=/usr/bin/python3
  ```

  ansible-inventory --list -y
```
  **Output**
```
all:
  children:
    servers:
      hosts:
        server1:
          ansible_host: 203.0.113.111
          ansible_python_interpreter: /usr/bin/python3
        server2:
          ansible_host: 203.0.113.112
          ansible_python_interpreter: /usr/bin/python3
        server3:
          ansible_host: 203.0.113.113
          ansible_python_interpreter: /usr/bin/python3
    ungrouped: {}
  ```

**Output**
- ![image](https://github.com/user-attachments/assets/0330fb83-fcef-4649-9efa-e22e28f068b3)
