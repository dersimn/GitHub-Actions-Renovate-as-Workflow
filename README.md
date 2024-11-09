
## Clean Testing

For clean testing, re-create the Repository on GitHub when it gets to polluted with Tags and Releases:

    gh repo delete --yes
    gh repo create --public ${${$(git remote get-url origin)##*/}%.git}

    gh secret set RENOVATE_TOKEN --body '<TOKEN>'

    git tag | xargs git tag -d
    git push -u origin master
