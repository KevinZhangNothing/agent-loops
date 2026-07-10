# pi 中使用 Agent Loops 完整教程

本教程将带你从零开始在 pi 中安装、配置和使用 Agent Loops。

---

## 📋 目录

1. [前置要求](#前置要求)
2. [安装步骤](#安装步骤)
3. [快速验证](#快速验证)
4. [第一个 Loop](#第一个-loop)
5. [日常使用](#日常使用)
6. [进阶配置](#进阶配置)
7. [常见问题](#常见问题)

---

## 前置要求

### 1. 安装 pi

确保你已安装 pi coding agent：

```bash
# 如果尚未安装 pi，参考官方文档
# https://pi.mcp.dev/docs/installation
```

### 2. 确认 pi 可用

```bash
# 测试 pi 是否正常工作
pi --version
```

### 3. 准备项目

选择一个你想要应用 Agent Loops 的项目：

```bash
cd /path/to/your/project
```

---

## 安装步骤

### 方法一：一键安装（推荐）

```bash
# 1. 克隆 agent-loops 仓库（如果还没有）
git clone https://github.com/KevinZhangNothing/agent-loops.git
cd agent-loops

# 2. 运行安装脚本
bash pi/install.sh
```

安装脚本会自动：
- ✅ 复制 12 个 skills 到 `~/.pi/agent/skills/`
- ✅ 复制 3 个 workflows 到 `~/.pi/agent/workflows/`
- ✅ 配置 MCP 服务器到 `~/.pi/agent/mcp.json`
- ✅ 备份已存在的文件

### 方法二：手动安装

```bash
# 1. 复制 skills
cp -r agent-loops/pi/skills/. ~/.pi/agent/skills/

# 2. 复制 workflows
cp -r agent-loops/pi/workflows/. ~/.pi/agent/workflows/

# 3. 配置 MCP 服务器
cp agent-loops/pi/mcp.json ~/.pi/agent/mcp.json

# 4. 编辑 mcp.json，设置你的项目路径
# 将 LOOP_PROJECT_ROOT 改为你的项目绝对路径
```

### 验证安装

```bash
# 检查 skills 是否安装成功
ls ~/.pi/agent/skills/ | grep loop

# 应该看到：
# loop-audit
# loop-budget
# loop-cost
# loop-guard
# loop-init
# loop-sync
# loop-triage
# loop-verifier
# ...
```

---

## 快速验证

### 1. 测试 MCP 连接

在 pi 中运行：

```
+loop-score
```

**预期输出：**
```
Loop Readiness Audit — /path/to/your/project
Score: XX/100 (L0/L1/L2)
...
```

### 2. 查看可用 skills

在 pi 中询问：

```
显示所有可用的 loop skills
```

**应该返回：**
- loop-audit — Loop 就绪度审计
- loop-init — 脚手架生成
- loop-triage — 日常任务分类
- loop-cost — Token 花费估算
- loop-budget — Token 预算守护
- loop-sync — 配置漂移检测
- loop-verifier — 独立验证器
- minimal-fix — 最小修复实现
- loop-guard — 电路熔断器
- ci-triage — CI 失败分类
- pr-review-triage — PR 状态分类
- rebase-and-clean — PR rebase 与清理

---

## 第一个 Loop

### 步骤 1：初始化项目

在 pi 中运行：

```
+loop-init daily-triage grok
```

**输出示例：**
```
📦 Scaffolding loop with pattern: daily-triage
🔧 Tool: grok

Created:
  ✓ STATE.md
  ✓ LOOP.md
  ✓ loop-budget.md
  ✓ skills/loop-triage/SKILL.md

Loop Readiness Score: 65/100 (L1)
Assessment: Ready for L1 report-only loop
```

### 步骤 2：检查 Token 预算

```
+loop-cost daily-triage L1
```

**输出示例：**
```
Pattern: daily-triage
Level: L1
Cadence: 1d
Est. tokens/run: 500-2K
Est. tokens/day: 500-2K
Est. cost/day: $0.01-0.04 (at $20/1M tokens)
```

### 步骤 3：运行第一个 Loop

在 pi 中发送：

```
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority section. No code changes.
```

**这会：**
1. 读取 `STATE.md`
2. 扫描 CI 状态、Issues、Commits
3. 更新 `STATE.md` 的优先级列表
4. 生成 5 行摘要

### 步骤 4：查看结果

```
+loop-state
```

**输出示例：**
```
## Last run
2026-07-10 09:00

## High Priority
- CI failing: test-api on main (2 failures)
- PR #47: awaiting review

## Watch List
- Issue #120: needs reproduction

## Completed
- [x] Updated changelog for v1.5.0
```

---

## 日常使用

### 场景 1：早晨项目扫描

**每天早上运行：**

```
+loop-triage
```

**或者使用 shortcut：**

```
/loop 1d Morning triage: CI, issues, commits. Update STATE.md.
```

### 场景 2：审计项目健康度

**每周运行一次：**

```
+loop-score-suggest
```

**输出包含：**
- Loop 就绪度评分
- 当前等级评估
- 改进建议
- 下一步行动

### 场景 3：检查 Token 花费

**随时查询：**

```
+loop-budget
```

**或者查看运行日志：**

```
+loop-log
```

### 场景 4：检测配置漂移

**在修改配置后：**

```
+loop-sync
```

**这会检查：**
- STATE.md 与 LOOP.md 是否一致
- Skill 版本是否匹配
- 调度配置是否正确

---

## 进阶配置

### 配置 Daily Triage Workflow

编辑 `~/.pi/agent/workflows/daily-triage.yaml`：

```yaml
name: Daily Triage
schedule: "0 9 * * 1-5"  # 工作日早上 9 点
skills:
  - loop-triage
  - loop-audit
budget: 100000  # 100K tokens/天
level: L1  # 报告模式
```

### 配置 PR Babysitter Workflow

编辑 `~/.pi/agent/workflows/pr-babysitter.yaml`：

```yaml
name: PR Babysitter
schedule: "*/15 * * * *"  # 每 15 分钟
skills:
  - pr-review-triage
  - loop-verifier
  - minimal-fix
budget: 200000  # 200K tokens/天
level: L2  # 辅助修复模式
```

### 配置 CI Sweeper Workflow

编辑 `~/.pi/agent/workflows/ci-sweeper.yaml`：

```yaml
name: CI Sweeper
schedule: "*/10 * * * *"  # 每 10 分钟
skills:
  - ci-triage
  - loop-verifier
  - loop-guard
budget: 1000000  # 1M tokens/天
level: L2
circuit_breaker:
  enabled: true
  stagnation_threshold: 3  # 3 次失败后升级
```

### 自定义 Token 预算

编辑项目中的 `loop-budget.md`：

```markdown
## Daily token budget
- Max: 100K tokens/day
- Current: 25K (25%)
- Kill switch: 500K tokens/day

## Per-loop limits
- daily-triage: 50K
- pr-babysitter: 200K
- ci-sweeper: 1M
```

---

## 常见问题

### Q1: Skills 未加载

**问题：** pi 无法找到 loop skills

**解决：**

```bash
# 1. 检查技能目录
ls ~/.pi/agent/skills/ | grep loop

# 2. 如果没有，重新安装
bash agent-loops/pi/install.sh

# 3. 或者手动复制
cp -r agent-loops/pi/skills/. ~/.pi/agent/skills/

# 4. 重启 pi
```

### Q2: MCP 服务器无法连接

**问题：** `+loop-score` 无响应

**解决：**

```bash
# 1. 检查 npx 是否可用
which npx

# 2. 手动运行 MCP 服务器
npx -y @kevinzhangnothing/loop-mcp-server

# 3. 检查 mcp.json 配置
cat ~/.pi/agent/mcp.json

# 4. 确保 LOOP_PROJECT_ROOT 设置正确
# 5. 重启 pi
```

### Q3: Workflows 不触发

**问题：** 计划的 workflows 没有运行

**解决：**

```bash
# 1. 检查 workflow 文件是否存在
ls ~/.pi/agent/workflows/

# 2. 验证 cron 表达式
# 使用 https://crontab.guru 验证

# 3. 检查 pi 日志
# 查看 workflow scheduler 日志

# 4. 手动触发测试
/loop 5m Run daily-triage skill
```

### Q4: Token 预算超支

**问题：** Loop 花费超过预期

**立即行动：**

```bash
# 1. 停止 loop
# 删除 scheduler 或禁用 workflow

# 2. 检查当前花费
+loop-budget

# 3. 设置更严格的预算
# 编辑 loop-budget.md，降低 daily_max

# 4. 启用熔断器
# 在 workflow 中添加 loop-guard skill
```

### Q5: Loop 做出意外更改

**问题：** L2+ loop 修改了不该修改的代码

**预防和解决：**

```markdown
1. 第一周只用 L1（报告模式）
2. 添加 denylist 到 LOOP.md：
   ```
   Denylist:
   - package-lock.json
   - yarn.lock
   - docs/*.md
   ```
3. 启用 maker/checker 分离
4. 要求所有 PR 必须人工审查
```

---

## 最佳实践

### ✅ 推荐做法

1. **从 L1 开始**
   ```
   /loop 1d Run loop-triage. Report only. No code changes.
   ```

2. **设置明确预算**
   ```markdown
   ## loop-budget.md
   - Daily max: 100K tokens
   - Kill switch: 500K tokens
   ```

3. **使用熔断器**
   ```yaml
   skills:
     - loop-guard
   circuit_breaker:
     enabled: true
     stagnation_threshold: 3
   ```

4. **Maker/Checker 分离**
   ```
   Implementer: "Fix the failing test"
      ↓
   Verifier: "Review this diff. APPROVE or REJECT only."
   ```

5. **定期审计**
   ```
   每周：+loop-score-suggest
   ```

### ❌ 避免做法

1. **不要一开始就用 L3**
   - 先建立信任，再逐步升级

2. **不要设置过高的预算**
   - 从低预算开始，根据需要增加

3. **不要跳过验证步骤**
   - 所有自动修复都需要验证

4. **不要忽略 STATE.md**
   - 每天阅读，保持理解

5. **不要在没有熔断器的情况下运行 L2+**
   - 始终启用 loop-guard

---

## 快捷键参考

| 快捷键 | 描述 | 示例 |
|--------|------|------|
| `+loop-score` | 审计当前项目 | `+loop-score` |
| `+loop-score-suggest` | 获取改进建议 | `+loop-score-suggest` |
| `+loop-init` | 初始化脚手架 | `+loop-init daily-triage grok` |
| `+loop-cost` | 估算 token 花费 | `+loop-cost daily-triage L1` |
| `+loop-state` | 查看 STATE.md | `+loop-state` |
| `+loop-log` | 查看运行日志 | `+loop-log` |
| `+loop-budget` | 查看预算状态 | `+loop-budget` |
| `+loop-sync` | 检测配置漂移 | `+loop-sync` |

---

## 下一步

完成本教程后：

1. 📖 阅读 [核心概念](./zh-CN/concepts.md) 理解 loops vs goals
2. 📖 阅读 [五个原语](./zh-CN/PRIMITIVES.md) 学习构建块
3. 📖 查看 [模式文档](../patterns/README.md) 选择适合的 loop
4. 🔧 尝试配置 [PR Babysitter](../patterns/pr-babysitter.md)
5. 🔧 尝试配置 [CI Sweeper](../patterns/ci-sweeper.md)

---

## 资源

- [pi 官方文档](https://pi.mcp.dev/docs)
- [Agent-loops GitHub](https://github.com/KevinZhangNothing/agent-loops)
- [npm 包列表](https://www.npmjs.com/org/kevinzhangnothing)
- [安装脚本](../pi/install.sh)
- [技能文档](../docs/zh-CN/README.md)

## 支持

遇到问题？

- 🐛 [GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues)
- 💬 [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions)
- 📖 [故障排除](./PI-INTEGRATION.md#故障排除)
