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
    var_name = trim(substr($0, 3, RSTART-3))
    var_value = trim(substr($0, RSTART+1))
    meta_vars[var_name] = var_value
}

END {
    for (x in meta_vars) {
        gsub("\"", "\\\"", meta_vars[x])
        print x "=" "\"" meta_vars[x] "\""
    }
    all_vars=""
    for (x in meta_vars) {
        if (all_vars != "") 
            all_vars = all_vars "," x
        else 
            all_vars = x
    }
    print "_all=" all_vars
}
