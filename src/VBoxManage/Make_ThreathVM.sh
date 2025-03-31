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

vdipath = "/path/to/kali-vdi.vdi"

#------------------------------------------------------------------------------ 
# Provision server 
#------------------------------------------------------------------------------ 
log "Starting server specific provisioning tasks on ${HOSTNAME}"

#------------------------------------------------------------------------------ 
# Functions 
#------------------------------------------------------------------------------ 

function Make_VM {
    # Create the Kali Linux VM
    VBoxManage createvm --name "Kali-VM" --register

    # Set memory and CPUs
    VBoxManage modifyvm "Kali-VM" --memory 2048 --cpus 2 --vram 16

    # Set network to internal (intnet) for the attack VM
    VBoxManage modifyvm "Kali-VM" --nic1 intnet --intnet1 "intnet"

    # Attach the Kali Linux VDI
    VBoxManage storagectl "Kali-VM" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "Kali-VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdipath"

}

Make_VM