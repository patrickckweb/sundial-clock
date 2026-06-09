# 日晷时钟 — GitHub Pages 一键部署脚本
# 用法：在 PowerShell 中运行 .\deploy.ps1

$ErrorActionPreference = "Stop"
$RepoName = "sundial-clock"

# 查找 gh 命令
$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
    $portable = "$env:TEMP\gh-portable\bin\gh.exe"
    if (Test-Path $portable) { $gh = $portable } else { throw "请先安装 GitHub CLI: winget install GitHub.cli" }
} else { $gh = $gh.Source }

Write-Host "检查 GitHub 登录状态..." -ForegroundColor Cyan
& $gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "需要登录 GitHub，将打开浏览器..." -ForegroundColor Yellow
    & $gh auth login --hostname github.com --git-protocol https --web
}

Set-Location $PSScriptRoot

Write-Host "创建公开仓库 $RepoName ..." -ForegroundColor Cyan
& $gh repo create $RepoName --public --source=. --remote=origin --push 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "仓库可能已存在，尝试直接推送..." -ForegroundColor Yellow
    git remote remove origin 2>$null
    $user = (& $gh api user -q .login)
    git remote add origin "https://github.com/$user/$RepoName.git"
    git push -u origin main
}

Write-Host "启用 GitHub Pages..." -ForegroundColor Cyan
& $gh api repos/{owner}/$RepoName/pages -X POST -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/" 2>$null
if ($LASTEXITCODE -ne 0) {
    & $gh api repos/{owner}/$RepoName/pages -X PUT -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/" 2>$null
}

$user = (& $gh api user -q .login)
$url = "https://$user.github.io/$RepoName/"
Write-Host ""
Write-Host "部署完成！约 1-2 分钟后可访问：" -ForegroundColor Green
Write-Host $url -ForegroundColor White
