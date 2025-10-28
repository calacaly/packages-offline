#!/bin/bash
echo "📘 [YUM] 更新元数据..."
cp -r /tmp/yum/* /etc/yum/
yum makecache

echo "📘 [YUM] 清除${PACKAGES}原有文件"
rm -rf ${PACKAGES}/*

echo "📘 [YUM] 下载包: ${PACKAGES}"
yum install -y --downloadonly --downloaddir="${OUTPUT_DIR}" ${PACKAGES}

echo "📘 [YUM] 完成，包已存入 ${OUTPUT_DIR}"
