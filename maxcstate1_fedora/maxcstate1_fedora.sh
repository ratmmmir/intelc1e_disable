#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script needs to be run with sudo."
    exit 1
fi

cat << "EOF"
  _____ __ ______ ______ _____ _  __
 / ____/_ |  ____|  ____/ ____| |/ /
| |     | | |__  | |__ | |    | ' / 
| |     | |  __| |  __|| |    |  <  
| |____ | | |____| |   | |____| . \ 
 \_____||_|______|_|    \_____|_|\_\
 
EOF

echo This script contributes the intel_idle.max_cstate=1 parameter to
echo /etc/default/grub.d/intel_idle_states_off.cfg
echo and
echo /etc/default/grub
echo to disable intel c1e
read -p "continue? (y/n): " user_input

if [[ $user_input != "y" && $user_input != "Y" ]]; then
    echo "exit..."
    exit 0
fi



#Создание /etc/default/grub.d/intel_idle_states_off.cfg
GRUB_D_PATH="/etc/default/grub.d"
GRUB_FILE="$GRUB_D_PATH/intel_idle_states_off.cfg"

echo "Updating $GRUB_FILE..."

# Создаём директорию если её нет
if [[ ! -d $GRUB_D_PATH ]]; then
    echo "Creating $GRUB_D_PATH..."
    mkdir -p $GRUB_D_PATH
fi

# Запись строки в файл
echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX intel_idle.max_cstate=1"' > "$GRUB_FILE"

echo "$GRUB_FILE file was successfully updated!"

# Изменение /etc/default/grub
GRUB_DEFAULT_FILE="/etc/default/grub"
GRUB_CMDLINE_LINUX_PATTERN='GRUB_CMDLINE_LINUX='

echo "Updating $GRUB_DEFAULT_FILE..."

if [[ -f $GRUB_DEFAULT_FILE ]]; then
    # Проверяем intel_idle.max_cstate=1
    if grep -q 'intel_idle.max_cstate=1' "$GRUB_DEFAULT_FILE"; then
        echo "intel_idle.max_cstate=1 already exists in $GRUB_DEFAULT_FILE."
    else
        # Добавляем параметр к строке GRUB_CMDLINE_LINUX
        sed -i "/^$GRUB_CMDLINE_LINUX_PATTERN/ s/\"\$/ intel_idle.max_cstate=1\"/" "$GRUB_DEFAULT_FILE"
        echo "intel_idle.max_cstate=1 successfully added in $GRUB_DEFAULT_FILE!"
    fi
else
    echo "$GRUB_DEFAULT_FILE eror"
    exit 1
fi

# update-grub
echo "updating Grub..."
grub2-mkconfig -o /boot/grub2/grub.cfg

if [[ $? -eq 0 ]]; then
    echo "grub config successfully updated! pls reboot."
else
    echo "Eror GRUB update."
    exit 1
fi

echo "Done."
