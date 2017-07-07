#!/bin/bash

Cyan='\033[0;36m'
Default='\033[0;m'

commite=""
confirmed="n"

getCommite() {
    read -p "请输入描述: " commite

    if test -z "$commite"; then
        getCommite
    fi
}

getInfomation() {
getCommite

echo -e "\n${Default}================================================"
echo -e "  commite  :  ${Cyan}${commite}${Default}"
echo -e "================================================\n"
}

echo -e "\n"
getInfomation

git config user.name qcyl
git config user.mail 365034037@qq.com
git add .
git commit -m $commite
git push origin master
say "finished"
echo "finished"
