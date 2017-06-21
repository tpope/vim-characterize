# Transform UnicodeData.txt for characterize.vim

# Usage:
#     wget http://www.unicode.org/Public/10.0.0/ucd/UnicodeData.txt
#     awk -f unicode.awk < UnicodeData.txt >> characterize.vim
# Delete the old dictionary

BEGIN {
    FS=";"
    printf "\n\" Unicode data dictionary\n"
}

{
    code = $1
    name = $2
    alias = $11
    if (name == "<control>" && length(alias) != 0) {
        name = alias
    }
    printf "let s:d[0x%s]='%s'\n", $1, name
}
