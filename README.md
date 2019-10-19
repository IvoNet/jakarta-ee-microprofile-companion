# Jakarta EE - Microprofile - Workshop

This project is the companion project to [this](https://github.com/ederks85/jakarta-ee-microprofile-workshop) workshop.

It contains material we need to make the workshop a success.

like:

* Docker images
* Virtual Machine
* USB-stick scripts
* Etc.

 
# Usage

* Please follow [these](http://ivo2u.nl/oI) instructions to get it all to work.


## Build VM

To build your own version of this Virtual Machine you need to have 
Vagrant and VirtualBox installed and then:

```bash
cd VM/jakartaee-microprofile-box
vagrant up
# or run the script:
./instance.sh 
```

That will create the whole vm.

## Resizing the disk space

Vagrant delivers virtual machines with a default size of 10Gb which is a bit sparse for this
VM so to resize it to 15Gb:

```bash
cd VM/jakartaee-microprofile-box
./resize-vm.sh
```

If you want to have a bigger size just the "VM_SIZE" variable in the script to to a number
calulated this way: <Wanted GB> * 1024 => e.g. 15 * 1024 = 15360

## Exporting the VM for distribution

The `export.sh` script will give you a good idea on how to export the vm through the command line.
This script will do more though as it will also try to zip and upload the file to google drive.
The upload will fail probably...
