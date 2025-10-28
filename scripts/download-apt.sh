#!/bin/bash
echo "📘 [APT] 清除默认仓库..."
rm -rf /etc/apt/sources.list.d/ubuntu.sources

echo "📘 [APT] 更新包索引..."
cp -rf /tmp/apt/* /etc/apt/
apt-get update

echo "📘 [APT] 下载包: ${PACKAGES}"

apt-get install -d -y ${PACKAGES}

echo "📘 [APT] 复制到 ${OUTPUT_DIR}"
cp /var/cache/apt/archives/*.deb "${OUTPUT_DIR}/" 2>/dev/null || echo "⚠️  未找到 .deb 文件"
