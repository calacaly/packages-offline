# 📦 离线软件包下载系统

> 一键生成 `.deb` 或 `.rpm` 离线安装包，支持 Ubuntu、Debian、CentOS、Rocky 等主流 Linux 发行版。

本项目通过 Docker + `docker-compose` 实现：

- ✅ 自动下载指定软件包及其依赖
- ✅ 支持 `apt` 和 `yum` 包管理器
- ✅ 源配置由 `mirrors/` 目录统一管理（使用 HTTP 避免证书问题）
- ✅ 输出 `.tgz` 离线包 + 醒目安装说明
- ✅ 无需联网即可在目标机器安装

---

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/yourname/offline-package-downloader.git
cd offline-package-downloader
```

### 2. 创建输出目录

```bash
mkdir -p output
mkdir -p packages
```

### 3. 配置 .env 文件
```bash
# .env
PACKAGE_MANAGER=apt
OS_IMAGE=ubuntu:24.04
PACKAGES=build-essential pkg-config xorg-dev
```

### 4. 启动下载
```bash
docker-compose up
```

完成后，output/ 目录将生成：

offline-packages-apt.tgz（APT 系统）
offline-packages-yum.tgz（YUM 系统）
并在终端输出 离线安装方法。

## 🔧 配置源：如何修改 `mirrors/`

你可以自定义软件源，适用于私有仓库或内网镜像。**本项目使用 HTTP 源，避免容器内无 CA 证书导致下载失败。**

### ✅ 修改 APT 源（Ubuntu/Debian）

编辑文件：`mirrors/apt/sources.list`

### 修改 YUM 源（CentOS/Rocky）
编辑或添加：`mirrors/yum/CentOS-Base.repo`


### 🛠️ 如何微调下载脚本
脚本位于 scripts/ 目录，可根据需要调整行为。

✅ 微调 scripts/download-apt.sh
✅ 微调 scripts/download-yum.sh

常见修改建议：
使用 dnf（适用于 RHEL 8+/Rocky 8+）：
```bash
dnf makecache
dnf install -y --downloadonly --downloaddir="${OUTPUT_DIR}" ${PACKAGES}
```

跳过 GPG 检查（内网可用）：
```bash
yum install -y --downloadonly --downloaddir="${OUTPUT_DIR}" --nogpgcheck ${PACKAGES}
```

安装软件包组：
```bash
PACKAGES="@development-tools"
```

启用特定仓库（如 EPEL）：
```bash
yum install -y --downloadonly --downloaddir="${OUTPUT_DIR}" --enablerepo=epel ${PACKAGES}
```

### 📌 优势
特性	说明
🔧 配置驱动	只改 .env 就能切换系统
📦 自动打包	输出 .tgz，方便分发
📝 安装指引	终端自动输出安装方法
🐳 无污染	所有操作在容器内完成
🌐 源可控	mirrors/ 目录统一管理
🚫 无 HTTPS	使用 HTTP 避免证书问题
