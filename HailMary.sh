pvecm status


echo "If  the above says it is expecting 2 for quorum  and only 1 host is online you will have to run pvecm expected 1"

echo "if you choose to run the pvecm expected look at the official documentation for reprucussions"
echo "This script shoul only be ran if the other node is offline"

read -p  "Press enter if you understand this script should be ran as a last resort" -s

#move all configuration files to the current node
mv /etc/pve/nodes/pvebackup/qemu-server/*.conf /etc/pve/nodes/proxmox-1/qemu-server/

startVirtualMachines=0
oldVirtualMachines=0
while read line
do
#match any line with pvebackup and 3 digits in it then output the first 4 charcters
#note you may have to change this if the file structure is changed
##****This will also be changed if there is more than one backup proxmox**##
if echo "$line"| grep -q '[0-9]\{3\}*pvebackup'; then
        test=$(echo "$line"| grep '[0-9]\{3\}*pvebackup')
        id=$(echo $test | awk '{print substr($0,2,3)}'
        startVirtualMachines=$((startVirtualMachines+1))
        qm start $id
else
        #Use the variable declared above to keep track of any virtual machines that may be old
        oldVirtualMachines=$((oldVirtualMachines+1))
fi

done < /etc/pve/.vmlist

#sumarize what we did
echo "We found $oldVirtualMachines old virtual machines please check /etc/pve/.vmlist"
echo "We started $startVirtualMachines virtual machines"
echo "You have now completed the neccessarry Hail Mary procedure,we wish you luck"
