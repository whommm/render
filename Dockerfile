FROM v2fly/v2fly-core:latest
# 将 v2ray 配置放到默认路径
COPY config.json /etc/v2ray/config.json

# 复制启动脚本：使用环境变量(UUID/WSPATH/PORT)动态生成最终配置
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 和 config.json 的 inbounds.port 保持一致
EXPOSE 8080

# 使用 entrypoint 生成 /etc/v2ray/config.json 并启动
ENTRYPOINT ["/entrypoint.sh"]
