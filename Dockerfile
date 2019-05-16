FROM node:12

LABEL "com.github.actions.name"="Deploy to GitHub Pages"
LABEL "com.github.actions.description"="This action will handle the building and deploying process of your project to GitHub Pages."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

LABEL "repository"="https://github.com/passcod/github-pages-deploy-action"
LABEL "homepage"="https://github.com/passcod/github-pages-deploy-action"
LABEL "maintainer"="Félix Saparelli <felix@passcod.name>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git
RUN npm i -g npm yarn pnpm

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
