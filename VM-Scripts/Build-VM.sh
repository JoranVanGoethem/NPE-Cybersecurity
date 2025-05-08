#!/bin/bash

# Variables
DEBIAN_VM_NAME="vulnerable-debian"
KALI_VM_NAME="attacker-kali"
DEBIAN_VDI_PATH=""    # Pas dit aan naar je echte pad
KALI_VDI_PATH=""         # Pas dit aan naar je echte pad

# Maak de Debian VM aan
VBoxManage createvm --name "$DEBIAN_VM_NAME" --register
VBoxManage modifyvm "$DEBIAN_VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 nat
VBoxManage storagectl "$DEBIAN_VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$DEBIAN_VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$DEBIAN_VDI_PATH"

# Maak de Kali VM aan
VBoxManage createvm --name "$KALI_VM_NAME" --register
VBoxManage modifyvm "$KALI_VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 nat
VBoxManage storagectl "$KALI_VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$KALI_VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$KALI_VDI_PATH"