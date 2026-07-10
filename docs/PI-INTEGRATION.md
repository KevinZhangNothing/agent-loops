# pi Coding Agent 集成指南

[pi](https://pi.mcp.dev) 是一个强大的 coding agent 框架，支持 Skills、MCP 服务器、Workflows 和 Shortcuts。

Agent-loops 提供完整的 pi 集成包，包含 **12 个技能**、**3 个 Workflow** 和 **1 个 MCP 服务器**。

## 快速开始

### 一键安装（推荐）

```bash
# 在项目根目录运行
bash path/to/agent-loops/pi/install.sh
```

这会自动：
- 复制 12 个 skills 到 `~/.pi/agent/skills/`
- 复制 3 个 workflows 到 `~/.pi/agent/workflows/`
- 配置 MCP 服务器到 `~/.pi/agent/mcp.json`
- 备份已存在的文件

### 手动安装

```bash
# 1. 复制 skills
cp -r pi/skills/. ~/.pi/agent/skills/

# 2. 复制 workflows
cp -r pi/workflows/ ~/.pi/agent/workflows/

# 3. 配置 MCP 服务器
cp pi/mcp.json ~/.pi/agent/mcp.json

# 4. 编辑 mcp.json，设置你的项目路径
```

## 可用技能（12 个）

### L1 - 报告模式

| 技能 | 描述 | 触发词 |
|------|------|--------|
| `loop-audit` | Loop 就绪度审计 | "审计项目", "loop 评分" |
| `loop-init` | 脚手架生成 | "初始化 loop", "创建脚手架" |
| `loop-triage` | 日常任务分类 | "日常分类", "triage report" |
| `loop-cost` | Token 花费估算 | "token 花费", "预算估算" |
| `loop-budget` | Token 预算守护 | "loop budget", "kill switch" |
| `loop-sync` | 配置漂移检测 | "loop drift", "一致性检查" |

### L2 - 辅助模式

| 技能 | 描述 | 触发词 |
|------|------|--------|
| `loop-verifier` | 独立验证器 | "verify", "maker/checker" |
| `minimal-fix` | 最小修复实现 | "fix this", "minimal patch" |
| `loop-guard` | 电路熔断器 | "circuit breaker", "熔断器" |
| `ci-triage` | CI 失败分类 | "CI failure", "flake check" |
| `pr-review-triage` | PR 状态分类 | "PR status", "review queue" |
| `rebase-and-clean` | PR rebase 与清理 | "rebase PR", "clean commits" |

## Shortcuts

| 快捷键 | 描述 | 示例 |
|--------|------|------|
| `+loop-score` | 审计当前项目 | `+loop-score` |
| `+loop-score-suggest` | 获取改进建议 | `+loop-score-suggest` |
| `+loop-init` | 初始化脚手架 | `+loop-init daily-triage grok` |
| `+loop-cost` | 估算 token 花费 | `+loop-cost daily-triage L1` |
| `+loop-state` | 查看 STATE.md | `+loop-state` |
| `+loop-log` | 查看运行日志 | `+loop-log` |

## Workflows

### Daily Triage（日常分类）

**触发时间:** 工作日早上 9:00 (Asia/Shanghai)

**等级:** L1 (报告模式)

**预算:** 100,000 tokens/天

**配置:**
```yaml
# ~/.pi/agent/workflows/daily-triage.yaml
name: Daily Triage
schedule: "0 9 * * 1-5"
skills:
  - loop-triage
  - loop-audit
budget: 100000
```

**运行:**
```
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority. No code changes.
```

### PR Babysitter（PR 看护）

**触发时间:** 每 15 分钟

**等级:** L2 (辅助模式)

**预算:** 200,000 tokens/天

**配置:**
```yaml
# ~/.pi/agent/workflows/pr-babysitter.yaml
name: PR Babysitter
schedule: "*/15 * * * *"
skills:
  - pr-review-triage
  - loop-verifier
  - minimal-fix
budget: 200000
```

**运行:**
```
/loop 15m Check PR queue. Triage reviews. Suggest minimal fixes. Human gate on merges.
```

### CI Sweeper（CI 清扫）

**触发时间:** 每 10 分钟

**等级:** L2 (辅助修复)

**预算:** 1,000,000 tokens/天

**熔断器:** 启用

**配置:**
```yaml
# ~/.pi/agent/workflows/ci-sweeper.yaml
name: CI Sweeper
schedule: "*/10 * * * *"
skills:
  - ci-triage
  - loop-verifier
  - loop-guard
budget: 1000000
circuit_breaker:
  enabled: true
  stagnation_threshold: 3
  no_progress_threshold: 5
```

**运行:**
```
/loop 10m Check CI failures. Fix obvious flakes. Escalate after 3 attempts.
```

## MCP 服务器配置

### 配置示例

```json
{
  "mcpServers": {
    "AgentLoops": {
      "command": "npx",
      "args": ["-y", "@kevinzhangnothing/loop-mcp-server"],
      "env": {
        "LOOP_PROJECT_ROOT": "/path/to/your/project"
      }
    }
  }
}
```

### 可用资源

MCP 服务器提供以下资源：

- `loop://registry` - Pattern 注册表
- `loop://patterns/*` - Pattern 文档
- `loop://skills/*` - Skill 定义
- `loop://state/*` - State 文件
- `loop://budget` - Token 预算
- `loop://run-log` - 运行日志
- `loop://safety` - 安全文档

### 测试连接

```bash
# 手动运行 MCP 服务器
npx -y @kevinzhangnothing/loop-mcp-server

# 在 pi 中测试
+loop-score
```

## 使用示例

### 示例 1: 初始化第一个 Loop

```
+loop-init daily-triage grok
```

输出：
- 创建 `STATE.md`
- 创建 `LOOP.md`
- 创建 `loop-budget.md`
- 创建 `skills/loop-triage/SKILL.md`
- 打印 Loop Ready 评分

### 示例 2: 审计项目

```
+loop-score
```

输出：
```
Loop Readiness Audit — /path/to/project
Score: 72/100 (L2)
Assessment: Strong loop readiness — good candidate for L2 with worktrees.

Signals:
✓ State file: STATE.md
✓ Loop config: LOOP.md
✓ Skills: 4 loop skills detected
✓ Run log: 12 runs logged

Recommendations:
1. Add worktree isolation for L2 fixes
2. Add verifier skill for maker/checker split
3. Encode token budget in loop-budget.md
```

### 示例 3: 估算 Token 花费

```
+loop-cost daily-triage L1
```

输出：
```
Pattern: daily-triage
Level: L1
Cadence: 1d
Est. tokens/run: 500-2K
Est. tokens/day: 500-2K
Est. cost/day: $0.01-0.04 (at $20/1M tokens)
```

### 示例 4: 检测配置漂移

```
+loop-sync
```

输出：
```
Loop Sync Report — /path/to/project
Score: 85/100 (Healthy)

Issues:
- STATE.md references loop-triage v2, but skill is v1
- LOOP.md cadence doesn't match scheduler config

Suggestions:
1. Update skill version in STATE.md
2. Sync LOOP.md with actual scheduler
```

## 故障排除

### MCP 服务器无法连接

**问题:** pi 无法连接到 MCP 服务器

**解决:**
```bash
# 1. 检查 npx 是否可用
which npx

# 2. 手动运行 MCP 服务器
npx -y @kevinzhangnothing/loop-mcp-server

# 3. 检查 mcp.json 配置
cat ~/.pi/agent/mcp.json

# 4. 重启 pi
```

### Skills 未加载

**问题:** pi 无法找到 skills

**解决:**
```bash
# 1. 检查技能目录
ls ~/.pi/agent/skills/ | grep loop

# 2. 应该有 12 个 skills:
# loop-audit, loop-budget, loop-cost, loop-guard,
# loop-init, loop-sync, loop-triage, loop-verifier,
# minimal-fix, ci-triage, pr-review-triage, rebase-and-clean

# 3. 重新安装
bash pi/install.sh

# 4. 或手动复制
cp -r pi/skills/. ~/.pi/agent/skills/
```

### Workflows 不触发

**问题:** Workflows 没有按计划触发

**解决:**
```bash
# 1. 检查 workflow 文件
ls ~/.pi/agent/workflows/

# 2. 验证 cron 表达式
# 使用 https://crontab.guru 验证

# 3. 检查 pi 日志
# 查看 workflow scheduler 日志

# 4. 手动触发测试
/loop 5m Run daily-triage skill
```

### Token 预算超支

**问题:** Loop 花费超过预期

**解决:**
```bash
# 1. 立即停止 loop
# 删除 scheduler 或禁用 workflow

# 2. 检查预算配置
cat loop-budget.md

# 3. 设置更严格的预算
# 编辑 loop-budget.md，降低 daily_max

# 4. 启用熔断器
# 添加 loop-guard skill 到 workflow
```

## 最佳实践

### 1. 从 L1 开始

第一周只使用报告模式：
```
/loop 1d Run loop-triage. Report only. No code changes.
```

### 2. 设置预算

在 `loop-budget.md` 中设置：
```markdown
## Daily token budget
- Max: 100K tokens/day
- Current: 25K (25%)
- Kill switch: 500K tokens/day
```

### 3. 使用熔断器

L2+ loops 必须启用熔断器：
```yaml
skills:
  - loop-guard
circuit_breaker:
  enabled: true
  stagnation_threshold: 3
```

### 4.  Maker/Checker 分离

永远不要让同一个 agent 实现和验证：
```
Implementer: "Fix the failing test"
   ↓
Verifier: "Review this diff. APPROVE or REJECT only."
```

### 5. 定期审计

每周运行一次审计：
```
+loop-score-suggest
```

## 进阶使用

### 自定义 Skill

创建自定义 skill：
```bash
# 1. 创建目录
mkdir ~/.pi/agent/skills/my-custom-skill

# 2. 创建 SKILL.md
cat > ~/.pi/agent/skills/my-custom-skill/SKILL.md << 'EOF'
# my-custom-skill

## Purpose
Custom skill for specific task.

## Steps
1. Read STATE.md
2. ...
3. Update STATE.md

## Constraints
- No code changes week 1
EOF
```

### 自定义 Workflow

创建自定义 workflow：
```yaml
# ~/.pi/agent/workflows/custom.yaml
name: Custom Loop
schedule: "0 */2 * * *"  # Every 2 hours
skills:
  - loop-triage
  - my-custom-skill
budget: 50000
```

### 集成其他工具

通过 MCP 集成其他工具：
```json
{
  "mcpServers": {
    "AgentLoops": { ... },
    "GitHub": { ... },
    "Linear": { ... }
  }
}
```

## 资源

- [pi 文档](https://pi.mcp.dev/docs)
- [Agent-loops GitHub](https://github.com/KevinZhangNothing/agent-loops)
- [npm 包](https://www.npmjs.com/org/kevinzhangnothing)
- [安装脚本](../pi/install.sh)

## 支持

遇到问题？

- [GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues)
- [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions)
