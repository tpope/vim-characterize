# Converts emoji one's emoji.json into viml syntax, using the power of jq

# Usage:
#      wget https://raw.githubusercontent.com/emojione/emojione/master/emoji.json
#      jq -r -f emojis.jq emoji.json >> characterize.vim

# Convert the list of objects into an array of key/values
to_entries[] |
# Then find all of the emojis described that do not include a -. That indicates
# ZWJ sequences, modifiers, or concatenating characters. None of which this
# plugin supports (yet?)
select( .key | contains("-") | not) |
"      \\ 0x\(.key): \([.value.shortname] + .value.shortname_alternates | tostring),"
