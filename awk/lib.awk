function trim(s) {
    sub(/[ \t\r\n]+$/, "", s)
    sub(/^[ \t\r\n]+/, "", s)
    return s
}

function read(cmd) {
    read_contents = ""
    while (cmd | getline line) {
        read_contents = read_contents "\n" line
    }
    return read_contents
}
