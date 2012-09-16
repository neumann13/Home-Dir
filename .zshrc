export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:~/bin

#Prompt
PROMPT='%{%f%k%b%}
%{%K{black}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{black}%}%~%{%B%F{green}%}%E%{%f%k%b%}
%{%K{black}%}%{%K{black}%} %#%{%f%k%b%} '

RPROMPT='!%{%B%F{cyan}%}%!%{%f%k%b%}'

# Disable core dumps
limit -s coredumpsize 0

# man umask
# umask 002 # relaxed   -rwxrwxr-x
# umask 022 # cautious  -rwxr-xr-x
# umask 027 # uptight   -rwxr-x---
# umask 077 # paranoid  -rwx------
# umask 066 # bofh-like -rw-------
umask 0027

# If root set unmask to 022 to prevent new files being created group and world writable
if (( EUID == 0 )); then
	umask 022
fi

# General
# 
# ALWAYS_TO_END - Place cursor at end when completion has one match.
# NO_BEEP - No beep when completing
# CLOBBER - Allows > redirection to truncate existing files, and >> to create files.
# AUTO_CD - CD if a command is not in the hash table, and there exists an executable directory by that name.
# CD_ABLE_VARS - Automatically complete non-matching directories to parameters of the same name.
# MULTIOS - Perform implicit tees or cats when multiple redirections are attempted.
# CORRECT_ALL - Try to correct the spelling of all arguments in a line. 
setopt   ALWAYS_TO_END NO_BEEP CLOBBER
setopt   AUTO_CD CD_ABLE_VARS MULTIOS CORRECT_ALL

# Job Control
# CHECK_JOBS - report status of bg-jobs if exiting a shell with job control enabled
# NO_HUP - Background jobs won't exit when the shell terminates.
setopt   CHECK_JOBS NO_HUP

# Display directory in terminal title bar
chpwd() {
	[[ -o interactive ]] || return
	case $TERM in
		sun-cmd) print -Pn "\e]l%~\e\\" ;;
		*xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%~\a" ;;
	esac
}

# History
# INC_APPEND_HISTORY - Append as commands are executed instead of when the shell exits.
# EXTENDED_HISTORY - Also save time the command started and its run time.
# HIST_IGNORE_DUPS - Don't add history when previous line is identical.
# HIST_FIND_NO_DUPS - Backwards won't show duplicates more than once.
setopt   INC_APPEND_HISTORY EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

# HIST_EXPIRE_DUPS_FIRST - Duplicates are purged from history first when it fills.
# HIST_SAVE_NO_DUPS - Never save duplicate lines.
# HIST_REDUCE_BLANKS - Trim insignificant blanks when saving history.
setopt	 HIST_EXPIRE_DUPS_FIRST HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# notify - Report the status of background jobs immediately rather than waiting until just before printing a prompt.
# globdots - Do not require a leading . in a filename to be matched explicitly.
# pushdtohome - Have pushd with no arguments act like pushd $HOME. 
setopt   notify globdots pushdtohome

# recexact - causes exact matches to be accepted even if there are other possible completions.
# longlistjobs - List jobs in the long format by default.
setopt   recexact longlistjobs

# autoresume - Treat single word simple commands without redirection as candidates for resumption of an existing job.
# pushdsilent - Do not print the directory stack after pushd or popd. 
setopt   autoresume pushdsilent

# autopushd - Make cd push the old directory onto the directory stack. 
# pushdminus - Swap the meaning of cd +1 and cd -1
# extendedglob - Treat the #, ~ and ^ characters as part of patterns for filename generation.
# rcquotes - Allow the character sequence '' to signify a single quote within singly quoted strings.
# mailwarning - Print a warning message if a mail file has been accessed since the shell last checked.
setopt   autopushd pushdminus extendedglob rcquotes mailwarning

# BG_NICE - Run all background jobs at a lower priority.
# autoparamslash - If a parameter is completed whose content is the name of a directory, then add a trailing slash.
unsetopt BG_NICE HUP autoparamslash

# Don't expand files matching:
fignore=(.o .c~ .old .pro .part .bak .BAK \~)

# VIM. Yes.
export EDITOR=vim

# Unicode Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#Aliases
alias vi='/usr/local/bin/vim'
alias v0flac='mkdir -p V0 && for file in *.flac; do $(flac -cd "$file" | lame -V0 --vbr-new - "V0/${file%.flac}.mp3"); done'
alias rm='rm -I'

# Disable file operations spelling correction
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias sl='nocorrect sl'
alias mkdir='nocorrect mkdir'

# Rehash zsh's list of known programs every time, to prevent situations
# where a new program is installed and existing shells don't recognize it.
# Do note the slight performance penalty.
_force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1
}
zstyle ':completion:::::' completer _force_rehash _complete _approximate

# Create and cd into an arbitrary tree
mkcd () {
	mkdir -p "$*"
	cd "$*"
}

# Easier archive extraction
extract () {
	if [ -f $1 ] ; then
		case $1 in
		*.7z)		p7zip -d $1   ;;
		*.tar.bz2)	tar xvjf $1   ;;
		*.tar.gz)	tar xvzf $1   ;;
		*.bz2)		bunzip2 $1   ;;
		*.rar)		unrar x $1   ;;
		*.gz)		gunzip $1   ;;
		*.tar)		tar xvf $1   ;;
		*.tbz2)		tar xvjf $1   ;;
		*.tgz)		tar xvzf $1   ;;
		*.zip)		unzip $1   ;;
		*.Z)		uncompress $1   ;;
		*)			echo "'$1' cannot be extracted via extract()" ;;
	esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Pipe to "pastebin" to send text to sprung.us
alias pastebin="curl -F 'sprunge=<-' http://sprunge.us"

# 'ls' colourization
export LSCOLORS="Gxfxcxdxbxegedabagacad"
autoload colors; colors;
# Enable ls colors unless explicitly disabled by the user.
if [ "$DISABLE_LS_COLORS" != "true" ]; then
	# Find the option for using colors in ls, depending on the version: Linux or BSD
	# Thanks to oh-my-zsh for this!
	ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format '%d:'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' prompt 'Alternatives %e:'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#autocomplete command line switches for aliases
setopt completealiases

#show only results from history
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Load other modules
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -ap zsh/mapfile mapfile

# Proper settings for various terminal types
case "$TERM" in
        linux)
                bindkey '\e[1~' beginning-of-line       # Home
                bindkey '\e[4~' end-of-line             # End
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert
                ;;
        screen)
                # In console
                bindkey '\e[1~' beginning-of-line       # Home
                bindkey '\e[4~' end-of-line             # End
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert
                bindkey '\e[7~' beginning-of-line       # home
                bindkey '\e[8~' end-of-line             # end
                # In rxvt
                bindkey '\eOc' forward-word             # ctrl cursor right
                bindkey '\eOd' backward-word            # ctrl cursor left
                bindkey '\e[3~' backward-delete-char    # This should not be necessary!
                ;;
        rxvt*)
                bindkey '\e[7~' beginning-of-line       # home
                bindkey '\e[8~' end-of-line             # end
                bindkey '\eOc' forward-word             # ctrl cursor right
                bindkey '\eOd' backward-word            # ctrl cursor left
                bindkey '\e[3~' backward-delete-char    # This should not be necessary!
                bindkey '\e[2~' overwrite-mode          # Insert
                ;;
        xterm*)
                bindkey "\e[1~" beginning-of-line       # Home
                bindkey "\e[4~" end-of-line             # End
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert
                ;;
        sun)
                bindkey '\e[214z' beginning-of-line        # Home
                bindkey '\e[220z' end-of-line                    # End
                bindkey '^J'      delete-char                    # Del
                bindkey '^H'      backward-delete-char  # Backspace
                bindkey '\e[247z' overwrite-mode                  # Insert
                ;;
esac

#Comment
