FROM node:12

LABEL "com.github.actions.name"="Deploy to GitHub Pages"
LABEL "com.github.actions.description"="This action will handle the building and deploying process of your project to GitHub Pages."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/passcod/github-pages-deploy-action"
LABEL "homepage"="https://github.com/passcod/github-pages-deploy-action"
LABEL "maintainer"="Félix Saparelli <felix@passcod.name>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
