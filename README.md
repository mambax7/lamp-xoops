## 這個專案設計的自動化腳本，幫助你把一部剛安裝好 CentOS 7 作業系統的主機，快速的安裝成 LAMP 網頁伺服器，和裝好 XOOPS 架站軟體，特色如下：

* 操作過程簡單，只要複製、貼上和輸入資料
* 關閉 root 直接登入 sshd 服務
* 自動更新系統
* 自動校時
* 使用 Google 雲端硬碟備份資料庫和網頁
* 提供網路芳鄰分享資料夾，方便你管理伺服器裡面的檔案

<br/>

## 操作步驟：
### 1. 下載自動化腳本：使用 putty 軟體遠端登入伺服器，切換成 root 最高權限，複製以下指令貼到 putty 軟體內

    yum install -y unzip wget
    wget --no-check-certificate https://github.com/xichiou/lamp-xoops/archive/master.zip -O lamp-xoops.zip
    unzip -o lamp-xoops.zip
    cd lamp-xoops-master/
    chmod +x *.sh;

### 2. 安裝 LAMP 網頁伺服器

    ./lamp.sh

### 3. 安裝 XOOPS 架站軟體

    ./xoops.sh

### 註：步驟 2 安裝 LAMP 網頁伺服器過程中，讓 Grive 可以存取 Google Drive 同步資料庫到雲端，你需要開啟 Google 帳號認證

![grive -a](https://github.com/xichiou/lamp-xoops/blob/master/images/grive-a.png)

    登入 Gmail，驗證 Grive，取得授權碼，再貼回上圖

![允許](https://github.com/xichiou/lamp-xoops/blob/master/images/grive_auth.png)
![取得授權碼](https://github.com/xichiou/lamp-xoops/blob/master/images/grive_auth-2.png)


