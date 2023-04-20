#!/bin/bash
# 解除唯讀模式
sudo steamos-readonly disable
# 刷新pacman(套件管理工具)
sudo pacman -Ssy
# 初始化pacman密鑰
sudo pacman-key --init
# 使用默認的Arch Linux密鑰替代
sudo pacman-key --populate archlinux
# 安裝samba文件分享協定
sudo pacman -S samba --overwrite '*' --noconfirm
# 編寫samba配置文件
echo "
[global]
workgroup = WORKGROUP
server string = Samba Server
server role = standalone server

[Homes]
comment = Home Directories
browseable = no
writable = yes

[Steam]
path = /home/deck/.local/share/Steam
writable = yes

[GAME_Folder]
path = /home/deck/.local/share/Steam/steamapps/common
writable = yes

[Mount_Point]
path = /run/media
writable = yes

#要再新增共享資料夾，可以依如下格式以及範例(使用時#符號要刪掉)
#[自己取資料夾名稱]
#path = 資料夾路徑
#writable = yes

#[Screenshot]
#path = /home/deck/.local/share/Steam/userdata/用戶名/760/remote
#writable = yes

#[Userdata]
#path = /home/deck/.local/share/Steam/userdata/用戶名
#writable = yes

#[Compatdata]
#path = /home/deck/.local/share/Steam/steamapps/compatdata
#writable = yes

" | sudo tee /etc/samba/smb.conf
# 安裝yay軟件儲存庫助手
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay-bin.git
chmod a+rwx yay-bin
cd yay-bin
makepkg -si --noconfirm
# 更新yay
yay --noconfirm
# 安裝wsdd 網路探索服務
yay -S wsdd --overwrite '*' --noconfirm
# 刪除yay暫存檔
cd ..
rm -rf yay-bin
# 新增使用者 deck 為 SteamDeck 默認的使用者名稱
echo "替Samba用戶“deck“設置新密碼"
sudo smbpasswd -a deck
# 啟動samba服務，並設定自啟
echo "啟用文件分享服務，要求用戶權限"
systemctl start smb
echo "設置文件分享協定自啟，要求用戶權限"
systemctl enable smb
# 啟動wsdd服務，並設定自啟
echo "啟用網路探索服務，要求用戶權限"
systemctl start wsdd
echo "設置網路探索自啟動，要求用戶權限"
systemctl enable wsdd
# 重啟唯讀模式
sudo steamos-readonly enable
echo "samba文件分享協定已設定完成，可以關閉終端機"
