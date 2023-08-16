#!/bin/bash

cd /usr/src/app

install_packages() {
  while read line
  do
    result=$(yarn list --pattern "$line")

    if echo "$result" | grep -q "$line"; then
      echo "$line" is EXIST.
    else
      echo "$line" is NOT EXIST.
      yarn add "$line"
    fi
  done < /packages.txt
}

uninstall_removed_packages() {
  if [ -f .current_packages.txt ]; then
    while read -r package; do
      if ! grep -q "^$package$" /packages.txt; then
        echo "$package" is NOT in packages.txt.
        yarn remove "$package"
      fi
    done < .current_packages.txt
  fi
}

case "$STATUS" in
  "installation")
    echo Starting in installation mode...
    echo Please execute the command below
    echo docker compose exec frontend yarn create next-app .
    bash
    ;;
  "development")
    echo Starting in developer mode...
    install_packages
    uninstall_removed_packages
    cp /packages.txt /usr/src/app/.current_packages.txt
    yarn dev
    ;;
  "production")
    echo Starting in production mode...
    install_packages
    uninstall_removed_packages
    cp /packages.txt /usr/src/app/.current_packages.txt
    yarn build
    yarn start
    ;;
  *)
    echo Incorrect environment variable.
    ;;
esac
