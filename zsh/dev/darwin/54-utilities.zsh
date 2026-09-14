# Inode usage per top-level directory (needs GNU find: brew install findutils).
alias file_count='echo "Detailed Inode usage for: $(pwd)" ; for d in `gfind -maxdepth 1 -type d |cut -d/ -f2 |grep -xv . |sort`; do c=$(find $d |wc -l) ; printf "$c\t\t- $d\n" ; done ; printf "Total: \t\t$(find $(pwd) | wc -l)\n"'

# Homebrew rsync: macOS's bundled rsync lacks --info=progress2.
[[ -x /opt/homebrew/bin/rsync ]] && alias async='/opt/homebrew/bin/rsync -az --info=progress2'
