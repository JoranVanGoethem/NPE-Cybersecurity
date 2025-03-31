#! /bin/bash
#
# Script voor Webserver

#------------------------------------------------------------------------------ 
# Bash settings 
#------------------------------------------------------------------------------ 
set -o errexit   # abort on nonzero exitstatus 
set -o nounset   # abort on unbound variable 
set -o pipefail  # don't mask errors in piped commands
set -u           # Stop het script bij een onbestaande variabele

#------------------------------------------------------------------------------ 
# Variables 
#------------------------------------------------------------------------------ 

$version = "8.5p1"

#------------------------------------------------------------------------------ 
# Provision server 
#------------------------------------------------------------------------------ 
log "Starting server specific provisioning tasks on ${HOSTNAME}"

#------------------------------------------------------------------------------ 
# Functions 
#------------------------------------------------------------------------------ 

function Install_32BitOpenSSH {
    # Enable EPEL repository
    sudo dnf install -y epel-release
    sudo dnf update -y

    # Check for available versions of OpenSSH (32-bit)
    sudo dnf --showduplicates list openssh-server.i686

    # Install a specific version of OpenSSH if available (e.g., 8.5p1)
    sudo dnf install -y openssh-server-"$version".i686

    # If the desired version is not available in the repository, we can try to install it manually.
    # For manual installation, download the appropriate .rpm from a trusted source and install it.
    # Example:
    # wget https://example.com/openssh-server-<version>.i686.rpm
    # sudo dnf install /path/to/openssh-server-<version>.i686.rpm
}

# Call the function to install 32-bit OpenSSH
Install_32BitOpenSSH