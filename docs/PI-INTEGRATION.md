# pi 集成指南

将 loop-engineering 集成到 **pi coding agent** 的完整指南。

> **pi** 是一个强大的 coding agent 框架，支持 Skills、MCP 服务器、Workflows 和 Shortcuts。本指南帮助你充分利用 loop-engineering 与 pi 的集成。

---

## 快速开始 (5 分钟)

### 1. 复制 pi 配置到你的项目

```bash
# 从 loop-engineering 复制 pi 配置
cp /path/to/loop-engineering/pi/mcp.json ~/.pi/agent/

# 或者在你的项目中使用
cp /path/to/loop-engineering/pi/ .
```

### 2. 配置 MCP 服务器

编辑 `~/.pi/agent/mcp.json`，添加 Loop Engineering MCP 服务器：

```json
{
  "mcpServers": {
    "LoopEngineering": {
      "command": "npx",
      "args": ["-y", "@kevinzhangnothing/loop-mcp-server"],
      "env": {
        "LOOP_PROJECT_ROOT": "/path/to/your/project"
      }
    }
  }
}
```

### 3. 安装 Skills

```bash
# 复制 skills 到 pi 技能目录
cp -r /path/to/loop-engineering/pi/skills/loop-* ~/.pi/agent/skills/

# 验证安装
ls ~/.pi/agent/skills/
# 应该看到：loop-audit, loop-init, loop-triage, loop-cost
```

### 4. 测试集成

```bash
# 在 pi 中运行审计
+loop-score

# 或手动运行
npx @kevinzhangnothing/loop-audit .
```

---

## 可用技能 (Skills)

### loop-audit

**描述**: Loop Readiness Score 审计专家

**触发词**: "审计项目", "loop audit", "检查 loop 就绪度", "loop 评分"

**用法**:
```bash
# 基础审计
npx @kevinzhangnothing/loop-audit .

# 获取改进建议
npx @kevinzhangnothing/loop-audit . --suggest

# JSON 输出
npx @kevinzhangnothing/loop-audit . --json

# 生成 README 徽章
npx @kevinzhangnothing/loop-audit . --badge
```

**输出示例**:
```
Loop Readiness Audit — /path/to/project
══════════════════════════════════════════════════
Score: 85/100  Level: L2

Findings:
  ✓ State file(s): STATE.md
  ✓ Triage skill present.
  ...
```

---

### loop-init

**描述**: Loop 脚手架生成器

**触发词**: "初始化 loop", "loop init", "搭建 loop 工程", "创建脚手架"

**用法**:
```bash
# 默认初始化 (Daily Triage + Grok)
npx @kevinzhangnothing/loop-init .

# 指定模式和工具
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool claude

# 预览变更
npx @kevinzhangnothing/loop-init . --dry-run
```

**生成的文件**:
```
project/
├── STATE.md
├── loop-budget.md
├── loop-run-log.md
├── loop-constraints.md
└── skills/
    ├── loop-triage/SKILL.md
    └── loop-budget/SKILL.md
```

---

### loop-triage

**描述**: 日常任务分类专家

**触发词**: "日常分类", "triage report", "CI 失败", "Issue 分类"

**用法**:
```
/loop 1d Run loop-triage. Update STATE.md.
```

**输出格式**:
```markdown
# Triage Report — 2026-07-09

## High-Priority Items
- **CI Failure: test-suite failing**
  - Impact: Blocking all PR merges
  - Suggested: Draft minimal fix
  - Effort: ~15 min

## Watch Items
- PR #456 needs rebase

## Noise / Ignore
- Flaky test (already tracked)

## State Updates
- CI passing after fix
```

---

### loop-cost

**描述**: Token 花费估算器

**触发词**: "token 花费", "loop cost", "预算估算", "花费多少"

**用法**:
```bash
# 估算 Daily Triage L1 花费
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1

# 估算 CI Sweeper (高花费)
npx @kevinzhangnothing/loop-cost --pattern ci-sweeper --cadence 15m

# JSON 输出
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1 --json
```

**输出示例**:
```
Pattern: daily-triage (L1)
Cadence: 1d

Estimated tokens per run:
  No-op:    5,000
  Report:   50,000
  Action:   200,000

Suggested daily cap: 100,000
Early exit required: No
```

---

### 完整 Skill 清单（pi 包内 12 个）

| Skill | 等级 | 触发词 | 用途 |
|-------|------|--------|------|
| `loop-audit` | L1 | "审计项目", "loop 评分" | Loop Readiness Score 审计 |
| `loop-init` | L1 | "初始化 loop", "创建脚手架" | 脚手架生成器（7 patterns × 4 tools） |
| `loop-triage` | L1 | "日常分类", "triage report" | 日常任务分类（CI/Issue/PR） |
| `loop-cost` | L1 | "token 花费", "预算估算" | Token 花费估算（JSON 输出） |
| `loop-budget` | L1 | "loop budget", "kill switch" | Token 预算守护（运行前后检查） |
| `loop-verifier` | L2 | "verify", "maker/checker" | 独立验证器（永远找拒绝理由） |
| `minimal-fix` | L2 | "fix this", "minimal patch" | 最小修复实现（最小 diff） |
| `loop-sync` | L1 | "loop drift", "STATE.md LOOP.md" | Drift detection（包装 `loop-sync` CLI） |
| `loop-guard` | L2 | "circuit breaker", "熔断器" | 电路熔断器（包装 `loop-context --check`） |
| `ci-triage` | L2 | "CI failure", "flake check" | CI 失败分类（flake/regression/env/config） |
| `pr-review-triage` | L2 | "PR status", "review queue" | PR 状态分类（CI/reviews/merge） |
| `rebase-and-clean` | L2 | "rebase PR", "clean commits" | PR rebase 与清理 |

**L1 = 报告/只读**，可被任何 pi 会话调用。
**L2 = 修复类**，需要人工 gate（merge/force-push 由人类决定）。

### 三个新增 skill 详解（v2）

#### loop-sync

包装 `@kevinzhangnothing/loop-sync` CLI，检测 `STATE.md`/`LOOP.md`/`AGENTS.md` 之间的 drift：

```bash
# 默认报告
npx @kevinzhangnothing/loop-sync .

# JSON 供 CI / STATE.md append
npx @kevinzhangnothing/loop-sync . --json

# 预览 auto-fix（不实际写）
npx @kevinzhangnothing/loop-sync . --auto-fix --dry-run
```

Score < 40 (`critical`) → **STOP** + escalate-human。详见 [pi/skills/loop-sync/SKILL.md](../pi/skills/loop-sync/SKILL.md)。

#### loop-guard

电路熔断器，包装 `@kevinzhangnothing/loop-context --check`：

```bash
# 每个 fix 迭代前
npx @kevinzhangnothing/loop-context --check --ledger loop-ledger.json --token-budget "$BUDGET"
# exit 0 = continue, exit 2 = escalate
```

Token budget 自动从 `loop-cost --pattern <p> --level <L>` 的 `scenarios.realistic.tokensPerRun` 派生。仅对**修复类** pattern 生效（ci-sweeper, pr-babysitter, dependency-sweeper, post-merge-cleanup）。详见 [pi/skills/loop-guard/SKILL.md](../pi/skills/loop-guard/SKILL.md)。

#### rebase-and-clean

PR 看护专用，**强制遵守** `loop-constraints.md`：

- **不允许**对 `main`/`master`/`release/*` force-push
- **不允许**触碰 denylist 路径（`.env`, `auth/`, `payments/`, `secrets/`）
- 每次 rebase attempt 必须写入 `loop-ledger.json`（与 `loop-guard` 联动）
- **不允许**超过 3 次 rebase attempt，否则熔断器跳闸

通过 `npx @kevinzhangnothing/loop-worktree create --run-id <id> --pattern pr-babysitter` 隔离 worktree。详见 [pi/skills/rebase-and-clean/SKILL.md](../pi/skills/rebase-and-clean/SKILL.md)。

---

## Shortcuts (快捷键)

pi 支持快捷键快速执行常用命令。在 `~/.pi/agent/mcp.json` 中配置：

| 快捷键 | 描述 | 命令 |
|--------|------|------|
| `+loop-score` | 审计当前项目 | `npx @kevinzhangnothing/loop-audit .` |
| `+loop-score-suggest` | 获取改进建议 | `npx @kevinzhangnothing/loop-audit . --suggest` |
| `+loop-init` | 初始化脚手架 | `npx @kevinzhangnothing/loop-init . -p daily-triage -t claude` |
| `+loop-cost` | 估算 token 花费 | `npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1` |
| `+loop-state` | 查看 STATE.md | `cat STATE.md` |
| `+loop-log` | 查看运行日志 | `tail -20 loop-run-log.md` |

**使用方式**:
```
在 pi 中输入：+loop-score
```

---

## Workflows

### Daily Triage (每日分类)

**文件**: `pi/workflows/daily-triage.yaml`

**触发**: 工作日早上 9 点

**功能**:
- 扫描 CI 失败
- 检查 Open Issues
- 查看最近提交
- 生成优先级报告
- 更新 STATE.md

**配置**:
```yaml
name: daily-triage
trigger:
  cron: '0 9 * * 1-5'
level: L1
budget:
  daily_cap: 100000
```

---

### PR Babysitter (PR 看护)

**文件**: `pi/workflows/pr-babysitter.yaml`

**触发**: 每 15 分钟

**功能**:
- 监控 PR 状态
- 自动 rebase
- CI 失败重试
- 通知审查者

**配置**:
```yaml
name: pr-babysitter
trigger:
  cron: '*/15 * * * *'
level: L2
auto_merge: false
```

---

### CI Sweeper (CI 自动修复)

**文件**: `pi/workflows/ci-sweeper.yaml`

**触发**: 每 10 分钟或事件驱动

**功能**:
- 检测 CI 失败
- 分类问题类型
- 尝试最小修复
- 熔断器保护

**配置**:
```yaml
name: ci-sweeper
trigger:
  cron: '*/10 * * * *'
level: L2
circuit_breaker:
  enabled: true
  same_error_count: 3
```

---

## MCP 服务器资源

Loop Engineering MCP 服务器提供以下资源：

### Resources

| URI | 描述 |
|-----|------|
| `loop://registry` | 所有 patterns 的注册表 |
| `loop://config` | LOOP.md 配置 |
| `loop://budget` | loop-budget.md 预算配置 |
| `loop://run-log` | loop-run-log.md 运行历史 |
| `loop://safety` | 安全文档 |
| `loop://patterns/*` | 指定 pattern 的完整文档（通配符） |
| `loop://skills/*` | 指定 skill 的定义（通配符） |
| `loop://state/*` | 状态文件内容（通配符） |

### Tools

| Tool | 描述 |
|------|------|
| `loop_list_patterns` | 列出所有 patterns |
| `loop_list_skills` | 列出所有 skills |
| `loop_list_state_files` | 列出状态文件 |
| `loop_get_pattern` | 获取 pattern 详情 |
| `loop_get_skill` | 获取 skill 定义 |
| `loop_get_state` | 读取状态文件 |
| `loop_recommend_pattern` | 根据用例推荐 pattern |

> **注意**: Token 花费估算请使用独立的 `LoopCost` MCP 服务器（`estimate` / `estimate:json` 工具），避免与 `LoopEngineering` 服务器功能重复。

---

## 典型工作流

### 场景 1: 新项目初始化

```bash
# 1. 在 pi 中初始化
+loop-init

# 2. 审计项目
+loop-score

# 3. 估算花费
+loop-cost

# 4. 开始运行
/loop 1d Run loop-triage. Update STATE.md. No auto-fix in week one.
```

### 场景 2: 查看项目状态

```bash
# 1. 查看 STATE.md
+loop-state

# 2. 查看运行日志
+loop-log

# 3. 重新审计
+loop-score-suggest
```

### 场景 3: 添加新 Pattern

```bash
# 1. 查询可用 patterns
loop_list_patterns

# 2. 获取 pattern 详情
loop_get_pattern --id ci-sweeper

# 3. 估算花费
npx @kevinzhangnothing/loop-cost --pattern ci-sweeper --level L2

# 4. 初始化
npx @kevinzhangnothing/loop-init . --pattern ci-sweeper --tool claude
```

---

## 最佳实践

### 1. 从 L1 开始

第一周只使用 **L1 报告模式**，观察实际花费和行为：

```bash
/loop 1d Run loop-triage. Report only.
```

### 2. 设置预算上限

在 `loop-budget.md` 中设置合理的日上限：

```markdown
## Daily Cap
- Pattern: daily-triage
- Level: L1
- Suggested cap: 100,000 tokens/day
```

### 3. 使用熔断器

对于 L2/L3 模式，配置熔断器防止无限循环：

```yaml
circuit_breaker:
  enabled: true
  same_error_count: 3
  no_progress_runs: 5
```

### 4. 定期检查日志

```bash
# 每周检查运行日志
tail -50 loop-run-log.md
```

### 5. 渐进式自动化

```
Week 1: L1 report-only
Week 2: L2 with human gate
Week 3+: L3 for safe patterns only
```

---

## 故障排除

### 问题 1: MCP 服务器无法连接

```bash
# 检查 npx 是否可用
which npx

# 手动测试 MCP 服务器
npx -y @kevinzhangnothing/loop-mcp-server
```

### 问题 2: Skills 未加载

```bash
# 检查技能目录
ls ~/.pi/agent/skills/loop-*

# 重新复制技能
cp -r /path/to/loop-engineering/pi/skills/loop-* ~/.pi/agent/skills/
```

### 问题 3: Token 花费过高

```bash
# 检查当前花费
+loop-cost

# 降低 cadence 频率
# 从 15m 改为 1h 或 1d

# 设置更严格的预算上限
# 编辑 loop-budget.md
```

### 问题 4: STATE.md 未更新

```bash
# 检查技能是否有写入权限
ls -la STATE.md

# 手动运行 triage
npx @kevinzhangnothing/loop-audit . --suggest
```

---

## 相关文件

| 文件 | 位置 | 描述 |
|------|------|------|
| Skills | `pi/skills/` | pi 格式的技能定义 |
| Workflows | `pi/workflows/` | Workflow YAML 定义 |
| MCP 配置 | `pi/mcp.json` | MCP 服务器配置 |
| 评估配置 | `pi/skills/*/eval.yaml` | 技能评估标准 |

---

## 参考资源

- [loop-engineering README](../README.md)
- [Patterns Registry](../patterns/registry.yaml)
- [Quick Start](./QUICKSTART.md)
- [Pattern Picker](./pattern-picker.md)
- [Safety Guide](./safety.md)

---

*最后更新：2026-07-09*
