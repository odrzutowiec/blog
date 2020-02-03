BEGIN {
    posts = 0
    while ("ls -m -1 src/posts" | getline file) {
        files[posts] = file
        posts++
    }
    for (i=0;i<posts;i++) {
        contents = contents "\n" read("cat src/posts/" files[i])
    }
    template = read("cat src/template.html")
    sub("{{contents}}", contents, template)
    print template
}
