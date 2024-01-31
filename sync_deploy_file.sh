#!/usr/bin/env bash
echo "-------------------- 同步部署文件到 template 仓库，用于生产环境部署 --------------------";
echo "-------------------- 配置 git 用户信息为当前触发流水线的用户 --------------------";
git config --global user.email "wenkang@cmge.com";
git config --global user.name "wenkang";
echo "-------------------- git clone 仓库，只拉取指定分支的最后一次 commit --------------------";
cd /tmp || exit;
git clone --depth 1 --branch main http://username:password@target.git

echo "-------------------- 修改qa-helm文件 --------------------";

cat > /tmp/target/helm/loadlab/values.yaml << EOF
frontend:
  image: library/loadlab-frontend
  tag: '$CI_COMMIT_SHORT_SHA'
backend:
  image: library/loadlab-backend
  tag: '$CI_COMMIT_SHORT_SHA'
worker:
  image: library/loadlab-backend
  tag: '$CI_COMMIT_SHORT_SHA'
EOF

echo "-------------------- 提交到 qa-helm 仓库 --------------------";
cd /tmp/qa-helm || exit;
git add .;
git commit -m "sync： 通过 loadlab gitlab ci 自动同步部署文件" || true;
git pull;
git push;
echo "-------------------- 同步成功 --------------------";
