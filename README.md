# Render 部署 V2Ray（方案 A）最简步骤

本目录已经包含：
- Dockerfile
- config.json（已填入示例 UUID，可在部署前/后替换）

## 1. 上传到 GitHub
1) 打开 GitHub，新建一个仓库（Public 或 Private 均可）。
2) 把本目录下的所有文件上传到仓库根目录（保持文件名不变）。

## 2. Render 部署（Build from a Git repository）
1) 登录 https://dashboard.render.com
2) New → Web Service → 选择你的 GitHub 仓库
3) Instance Type: Free
4) Environment Variables：添加 PORT=8080
5) 其他保持默认，Create Web Service，等待自动构建并部署

部署成功后会得到 `https://<your-app>.onrender.com` 的地址。

## 3. 客户端连接（以 V2RayN 为例）
- 类型：VLESS
- 地址：`<your-app>.onrender.com`
- 端口：8080
- UUID：与 config.json 中一致（建议替换成你自己的 UUID）
- 传输：ws
- 路径：/vless

## 4. 替换 UUID（可选但推荐）
- 生成 UUID（在线或本地均可），将 `config.json` 中的 id 替换为你的 UUID。
- 提交到 GitHub 后，Render 会自动重新部署。

## 5. Cloudflare Worker 保活（可选）
- 创建一个 Worker，设置 Cron：`*/14 * * * *`
- 代码示例（按需调整路径）：
```js
addEventListener('scheduled', event => {
  event.waitUntil(fetch('https://<your-app>.onrender.com', { method: 'HEAD' }))
});
```

## 常见问题
- 如果连接失败，去 Render Dashboard → Logs 查看错误日志。
- 确保 `PORT=8080` 与 `config.json` 的 `inbounds.port` 一致。
- 如果需要自定义 TLS/域名，建议前置 Cloudflare 代理或使用反代（Nginx/Caddy）。
