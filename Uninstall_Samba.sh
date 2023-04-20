#!/bin/bash
# 解除唯讀模式
sudo steamos-readonly disable
echo "關閉網路探索服務，要求用戶權限"
systemctl stop wsdd
echo "關閉文件分享服務，要求用戶權限"
systemctl stop smb
# 卸載網路探索服務
yes | sudo pacman -R wsdd
# 卸載yay軟件儲存庫助手
yes | sudo pacman -R yay-bin
# 卸載samba文件分享協定
yes | sudo pacman -R samba
# 移除samba配置文件
sudo rm -rf /etc/samba
# 重啟唯讀模式
sudo steamos-readonly enable
echo "samba文件分享協定刪除完成，可以關閉終端機"
