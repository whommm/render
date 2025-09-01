FROM v2fly/v2fly-core:latest
# 将 v2ray 配置放到默认路径
COPY config.json /etc/v2ray/config.json

# 和 config.json 的 inbounds.port 保持一致
EXPOSE 8080

# 直接运行 v2ray
CMD ["/usr/bin/v2ray", "run", "-c", "/etc/v2ray/config.json"]
