#!/bin/bash
# 🔥 智能缓存工具：自动匹配/下载/上传 toolchain 和编译缓存

TARGET="ipq40xx"
REPO_OWNER="your_github_username"
REPO_NAME="your_repo_name"

# 检查本地缓存
check_local_cache() {
  if [ -d "lede/dl" ]; then
    echo "🎯 Found local cache!"
    return 0
  else
    echo "❌ No local cache found."
    return 1
  fi
}

# 从 Releases 下载缓存
download_cache_from_releases() {
  echo "🔍 Searching for prebuilt cache in Releases..."
  LATEST_TAG=$(curl -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest | jq -r .tag_name)
  
  if [[ $LATEST_TAG == toolchain-$TARGET-* ]]; then
    echo "📥 Downloading cache from $LATEST_TAG..."
    wget -qO- "https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/$LATEST_TAG/cache.tar.gz" | tar xz
    return 0
  else
    echo "⚠️ No matching cache found in Releases."
    return 1
  fi
}

# 主逻辑
if ! check_local_cache; then
  if ! download_cache_from_releases; then
    echo "🛠️ Proceeding to build toolchain from scratch..."
    # 这里可以调用编译 toolchain 的逻辑
  fi
fi
