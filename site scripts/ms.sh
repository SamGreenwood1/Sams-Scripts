# header="ms - Change directory to a specific directory.\nUsage: ms [OPTIONS]\nOptions:"
# sites="\t-sc\tChange directory to camp sites directory\n\t-sf\tChange directory to family sites directory\n\t-sip\tChange directory to sites in progress directory\n\t-sp\tChange directory to personal sites directory\n\t-so\tChange directory to other sites directory\n\t-sr\tChange directory to rempah sites directory\n\t-ts\tChange directory to site testing directory"
# apache2="\t-w\t$cdto-statement $a2path\n\t-wl\t$lsin in $a2path\n\t-wt\t$lsin and directories in $a2path
# a2-2="$lsin and contents of $a2path in tree format\n\t-td
# a2path="/var/www"
# cdto-statement="Change directory to"
# lsin="List all files"

getVars() {
    . ~/.help-vars.sh ms
}

printHelp() {
    getVars
    case $1 in
        sites) echo -e "$header\nOptions:\n$sites";;
        www) echo -e "$header\nOptions:\n$apache2";;
        *) echo -e "$header\nOptions:\nwww:\n $apache2\n sites:\n$sites";;
    esac
}

printHelp $1