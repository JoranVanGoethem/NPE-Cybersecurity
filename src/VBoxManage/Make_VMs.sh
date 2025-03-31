#! /bin/bash
#
# Script voor testing

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

kalipath = "/path/to/kali-vdi.vdi"
debpath = "/path/to/deb-vdi.vdi"

#------------------------------------------------------------------------------ 
# Provision server 
#------------------------------------------------------------------------------ 
log "Starting server specific provisioning tasks on ${HOSTNAME}"

#------------------------------------------------------------------------------ 
# Functions 
#------------------------------------------------------------------------------ 

function create_VM {
    # Create VMs
    VBoxManage createvm --name "Vulnerable-VM" --register
    VBoxManage createvm --name "Kali-VM" --register

    # Configure VMs
    VBoxManage modifyvm "Vulnerable-VM" --memory 1024 --cpus 1 --nic1 intnet --intnet1 "intnet"
    VBoxManage modifyvm "Kali-VM" --memory 2048 --cpus 2 --nic1 intnet --intnet1 "intnet"

    # Attach VDIs
    VBoxManage storagectl "Vulnerable-VM" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "Vulnerable-VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /path/to/debian-vdi.vdi

    VBoxManage storagectl "Kali-VM" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "Kali-VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /path/to/kali-linux-vdi.vdi

    # Start VMs
    VBoxManage startvm "Vulnerable-VM" --type headless
    VBoxManage startvm "Kali-VM" --type headless
}
