# Render 部署 V2Ray（方案 A）最简步骤

本目录已经包含：
- Dockerfile
- entrypoint.sh（启动时用环境变量生成最终配置）
- config.json（占位示例，最终由 entrypoint.sh 动态覆盖）

## 1. 上传到 GitHub
1) 打开 GitHub，新建一个仓库（Public 或 Private 均可）。
2) 把本目录下的所有文件上传到仓库根目录（保持文件名不变）。

## 2. Render 部署（Build from a Git repository）
1) 登录 https://dashboard.render.com
2) New → Web Service → 选择你的 GitHub 仓库
3) Instance Type: Free
4) Environment Variables：添加
   - PORT=8080（Render 要求容器监听此端口；外部访问依然走 443）
   - UUID=你的UUID（必填，不要硬编码在代码中）
   - WSPATH=/vless（可改，例如 /ws）
5) 其他保持默认，Create Web Service，等待自动构建并部署

部署成功后会得到 `https://<your-app>.onrender.com` 的地址。

## 3. 客户端连接（以 V2RayN 为例）
- 类型：VLESS
- 地址：`<your-app>.onrender.com`
- 端口：443（外部访问 Render 走 HTTPS 标准端口）
- UUID：与你设置的环境变量 UUID 一致
- 传输：ws
- 路径：与你设置的 WSPATH 一致（如 `/vless`）
- TLS：开启（SNI/ServerName 填 `<your-app>.onrender.com`）

说明：TLS 在 Render 边缘终止，随后以 HTTP 反代到容器内的 WS，这与 VLESS+WS 兼容。

## 5. Cloudflare Worker 保活（可选）
- 创建一个 Worker，设置 Cron：`*/14 * * * *`
- 代码示例（按需调整路径）：
```js
export default {
  async scheduled(event, env, ctx) {
    ctx.waitUntil(fetch('https://<your-app>.onrender.com', { method: 'HEAD' }));
  }
}
```

## 常见问题
- 如果连接失败，去 Render Dashboard → Logs 查看错误日志。
- 确保 `PORT=8080` 与容器监听端口一致；外部走 443。
- 优先使用环境变量 `UUID`、`WSPATH`，不要把敏感信息写入代码仓库。
- 如果需要自定义域名，按 Render 自定义域 +（可选）Cloudflare 代理配置。
