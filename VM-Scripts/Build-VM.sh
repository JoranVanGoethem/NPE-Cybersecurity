#!/bin/bash

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
# VM-namen
DEBIAN_VM_NAME="vulnerable-debian"
KALI_VM_NAME="attacker-kali"

# Pad naar VDI-bestanden (vervang deze door jouw correcte paden met forward slashes)
DEBIAN_VDI_PATH="../vdi-files/Debian/32bit/32bit/Debian 11 (32bit).vdi"
KALI_VDI_PATH="../vdi-files/Kali/64bit/64bit/Kali Linux 2024.4 (64bit).vdi"


# Naam van het interne netwerk
INTNET_NAME="intnet"

#------------------------------------------------------------------------------ 
# Functions 
#------------------------------------------------------------------------------ 

function create_VM(){
    create_Debian
    create_Kali
}

function create_Debian(){
# === Debian VM ===
VBoxManage createvm --name "$DEBIAN_VM_NAME" --register

VBoxManage modifyvm "$DEBIAN_VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 nat
VBoxManage modifyvm "$DEBIAN_VM_NAME" --cpus 2
VBoxManage modifyvm "$DEBIAN_VM_NAME" --vram 128

# Debian NAT port forwarding: host port 2222 -> guest port 22
VBoxManage modifyvm "$DEBIAN_VM_NAME" --natpf1 "ssh,tcp,127.0.0.1,2222,,22"

# Extra netwerkaart met intnet
VBoxManage modifyvm "$DEBIAN_VM_NAME" --nic2 intnet --intnet2 "$INTNET_NAME"

# Opslag
VBoxManage storagectl "$DEBIAN_VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$DEBIAN_VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$DEBIAN_VDI_PATH"

}

function create_Kali() {
# === Kali VM ===
VBoxManage createvm --name "$KALI_VM_NAME" --register

VBoxManage modifyvm "$KALI_VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 nat
VBoxManage modifyvm "$KALI_VM_NAME" --cpus 2
VBoxManage modifyvm "$KALI_VM_NAME" --vram 128

# Kali NAT port forwarding: host port 2223 -> guest port 22
VBoxManage modifyvm "$KALI_VM_NAME" --natpf1 "ssh,tcp,127.0.0.1,2223,,22"

# Extra netwerkaart met intnet
VBoxManage modifyvm "$KALI_VM_NAME" --nic2 intnet --intnet2 "$INTNET_NAME"

# Opslag
VBoxManage storagectl "$KALI_VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$KALI_VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$KALI_VDI_PATH"

}

create_VM





