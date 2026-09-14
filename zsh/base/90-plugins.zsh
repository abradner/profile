# zsh-autosuggestions, then zsh-syntax-highlighting, which must be the last
# thing sourced because it wraps every widget defined before it. Found
# wherever apt, Homebrew or a git clone put them; skipped if absent.
for _profile_p in zsh-autosuggestions zsh-syntax-highlighting; do
  for _profile_f in \
    /usr/share/$_profile_p/$_profile_p.zsh \
    /opt/homebrew/share/$_profile_p/$_profile_p.zsh \
    /usr/local/share/$_profile_p/$_profile_p.zsh \
    ${ZSH_CUSTOM:-$ZSH/custom}/plugins/$_profile_p/$_profile_p.zsh \
    $HOME/.zsh/$_profile_p/$_profile_p.zsh
  do
    [[ -r $_profile_f ]] && { source $_profile_f; break; }
  done
done
unset _profile_p _profile_f
