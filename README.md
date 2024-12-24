# intelc1e_disable
# Disable intel c-state c1e for Linux.

When you use an intel cpu with **LGA 771 socket** (e.g. an Intel Xeon E5450) in a **LGA 775 socket** via sticker mod, often you need to disable **intel c-state c1e** in **BIOS**, otherwise you could get a very laggy os, or worst, stuck at the very initial os booting time. This can happen with any os such as Debian, Windows ecc...

Also, disabling c1e helps to solve the problem of loud throttles on **Lenovo Legion** laptops with intel.

Unfortunately BIOSes often lack the option to disable intel c-state c1e.

A workaround is to disable c-states at os level.

I used the c1e disconnect to solve a loud throttle on my laptop. Tested on **Grub2** on **Mint**, **Debian**, **Ubuntu** and **Fedora** distributions.

Original author: @KeyofBlueS

## Grub

With any Linux distro that uses **grub** bootloader, it's easy as just passing the kernel option **intel_idle.states_off=4** to **grub**.

> [!IMPORTANT]
> From the documentation of **intel_idle driver**, `intel_idle.states_off` seems to be the preferred way to disable idle states. If it doesn't work for you, try with `intel_idle.max_cstate=1` instead.

### intel_idle_states_off.cfg

If your distro has the ability to source local grub cfg files, this method is recommended, as the changes will survive grub upgrades

1. Add the file **/etc/default/grub.d/intel_idle_states_off.cfg**:

`sudo nano /etc/default/grub.d/intel_idle_states_off.cfg`

2. Add the following line:

    `GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX intel_idle.states_off=4"`

    Or if it doesn't work change to:

    `GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX intel_idle.max_cstate=1"`

3. Press `CTRL+O` then `ENTER` to save the file and `CTRL+X` then `ENTER` to exit.

4. Then update grub config:

    `sudo update-grub`

> [!NOTE]
> For Fedora and other **distros without the update-grub script**
> use `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

5. Reboot system: `reboot`

6. Done.

### Method 2 /etc/default/grub

> [!IMPORTANT]
> Grub upgrades could overwrite this configuration (however the user is asked whether to keep the current configuration or use the new one). In this case you need to do this step again before rebooting, otherwise you'll need to start from **At boot time** step.

1. Edit the file **/etc/default/grub** as **root**:

   `sudo nano /etc/default/grub`

2. Go down to the line that starts with **GRUB_CMDLINE_LINUX**. At the end of this line add **intel_idle.states_off=4** or **intel_idle.max_cstate=1**:

    `GRUB_CMDLINE_LINUX="intel_idle.states_off=4"`
    
     Or if it doesn't work:
     
     `GRUB_CMDLINE_LINUX="intel_idle.max_cstate=1"`

3. Save snd exit.

4. Update grub config.

5. Done.
