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

vdipath = "/path/to/debian-vdi.vdi"

#------------------------------------------------------------------------------ 
# Provision server 
#------------------------------------------------------------------------------ 
log "Starting server specific provisioning tasks on ${HOSTNAME}"

#------------------------------------------------------------------------------ 
# Functions 
#------------------------------------------------------------------------------ 

function Make_VM {
    # Create the VM
    VBoxManage createvm --name "Vulnerable-VM" --register

    # Set memory and CPUs
    VBoxManage modifyvm "Vulnerable-VM" --memory 1024 --cpus 1 --vram 16

    # Set network to internal (intnet) to isolate
    VBoxManage modifyvm "Vulnerable-VM" --nic1 intnet --intnet1 "intnet"

    # Attach the VDI to the VM
    VBoxManage storagectl "Vulnerable-VM" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "Vulnerable-VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdipath"

}
Make_VM