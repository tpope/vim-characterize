# Transform UnicodeData.txt for characterize.vim

BEGIN { FS=";" }

{
    code = $1
    name = $2
    alias = $11
    if (name == "<control>" && length(alias) != 0) {
        name = alias
    }
    printf "let s:d[0x%s]='%s'\n", $1, name
}
