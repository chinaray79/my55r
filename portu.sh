#!/usr/bin/env bash
SSR_restart="/etc/init.d/shadowsocks restart"
python rayssr.py
${SSR_restart}
