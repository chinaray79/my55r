#!/usr/bin/env bash
SSR_restart="/etc/init.d/shadowsocks restart"
python rayssr.py

python /usr/local/SSR.Go/addportrules.py
${SSR_restart}
# 这里需要添加生成二维码模块
echo "ssrr 服务已重启！"
