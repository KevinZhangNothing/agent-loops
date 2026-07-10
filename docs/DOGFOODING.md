# agent-loops Dogfooding Workflow

通过 pi + agent-loops 来完善 agent-loops 项目本身。

## 当前目标

使用 pi 的 agent-loops 集成来持续改进 agent-loops 项目。

## 每日工作流

### 早上 9:00 - Daily Triage

**在 pi 中运行：**
```
+loop-score
```

**检查清单：**
- [ ] Loop Readiness Score 是否提升？
- [ ] 是否有新的改进建议？
- [ ] Token 花费是否在预算内？
- [ ] 是否有需要人工干预的问题？

**输出示例：**
```
Score: 85/100 (L2) ↑ from 82/100 yesterday

✓ 12 skills installed
✓ 3 workflows active
✓ MCP server running
⚠ 2 suggestions pending
```

### 开发中 - On-demand Audits

**实现功能前：**
```
+loop-score-suggest
```

**实现功能后：**
```
+loop-score  # 验证改进
```

### 晚上 6:00 - Daily Report

**在 pi 中运行：**
```
总结今天的改进：
1. 运行 +loop-score 对比早上分数
2. 列出今天完成的所有改进
3. 生成明日待办
4. 更新 loop-run-log.md
```

## 具体任务模板

### 模板 1: 完善文档

**Prompt:**
```
我需要完善 agent-loops 文档。请：

1. 运行 +loop-score-suggest 获取文档相关的改进建议
2. 针对每条建议：
   - 说明为什么重要
   - 给出具体修改内容
   - 列出需要修改的文件
3. 帮我生成修改后的文件内容
4. 验证修改后的效果

从最高优先级的文档改进开始。
```

**期望输出：**
```markdown
## 优先级 1: 添加 Dogfooding 指南

为什么重要：
- 新用户需要知道如何用自己的产品
- 展示实际使用场景
- 提高可信度

需要修改的文件：
- docs/README.md (添加链接)
- docs/DOGFOOD-PI.md (新建)

修改内容：
[完整的新文件内容]

验证命令：
+loop-score  # 文档完整性分数应该提升
```

### 模板 2: 修复 Bug

**Prompt:**
```
发现 bug: pi/install.sh 复制 skills 时出错。

请：
1. 诊断问题根因
2. 给出修复方案
3. 生成修复后的代码
4. 提供验证步骤
5. 更新相关测试

按照 minimal-fix 技能的模式处理。
```

**期望输出：**
```markdown
## Bug 分析

根因：cp -r "$skill" "$dst_dir/" 复制了整个目录到错误位置

修复方案：
改为 cp -r "$skill" "$dst_dir/$skill_name/"

修改文件：
- pi/install.sh (line 145)

验证步骤：
1. rm -rf ~/.pi/agent/skills/*
2. ./pi/install.sh
3. ls ~/.pi/agent/skills  # 应该有 12 个目录
```

### 模板 3: 优化性能

**Prompt:**
```
优化 token 花费。请：

1. 运行 +loop-cost 分析当前花费
2. 识别 token 花费最高的 operations
3. 给出优化建议
4. 实现优化
5. 验证优化效果

目标：减少 30% token 花费。
```

**期望输出：**
```markdown
## Token 花费分析

当前花费：
- daily-triage: 5K tokens/day
- pr-babysitter: 50K tokens/day
- ci-sweeper: 100K tokens/day
总计：155K tokens/day

优化建议：
1. 减少 pr-babysitter 频率 (15m → 30m)
   节省：25K tokens/day
   
2. 添加 response caching
   节省：10K tokens/day

实现后验证：
+loop-cost  # 应该显示 ~120K tokens/day
```

## 周工作流

### 周一 - Planning

```
本周目标：
1. 提升 Loop Readiness Score 从 85 → 90
2. 发布 npm 包更新
3. 完善 pi 集成文档

请帮我制定详细计划。
```

### 周三 - Mid-week Check

```
检查本周进度：
1. 对比周一的 STATE.md
2. 完成的项目
3. 待完成的项目
4. 是否需要调整计划
```

### 周五 - Review

```
本周回顾：
1. 运行 +loop-score 对比周一分数
2. 列出所有完成的改进
3. 生成周报
4. 更新 CONTRIBUTORS.md
5. 规划下周目标
```

## 月度目标

### 月末 Review

```
月度总结：
1. 月初 vs 月末 Loop Readiness Score
2. 发布的 npm 包版本
3. 社区贡献 (PRs, issues)
4. 文档改进
5. 下月目标
```

## 自动化脚本

### 创建 GitHub Issue

**Prompt:**
```
基于今天的 +loop-score-suggest 输出，创建 3 个 GitHub issues：
1. 高优先级 bug 修复
2. 中优先级功能改进
3. 低优先级文档更新

每个 issue 包含：
- 清晰的标题
- 问题描述
- 复现步骤（如果是 bug）
- 期望行为
- 验收标准
- 估计工作量
```

### 生成 Release Notes

**Prompt:**
```
生成 v1.7.0 release notes：
1. 读取 git log 从上次 tag 到现在
2. 分类：Features, Fixes, Docs
3. 感谢贡献者
4. 添加 npm 包版本
5. 生成 markdown 格式

输出到 RELEASE_NOTES_v1.7.0.md
```

### 更新 Adopters

**Prompt:**
```
检查最近 star 和 fork 的项目：
1. 读取 GitHub API (stars, forks)
2. 找出可能在使用 agent-loops 的项目
3. 生成邀请他们加入 adopters 的 message
4. 创建 outreach issue
```

## 度量指标

### 每周追踪

| 指标 | 目标 | 当前 | 状态 |
|------|------|------|------|
| Loop Readiness Score | 90+ | 85 | 🟡 |
| npm downloads/week | 100+ | 45 | 🟡 |
| GitHub stars | 100+ | 67 | 🟡 |
| Active workflows | 3 | 3 | ✅ |
| Token budget/day | <200K | 155K | ✅ |

### 每月追踪

| 指标 | 目标 | 实际 | 状态 |
|------|------|------|------|
| npm packages published | 2 | 1 | 🟡 |
| Documentation pages | 5 | 3 | 🟡 |
| Community PRs | 5 | 2 | 🟡 |
| Bug fixes | 10 | 8 | 🟡 |

## 持续改进循环

```
┌─────────────────────────────────────────┐
│  1. +loop-score (审计)                   │
│       ↓                                 │
│  2. +loop-score-suggest (建议)           │
│       ↓                                 │
│  3. 实现改进 (手动或自动)                 │
│       ↓                                 │
│  4. +loop-score (验证)                   │
│       ↓                                 │
│  5. 提交 GitHub (持久化)                  │
│       ↓                                 │
│  6. 更新 STATE.md (记录)                 │
│       ↓                                 │
│  Back to 1                              │
└─────────────────────────────────────────┘
```

## 开始使用

**第一次运行：**
```bash
cd /Users/kevin/Desktop/Nothing/agent-loops

# 在 pi 中
+loop-score
```

**每天运行：**
```
+loop-score          # 早上检查
+loop-score-suggest  # 获取改进建议
+loop-state          # 查看当前状态
```

**每周运行：**
```
总结本周改进，生成周报，规划下周目标。
```

---

*Ready to dogfood! 🍴*
