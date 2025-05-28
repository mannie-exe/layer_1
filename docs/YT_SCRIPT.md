# Script for YouTube video


... intro

... git clone

... github

What does this get you?

... one-line importance of version control

... make some changes/additions to the modpack

Now, if we go to GitHub.com, create a new tag, and name it starting with 'v' --

We trigger an automated distribution build.

Before we get into what that means, here are some limitations:
- GitHub CI/Actions usage is available only on public repositories
- Private and Enterprise repositories must pay for GitHub Actions usage

... build artifacts and releases

How does it all work?

... packwiz

... pack/pack.toml as source of truth

Hard requirements right now are a POSIX, so Linux, macOS, or WSL2 environment.

Future plans:

... web GUI for creating modpacks

...

... tips

- git rm (and variations)
- git restore (and variations)
- git status/git diff --porcelain
