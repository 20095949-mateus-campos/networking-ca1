#!/bin/bash

# Module Title:         Network Systems and Administration
# Module Code:          B9IS121
# Module Instructor:    Kingsley Ibomo
# Assessment Title:     Automated Container Deployment and Administration in the Cloud
# Assessment Number:    1
# Assessment Type:      Practical
# Assessment Weighting: 60%
# Assessment Due Date:  Sunday, 9 November 2025, 8:36 AM
# Student Name:         Mateus Fonseca Campos
# Student ID:           20095949
# Student Email:        20095949@mydbs.ie
# GitHub Repo:          https://github.com/20095949-mateus-campos/networking-ca1

# This file belongs to all parts (1-4) as it conveniently runs all the required scripts in one place

set -e # exit if error

root="$(pwd)" # set project root to script's location
github=https://github.com/20095949-mateus-campos/networking-ca1

cd "$root/terraform"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then # "bash run_project.sh -h/--help" prints help menu
    echo "Usage: bash run_project.sh [OPTIONS]\n"
    echo "Automate parts 1, 2 and 3 of this project.\n"
    echo "Options:"
    echo "  -c, --clean-up   Tell Terraform to destroy all resources previously deployed."
    echo "  -h, --help       Display this help guide.\n"
    echo "For more information, visit the project's GitHub at $github."
elif [ "$1" = "-c" ] || [ "$1" = "--clean-up" ]; then # "bash run_project.sh -c/--clean-up" destroys infrastructure
    terraform destroy -input=false -auto-approve   
else # "bash run_project.sh" is the default deployment run
    # if SSH key does not exist, then generate one
    if [ ! -f "$root/net_ca1_key.pem" ]; then
        yes "y" | ssh-keygen -t rsa -b 4096 -f "$root/net_ca1_key.pem" -N "" -q
        chmod 0400 "$root/net_ca1_key.pem"
    fi

    # Terraform deploys infrastructure
    terraform init -input=false
    terraform apply -input=false -auto-approve

    # wait for 10 seconds before trying to connect to the instance so that it has time to start
    echo; echo -n "Waiting for server to initialize:"
    for sec in {1..20}; do
        sleep 0.5
        echo -n "."
    done
    echo "OK"

    # Ansible connects to the instance and runs playbooks
    cd "$root/ansible"
    ansible-playbook -i inventory.yaml playbook_setup.yaml
    ansible-playbook -i inventory.yaml playbook_deployment.yaml
    ansible-playbook -i inventory.yaml playbook_cicd.yaml

    # grabs instance public IPv4 address
    remote_ip="$(grep -w ansible_host: inventory.yaml | tr -d '[:blank:]' | sed -e 's/.*://')"

    # open web application in the default browser
    if [ "$(xdg-open http://$remote_ip &)" ] || [ true ]; then
        echo "If the web page did not open automatically, (Ctrl+)click here: http://$remote_ip."
    fi  
fi

exit 0
