D=$'\e[37;40m'
PINK=$'\e[35;40m'
GREEN=$'\e[32;40m'
ORANGE=$'\e[33;40m'

# https://bitbucket.org/gward/vcprompt
vc_ps1() {
    vcprompt -f "(%s:${PINK}%b${D}${GREEN}%i${D})" 2>/dev/null
}

export PS1='${GREEN}\u@\h${D} in ${ORANGE}\w$(vc_ps1)${D}\n$ '
