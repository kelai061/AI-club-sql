@echo off
chcp 65001 >nul
title QQ-SQL 一键提交与同步至 Git

echo ========================================================
echo   正在自动提交本地知识库更改至 Git...
echo ========================================================

cd /d "%~dp0"

git add .
git commit -m "update: sync knowledge base notes (%date% %time%)"

echo.
git remote | findstr "origin" >nul
if "%ERRORLEVEL%"=="0" (
    echo 正在推送到云端远端仓库 (origin)...
    git push -u origin main
) else (
    echo [提示] 本地 Git 提交已成功保存！
    echo [注意] 尚未绑定云端远端仓库（GitHub/Gitee）。
    echo 绑定方法：在命令行运行 git remote add origin ^<你的仓库地址^>
)

echo.
echo ========================================================
echo   同步流程执行完毕！
echo ========================================================
pause
