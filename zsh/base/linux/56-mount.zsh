# Mount helpers for a desktop/login user with sudo. Note `mount` with no
# arguments also prompts for a password - expected.
if (( EUID != 0 && $+commands[sudo] )); then
  alias mount='sudo mount'
  alias umount='sudo umount'

  # Quick-mount a block device by name: qm sda1
  qm() {
    [[ -n $1 ]] || { echo "usage: qm <block-device-name>"; return 2; }
    [[ -b /dev/$1 ]] || { echo "no such block device: /dev/$1"; return 1; }
    mkdir -p "/tmp/$1" && sudo mount "/dev/$1" "/tmp/$1" && builtin cd "/tmp/$1"
  }
fi
