#!/usr/bin/env bash
SSR_restart="/etc/init.d/shadowsocks restart"
python rayssr.py

python /usr/local/SSR.Go/addportrules.py
${SSR_restart}
# ������Ҫ������ɶ�ά��ģ��
echo "ssrr ������������"
