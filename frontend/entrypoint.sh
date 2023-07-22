#!/bin/bash

cd /usr/src/app

check_and_install_packages() {
  while read line
  do
    if yarn list --pattern "$line" > /dev/null; then
      echo $line is EXIST.
    else
      echo $line is NOT EXIST.
      yarn add $line
    fi
  done < /packages.txt
}

case "$STATUS" in
  "installation")
    echo Starting in installation mode...
    echo RUN yarn create next-app .
    bash
    ;;
  "development")
    echo Starting in developer mode...
    check_and_install_packages
    yarn dev
    ;;
  "production")
    echo Starting in production mode...
    check_and_install_packages
    yarn build
    yarn start
    ;;
  *)
    echo Incorrect environment variable.
    ;;
esac
