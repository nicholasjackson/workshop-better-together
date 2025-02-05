# Workshop Better Together

## Base VM

The base Minecraft VM for all tasks is based on qemu and can be built using the packer build
in the folder `./vms/ubuntu_base`.

```bash
cd vms/ubuntu_base
packer build main.pkr.hcl
```

## File Structure

* `src/final`: Contains the final version of the workshop tasks source code.
* `src/working`: Contains the working directory for the workshop, this is the starting
  point for the workshop. It is expected that the students will modify this directory.
* `jumppad/docs`: Contains the documentation for the workshop.
* `vms`: Contains the packer build files for the base VMs and Infrastructure VMs.
* `Dockerfile`: Contains the Dockerfile for the workshop vscode editor.