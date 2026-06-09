# 日晷 · 24小时昼夜时钟

一个自包含的 HTML 日晷时钟，根据本地时间显示晷针阴影，并随昼夜变换天空背景。

## 在线访问

部署 GitHub Pages 后，访问地址为：

`https://<你的用户名>.github.io/sundial-clock/`

## 本地预览

直接用浏览器打开 `index.html` 即可。

## 部署到 GitHub Pages

### 一键部署（推荐）

```powershell
cd D:\coding
.\deploy.ps1
```

脚本会自动登录 GitHub、创建公开仓库、推送代码并启用 Pages。

### 手动部署

1. 在 GitHub 创建公开仓库 `sundial-clock`
2. `git remote add origin https://github.com/<用户名>/sundial-clock.git`
3. `git push -u origin main`
4. 仓库 **Settings → Pages** → Source 选 `main` / `/ (root)`
