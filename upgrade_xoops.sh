#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS
#   Description:
#   Author: 邱顯錫 (Chiou, Hsienhsi)
#   Intro:  https://github.com/xichiou/lamp-xoops
#===============================================================================================

get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}


SEARCH_PATH="/var/www/html"

read -p "請輸入網站目錄: /var/www/html/" SUB_DIR
if [ "$SUB_DIR" != "" ]; then
  SUB_DIR=$(echo $SUB_DIR | sed -e 's/\/$//')
  SEARCH_PATH="$SEARCH_PATH/$SUB_DIR"
fi

echo -e "\n檢查網站目錄 $SEARCH_PATH ..."

if [ ! -f "$SEARCH_PATH/mainfile.php" ]; then
  echo "此目錄沒有 mainfile.php"
  exit 1001
fi

echo -e "\n目前網站版本如下:\n====================="

cd $SEARCH_PATH

XOOPS_ROOT_PATH=$(cat mainfile.php |grep "define('XOOPS_ROOT_PATH'"|cut -d"," -f 2|cut -d"'" -f 2)
echo -e "[設定]XOOPS_ROOT_PATH: \e[32m$XOOPS_ROOT_PATH\e[0m"
if [ $XOOPS_ROOT_PATH != $SEARCH_PATH ]; then
  echo "XOOPS_ROOT_PATH 和實際的網站資料夾不同，可能無法運作!"
  exit 1002
fi


XOOPS_VAR_PATH=$(cat mainfile.php |grep "define('XOOPS_VAR_PATH'"|cut -d"," -f 2|cut -d"'" -f 2)
echo -e "[設定]XOOPS_VAR_PATH: \e[32m$XOOPS_VAR_PATH\e[0m"
XOOPS_PATH=$(cat mainfile.php |grep "define('XOOPS_PATH'"|cut -d"," -f 2|cut -d"'" -f 2)
echo -e "[設定]XOOPS_PATH: \e[32m$XOOPS_PATH\e[0m"

XOOPS_URL=$(cat mainfile.php |grep "define('XOOPS_URL"|sed 's/^[ \t]*//g'|sed -e '/^\/\//d'|grep "define('XOOPS_URL'"|cut -d"," -f 2|cut -d"'" -f 2)
echo -e "[設定]XOOPS_URL: \e[32m$XOOPS_URL\e[0m"

TAD_ADM_VERSION_CURRENT=$(cat modules/tad_adm/xoops_version.php |grep "'version"|cut -d"=" -f 2|cut -d";" -f 1|cut -d"'" -f 2)
echo -e "[模組]站長工具箱 版本: \e[32m${TAD_ADM_VERSION_CURRENT}\e[0m"
TAD_ADM_VERSION_CURRENT=$(echo $TAD_ADM_VERSION_CURRENT|sed 's/\.//g')
TAD_ADM_VERSION_CURRENT=$(($TAD_ADM_VERSION_CURRENT))
if [ $TAD_ADM_VERSION_CURRENT -lt 100 ]
then
    TAD_ADM_VERSION_CURRENT=$(($TAD_ADM_VERSION_CURRENT*10))
fi
#echo $TAD_ADM_VERSION_CURRENT

TADTOOLS_VERSION_CURRNET=$(cat modules/tadtools/xoops_version.php |grep "'version"|cut -d"=" -f 2|cut -d";" -f 1|cut -d"'" -f 2)
echo -e "[模組]tadtools 版本: \e[32m${TADTOOLS_VERSION_CURRNET}\e[0m"
TADTOOLS_VERSION_CURRNET=$(echo $TADTOOLS_VERSION_CURRNET|sed 's/\.//g')
TADTOOLS_VERSION_CURRNET=$(($TADTOOLS_VERSION_CURRNET))
if [ $TADTOOLS_VERSION_CURRNET -lt 100 ]
then
    TADTOOLS_VERSION_CURRNET=$(($TADTOOLS_VERSION_CURRNET*10))
fi
#echo $TADTOOLS_VERSION_CURRNET

XOOPS_VERSION_CURRENT=$(cat include/version.php |grep "'XOOPS_VERSION"|cut -d"," -f 2|cut -d"'" -f 2)
echo -e "[核心]XOOPS: \e[32m${XOOPS_VERSION_CURRENT}\e[0m"
XOOPS_VERSION_CURRENT=$(echo $XOOPS_VERSION_CURRENT|cut -d"." -f 3) #只留下第三個數字
XOOPS_VERSION_CURRENT=$(($XOOPS_VERSION_CURRENT))
#echo $XOOPS_VERSION_CURRENT

echo "按下任一按鍵開始安裝更新...或是按下 Ctrl+C 取消安裝"
char=`get_char`

####################### 進行更新 ########################
TADTOOLS_VERSION=3.26
TADTOOLS_URL="http://120.115.2.90/modules/tad_modules/index.php?op=tufdl&files_sn=1961#tadtools_3.26_20190509.zip"

TAD_ADM_VERSION=2.81
TAD_ADM_URL="http://120.115.2.90/modules/tad_modules/index.php?op=tufdl&files_sn=1962#tad_adm_2.81_20190509.zip"

cd "$XOOPS_ROOT_PATH/modules"

MESSAGE=""
if [ $TAD_ADM_VERSION_CURRENT -lt 281 ]; then
  echo "進行更新[模組]站長工具箱 ==> 2.81"
  echo "下載模組並解開： tad_adm 站長工具箱..."
  if ! [ -f tad_adm_${TAD_ADM_VERSION}.zip ];then
    wget $TAD_ADM_URL -O tad_adm_${TAD_ADM_VERSION}.zip
  fi
  if [ -f tad_adm_${TAD_ADM_VERSION}.zip ];then
    rm -rf tad_adm
    unzip -q tad_adm_${TAD_ADM_VERSION}.zip
    chown -R apache.apache tad_adm
    rm tad_adm_${TAD_ADM_VERSION}.zip
    MESSAGE="$MESSAGE 已經下載[模組]站長工具箱，核心更新後自行從後台進行更新模組\n"
  fi
fi

if [ $TADTOOLS_VERSION_CURRNET -lt 326 ]; then
  echo "進行更新[模組]tadtools 工具包 ==> 3.26"
  echo "下載模組並解開： tadtools 工具包..."
  if ! [ -f tadtools_${TADTOOLS_VERSION}.zip ];then
    wget $TADTOOLS_URL -O tadtools_${TADTOOLS_VERSION}.zip
  fi
  if [ -f tadtools_${TADTOOLS_VERSION}.zip ];then
    rm -rf tadtools
    unzip -q tadtools_${TADTOOLS_VERSION}.zip
    chown -R apache.apache tadtools
    rm tadtools_${TADTOOLS_VERSION}.zip
    MESSAGE="$MESSAGE 已經下載[模組]tadtools 工具包，核心更新後自行從後台進行更新模組\n"
  fi
fi

cd /tmp

if [ ! -f "${XOOPS_ROOT_PATH}/class/xoopsform/renderer/XoopsFormRendererBootstrap4.php" ]; then
  echo "缺少 BootStrap4升級補丁"
  echo "下載更新並解開： BootStrap4升級補丁"
  if ! [ -f bs4_upgrade.zip ];then
    wget 'http://120.115.2.90/modules/tad_modules/xoops.php?op=tufdl&files_sn=1845#bs4_upgrade_20190101.zip' -O bs4_upgrade.zip
  fi
  unzip -q -o bs4_upgrade.zip
  cp -fr htdocs/* ${XOOPS_ROOT_PATH}/
  chown apache.apache ${XOOPS_ROOT_PATH}/class/xoopsform/renderer/XoopsFormRendererBootstrap4.php
  chown apache.apache ${XOOPS_ROOT_PATH}/class/xoopsload.php
  chown apache.apache ${XOOPS_ROOT_PATH}/uploads/bs4_upgrade.txt
  date +"%Y-%m-%d %H:%M:%S" > ${XOOPS_ROOT_PATH}/uploads/xoops_sn_6.txt
fi


if [ $XOOPS_VERSION_CURRENT -lt 9 ]; then
  echo "進行更新[核心]XOOPS  ==> 2.5.9"
  wget "http://120.115.2.90/modules/tad_uploader/index.php?op=dlfile&cfsn=146&cat_sn=16&name=xoopscore25-2.5.9_tw_for_upgrade_20170803.zip" -O xoopscore25-2.5.9_tw_for_upgrade_20170803.zip
  if [ -f xoopscore25-2.5.9_tw_for_upgrade_20170803.zip ];then
    rm -rf XoopsCore25-2.5.9_for_upgrade
    unzip xoopscore25-2.5.9_tw_for_upgrade_20170803.zip
    chown -R apache.apache XoopsCore25-2.5.9_for_upgrade
    cd XoopsCore25-2.5.9_for_upgrade
    rm -rf $XOOPS_ROOT_PATH/modules/system
    cp -rf htdocs/* $XOOPS_ROOT_PATH
    cp -rf xoops_data/* $XOOPS_VAR_PATH
    cp -rf xoops_lib/* $XOOPS_PATH
    chmod 777 $XOOPS_ROOT_PATH/mainfile.php
    chmod 777 $XOOPS_VAR_PATH/data/secure.php
    MESSAGE="${MESSAGE}\n請開啟以下連結進行更新\n ${XOOPS_URL}/upgrade\n\n更新完畢後請自行執行以下指令\n\n"
    MESSAGE="${MESSAGE}chmod 444 $XOOPS_ROOT_PATH/mainfile.php\n"
    MESSAGE="${MESSAGE}chmod 444 $XOOPS_VAR_PATH/data/secure.php\n"
    MESSAGE="${MESSAGE}rm -rf $XOOPS_ROOT_PATH/upgrade\n"
  fi
fi

echo "=========="
echo "執行結果   "
echo "=========="
if [ "$MESSAGE" == "" ]; then
  echo 沒有需要更新的
else
  echo -e $MESSAGE
fi
