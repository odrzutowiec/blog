// date: Wed Dec  4 00:52:29 CET 2019

# odrzutowiec/blog
Hello welcome to my blog.

#### Hello world - Wed Dec  4 00:49:05 CET 2019
This is the first entry. I made today significant progress with my blog tech.

* `make deploy` prepares a new `gh-pages` branch commit and pushes it to github
* `awk/lib.awk` will be a common place for all shared awk functions
* `make build` supports now parsing markdown meta variables (disabled until useful)
* `make test` runs `make build` and automatically opens the browser. Super convenient especially when running `:!make test` in vim.

I'm very happy with this but it's 1am and I really need to get some rest.

#### Wed Dec  4 23:49:47 CET 2019
No time for updates. That unfortunately means no serious progress in the blog tech. I only improved the `make deploy` so that it commit file delete changes. It had a bug where it would commit previous file again even if it was deleted in the new version.
