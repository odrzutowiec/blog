BEGIN {
    env = "none";
    text = "";
}

# comments
/^\/\// {
    next;
}

# images
/^!\[.+\] *\(.+\)/ {
    split($0, a, /\] *\(/);
    split(a[1], b, /\[/);
    imgtext = b[2];
    split(a[2], b, /\)/);
    imgaddr = b[1];
    print "<img src=\"" imgaddr "\" alt=\"" imgtext "\" title=\"\" />\n";
    text = "";
    next;
}

# links
/\] *\(/ {
    do {
        na = split($0, a, /\] *\(/);
        split(a[1], b, "[");
        linktext = b[2];
        nc = split(a[2], c, ")");
        linkaddr = c[1];
        text = text b[1] "<a href=\"" linkaddr "\">" linktext "</a>" c[2];
        for(i = 3; i <= nc; i++)
            text = text ")" c[i];
        for(i = 3; i <= na; i++)
            text = text "](" a[i];
        $0 = text;;
        text = "";
    }
    while (na > 2);
}

# code
/`/ {
    while (match($0, /`/) != 0) {
        if (env == "code") {
            sub(/`/, "</code>");
            env = pcenv;
        }
        else {
            sub(/`/, "<code>");
            pcenv = env;
            env = "code";
        }
    }
}

# emphesis
/_/ {
    while (match($0, /_/) != 0) {
        if (env == "em") {
            sub(/_/, "</em>");
            env = peenv;
        }
        else {
            sub(/_/, "<em>");
            peenv = env;
            env = "em";
        }
    }
}

# strong
/\*\*/ {
    while (match($0, /\*\*/) != 0) {
        if (env == "strong") {
            sub(/\*\*/, "</strong>");
            env = peenv;
        }
        else {
            sub(/\*\*/, "<strong>");
            peenv = env;
            env = "strong";
        }
    }
}

# headers
/^# */ {
    match($0, /#+/);
    n = RLENGTH;
    if(n > 6)
        n = 6;
    print "<h" n ">" substr($0, RLENGTH + 2) "</h" n ">\n";
    next;
}

# unordered lists
/^[*-+]/ {
    if (env == "none") {
        env = "ul";
        print "<ul>";
    }
    print "<li>" substr($0, 3) "</li>";
    text = "";
    next;
}

# ordered lists
/^[0-9]./ {
    if (env == "none") {
        env = "ol";
        print "<ol>";
    }
    print "<li>" substr($0, 3) "</li>";
    next;
}

# parahraphs
/^[ t]*$/ {
    if (env != "none") {
        if (text)
            print text;
        text = "";
        print "</" env ">\n";
        env = "none";
    }
    if (text)
        print "<p>" text "</p>\n";
    text = "";
    next;
}

# text
// {
    text = text " " $0;
}

END {
    if (env != "none") {
        if (text)
            print text;
        text = "";
        print "</" env ">\n";
        env = "none";
    }
    if (text)
        print "<p>" text "</p>\n";
    text = "";
}
