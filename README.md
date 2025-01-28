# Workshop Better Together

## Base VM

The base Minecraft VM for all tasks is based on qemu and can be built using the packer build
in the folder `./vms/ubuntu_base`.

```bash
cd vms/ubuntu_base
packer build main.pkr.hcl
```