#!/bin/bash
# scripts/entrypoint.sh
# 根据 PACKAGE_MANAGER 调度对应的下载脚本

set -euo pipefail

log() { echo -e "\e[1;36m📘 $1\e[0m"; }
success() { echo -e "\e[1;32m✅ $1\e[0m"; }
error() { echo -e "\e[1;31m❌ $1\e[0m"; exit 1; }

export OUTPUT_DIR="/offline-packages"
export PACKAGE_MANAGER="${PACKAGE_MANAGER:-apt}"
export PACKAGES="${PACKAGES:-build-essential}"

rm -rf ${OUTPUT_DIR}
mkdir -p "${OUTPUT_DIR}"

log "启动离线包下载系统"
log "包管理器: ${PACKAGE_MANAGER}"
log "基础镜像: ${OS_IMAGE}"
log "目标包: ${PACKAGES}"

case "${PACKAGE_MANAGER}" in
  apt|APT)
    log "调度到 APT 下载流程"
    /usr/local/bin/download-apt.sh
    ;;

  yum|YUM)
    log "调度到 YUM 下载流程"
    /usr/local/bin/download-yum.sh
    ;;

  *)
    error "不支持的包管理器: ${PACKAGE_MANAGER}，请使用 apt 或 yum"
    ;;
esac

# 打包
log "📦 正在打包为 .tgz..."
cd "${OUTPUT_DIR}" && tar -czf "/output/offline-packages-${PACKAGE_MANAGER}.tgz" *.deb *.rpm 2>/dev/null || true

success "打包完成！文件位于：/output/offline-packages-${PACKAGE_MANAGER}.tgz"

# 输出醒目的安装说明
log "📌 离线安装方法如下："

if [ "${PACKAGE_MANAGER}" = "apt" ]; then
  cat << 'EOF'

✅ Ubuntu/Debian 离线安装方法：

mkdir -p /root/offline-packages
tar -xzf offline-packages-apt.tgz -C /root/offline-packages/

dpkg -i /root/offline-packages/*.deb

# 如果有依赖问题：
apt-get install -f

EOF
else
  cat << 'EOF'

✅ CentOS/Rocky 离线安装方法：

mkdir -p /root/offline-packages
tar -xzf offline-packages-yum.tgz -C /root/offline-packages/

yum localinstall /root/offline-packages/*.rpm -y

# 或使用 rpm（不解决依赖）：
# rpm -ivh /root/offline-packages/*.rpm

EOF
fi

success "离线包已生成，安装说明如上 ↑↑↑"
