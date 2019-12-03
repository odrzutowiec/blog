function trim(s) {
    sub(/[ \t\r\n]+$/, "", s)
    sub(/^[ \t\r\n]+/, "", s)
    return s
}

