## How to use

1. Update servers.json to your git server urls.
2. `./import_on_unix.sh srcrepos distrepos`

If you want to import a repository from `ssh://localserver/repos/sample_local.git` to `github.com/developer-kikikaikai/sample_github.git`, update `servers.json` as 

```
{
        "src": "ssh://localserver/repos",
        "dist": "git@github.com:developer-kikikaikai"
}
```

and call `./import_on_unix.sh sample_local.git sample_github.git`

## What to do

Please see [here](https://qiita.com/developer-kikikaikai/items/b9e4fe4337bae3eab01b) if you want to know an overview of steps.
