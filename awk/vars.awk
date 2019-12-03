BEGIN {
    mode = "normal"
}

NR==1 && /^\/\// {
    mode = "meta"
}

mode=="meta" && !/^\/\// {
    mode = "normal"
}

mode=="meta" && /^\/\// {
    match($0, /:/)
    meta_vars[trim(substr($0, 3, RSTART-3))] = trim(substr($0, RSTART+1))
}

END {
    for (x in meta_vars) print x "=" meta_vars[x]
}
