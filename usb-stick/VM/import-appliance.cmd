@echo off
SET version=%1
if "%version%"=="" (
   echo "Please provide the version part (e.g. 1.0) from the ova file you downloaded"
   echo "E.g. import-appliance 1.0"
   goto quit
)

echo "Configuring host-only network with specific ip addresses..."
for /f "tokens=6" %%a IN ('VBoxManage hostonlyif create ^| findstr Interface') DO set myvar=%%a
if "%myvar:~0,1%"=="#" (
   set network_interface=VirtualBox Host-Only Ethernet Adapter %myvar:~0,-1%
) ELSE (
   set network_interface=VirtualBox Host-Only Ethernet Adapter
)
echo "Network: %network_interface%"
VBoxManage hostonlyif ipconfig "%network_interface%" --ip 192.168.10.1 --netmask 255.255.255.0
VBoxManage dhcpserver add --ifname "%network_interface%" --ip 192.168.10.2 --netmask 255.255.255.0 --lowerip 192.168.10.100 --upperip 192.168.10.200 --enable
echo "The configured network to use is: %network_interface%"

SET VM_NAME=jakartaee-microprofile-box
VBoxManage import "jakartaee-microprofile-box_v%version%.ova" --vsys 0 --vmname %VM_NAME% --options keepnatmacs
VBoxManage modifyvm %VM_NAME% --nic2 hostonly --hostonlyadapter2 "%network_interface%"
VBoxManage startvm ${VM_NAME} --type headless
goto quit
:quit
