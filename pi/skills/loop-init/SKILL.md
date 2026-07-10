---
name: loop-init
description: Agent Loops 脚手架生成器。为项目快速搭建 Loop 工程结构，包括技能、状态、预算和约束文件。
user_invocable: true
---

# Loop Init 技能

你是 Agent Loops 脚手架生成专家。你的职责是为新项目快速搭建完整的 Loop 工程结构。

## 能力

- 根据模式 (pattern) 和工具 (tool) 生成脚手架
- 自动计算并显示 Loop Ready 评分
- 生成技能模板、状态文件、预算配置
- 为修复类模式配置熔断器 (loop-guard + ledger)

## 使用方式

### 基础脚手架

```bash
npx @kevinzhangnothing/loop-init <project-path> --pattern <pattern> --tool <tool>
```

### 快速模式（使用默认值）

```bash
# Grok + Daily Triage（默认）
npx @kevinzhangnothing/loop-init .

# 简写
npx @kevinzhangnothing/loop-init . -p daily-triage -t grok
```

### 干运行（预览变更）

```bash
npx @kevinzhangnothing/loop-init . --pattern daily-triage --dry-run
```

## 支持的模式 (Patterns)

| 模式 | 描述 | 默认状态文件 | 等级 |
|------|------|-------------|------|
| `daily-triage` | 日常任务分类 | STATE.md | L1 |
| `pr-babysitter` | PR 看护与合并 | pr-babysitter-state.md | L2 |
| `ci-sweeper` | CI 失败自动修复 | ci-sweeper-state.md | L2 |
| `dependency-sweeper` | 依赖更新 | dependency-sweeper-state.md | L2 |
| `post-merge-cleanup` | 合并后清理 | post-merge-state.md | L1 |
| `changelog-drafter` | 发布说明生成 | changelog-drafter-state.md | L1 |
| `issue-triage` | Issue 分类 | issue-triage-state.md | L1 |

## 支持的工具 (Tools)

| 工具 | 参数值 | 说明 |
|------|--------|------|
| Grok | `grok` (默认) | xAI Grok |
| Claude Code | `claude` | Anthropic Claude Code |
| Codex | `codex` | OpenAI Codex |
| Opencode | `opencode` | 开源 CLI 工具 |

## 生成的文件

### 所有模式都会生成

```
<project>/
├── STATE.md (或模式特定的状态文件)
├── loop-budget.md
├── loop-run-log.md
├── loop-constraints.md
└── skills/
    ├── loop-triage/
    │   └── SKILL.md
    └── loop-budget/
        └── SKILL.md
```

### L2 修复类模式额外生成

```
skills/
├── minimal-fix/
│   └── SKILL.md
├── loop-verifier/
│   └── SKILL.md
└── loop-guard/
    └── SKILL.md
loop-ledger.json (熔断器日志)
```

## 熔断器 (Circuit Breaker)

对于可修复的模式（pr-babysitter, ci-sweeper, dependency-sweeper, post-merge-cleanup），会自动配置熔断器：

- **loop-guard 技能**: 每次尝试前检查熔断状态
- **loop-ledger.json**: 记录每次尝试、错误签名、token 花费
- **自动熔断条件**:
  - 相同错误连续发生 N 次
  - 连续失败无进展
  - Token 超出预算
  - 达到最大迭代次数

## 典型用例

### 1. 新项目快速启动

```bash
# 5 分钟完成脚手架
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok

# 查看审计结果
npx @kevinzhangnothing/loop-audit . --suggest

# 估算 token 花费
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1
```

### 2. Opencode 项目

```bash
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool opencode
```

这会生成 `opencode.json` 配置和 `AGENTS.md` 文件。

### 3. 多模式项目

```bash
# 先搭建 Daily Triage
npx @kevinzhangnothing/loop-init . -p daily-triage -t claude

# 再添加 CI Sweeper
npx @kevinzhangnothing/loop-init . -p ci-sweeper -t claude
```

## 输出示例

```
Loop Init — scaffolding daily-triage for grok

Created:
  ✓ STATE.md
  ✓ loop-budget.md
  ✓ loop-run-log.md
  ✓ loop-constraints.md
  ✓ skills/loop-triage/SKILL.md
  ✓ skills/loop-budget/SKILL.md

Loop Ready Score: 55/100 (L1)

Next steps:
  1. Run: npx @kevinzhangnothing/loop-audit . --suggest
  2. Start loop: /loop 1d Run loop-triage. Update STATE.md.
```

## 后续步骤

脚手架完成后，建议执行：

```bash
# 1. 审计项目获取改进建议
npx @kevinzhangnothing/loop-audit . --suggest

# 2. 估算 token 花费
npx @kevinzhangnothing/loop-cost --pattern <pattern> --level L1

# 3. 运行第一次报告
# 根据工具不同，执行对应的 loop 命令
```

## 相关技能

- `loop-audit`: 就绪度审计
- `loop-cost`: Token 花费估算
- `loop-sync`: 状态文件一致性检查

## 注意事项

- 脚手架不会覆盖现有文件（会提示冲突）
- 使用 `--dry-run` 预览变更
- L2 模式的熔断器需要额外配置 token 预算
- 第一次运行建议先用 L1 报告模式
