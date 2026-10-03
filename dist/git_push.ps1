# E:\Artificial Intellengence\AI_Bot\QQ-SQL\git_push.ps1
# QQ-SQL 一键提交与同步至 Git (PowerShell 强化版)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "QQ-SQL 一键提交与同步至 Git"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  QQ-SQL 知识库自动同步工具 (PowerShell 稳定版)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoRoot

# 1. 检测并注入本机 Clash Verge 代理
$ProxyUrl = "http://127.0.0.1:7898"
Write-Host "[1/4] 检查网络代理环境..." -ForegroundColor Yellow

$proxyOnline = $false
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $iar = $tcp.BeginConnect("127.0.0.1", 7898, $null, $null)
    $success = $iar.AsyncWaitHandle.WaitOne(1000, $false)
    if ($success -and $tcp.Connected) {
        $tcp.EndConnect($iar)
        $tcp.Close()
        $proxyOnline = $true
    }
} catch {
    $proxyOnline = $false
}

if ($proxyOnline) {
    Write-Host "  -> [OK] 检测到 Clash Verge 正在运行 (127.0.0.1:7898)，已注入代理通道。" -ForegroundColor Green
    $env:HTTP_PROXY = $ProxyUrl
    $env:HTTPS_PROXY = $ProxyUrl
    git config --local http.proxy $ProxyUrl
    git config --local https.proxy $ProxyUrl
} else {
    Write-Host "  -> [提示] 未检测到 7898 端口代理，尝试直连网络。" -ForegroundColor DarkYellow
    git config --local --unset http.proxy 2>$null
    git config --local --unset https.proxy 2>$null
}

# 2. 保存本地笔记
Write-Host ""
Write-Host "[2/4] 正在保存本地所有笔记变动..." -ForegroundColor Yellow
git add .
$timeStr = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitRes = git commit -m "update: sync notes ($timeStr)" 2>&1
Write-Host "  -> 本地笔记索引已更新。" -ForegroundColor Green

# 3. 检查远程仓库与推送
Write-Host ""
Write-Host "[3/4] 正在推送到 GitHub (kelai061/AI-club-sql)..." -ForegroundColor Yellow
Write-Host "  （若首次运行且未登录，系统稍后会唤起浏览器弹出 GitHub 授权页）" -ForegroundColor Gray

git push -u origin main
$pushExitCode = $LASTEXITCODE

Write-Host ""
if ($pushExitCode -eq 0) {
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "  [成功] 知识库已成功推送至 GitHub！" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
} else {
    Write-Host "========================================================" -ForegroundColor Red
    Write-Host "  [提示] 推送未完成（可能需要 GitHub 授权或网络超时）" -ForegroundColor Red
    Write-Host "========================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "如果你不想等待浏览器弹窗，可以使用 Token 极速直推：" -ForegroundColor Yellow
    Write-Host "1. 打开网页: https://github.com/settings/tokens" -ForegroundColor Gray
    Write-Host "2. 生成一个带有 [repo] 权限的 Token" -ForegroundColor Gray
    Write-Host "3. 直接在下方粘贴 Token 并按回车（或直接按回车跳过）：" -ForegroundColor Cyan
    $tokenInput = Read-Host "GitHub Token"
    if ($tokenInput -and $tokenInput.Trim() -ne "") {
        $token = $tokenInput.Trim()
        Write-Host "正在切换为 Token 鉴权并重试推送..." -ForegroundColor Yellow
        git remote set-url origin "https://${token}@github.com/kelai061/AI-club-sql.git"
        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [成功] 使用 Token 推送成功！以后无需再次输入。" -ForegroundColor Green
        } else {
            Write-Host "  [失败] Token 验证未通过，请检查 Token 权限是否包含 repo。" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "同步任务结束。" -ForegroundColor Gray
Read-Host "按回车键退出窗口..."
