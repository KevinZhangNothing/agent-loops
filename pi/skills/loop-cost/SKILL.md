---
name: loop-cost
description: Loop Token 花费估算器。估算不同模式和等级的 token 消耗，帮助设置预算上限和 cadence 频率。
user_invocable: true
---

# Loop Cost 技能

你是 Loop Engineering Token 花费估算专家。你的职责是帮助团队理解和控制 Loop 自动化带来的 token 成本。

## 能力

- 估算不同 Pattern 的 token 消耗
- 根据等级 (L1/L2/L3) 计算花费差异
- 建议合理的每日预算上限
- 提供 cadence 频率优化建议

## 使用方式

### 基础估算

```bash
npx @kevinzhangnothing/loop-cost --pattern <pattern> --level <L1|L2|L3>
```

### 指定 cadence

```bash
npx @kevinzhangnothing/loop-cost --pattern ci-sweeper --cadence 15m
```

### JSON 输出

```bash
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1 --json
```

## Token 估算模型

每个 Pattern 有三种运行场景：

| 场景 | 说明 | Token 范围 |
|------|------|----------|
| No-op | 无发现，直接退出 | 3,000 - 5,000 |
| Report | 发现项目，生成报告 | 30,000 - 80,000 |
| Action | 发现 + 修复 + 验证 | 150,000 - 300,000 |

### 等级差异

| 等级 | 行为 | Token 影响 |
|------|------|----------|
| L1 | 只报告，不行动 | 最低 |
| L2 | 辅助修复（需人工确认） | 中等 |
| L3 | 全自动修复 | 最高 |

## Pattern 成本参考

| Pattern | No-op | Report | Action | 建议日上限 | 需要早停 |
|---------|-------|--------|--------|-----------|----------|
| daily-triage | 5k | 50k | 200k | 100k | ❌ |
| pr-babysitter | 3k | 80k | 250k | 200k | ✅ |
| ci-sweeper | 5k | 50k | 200k | 1M | ✅ |
| dependency-sweeper | 5k | 60k | 300k | 500k | ✅ |
| post-merge-cleanup | 5k | 40k | 150k | 200k | ❌ |
| changelog-drafter | 5k | 35k | 80k | 100k | ❌ |
| issue-triage | 3k | 30k | 60k | 80k | ❌ |

## 典型用例

### 1. 新项目预算规划

```bash
# 估算 Daily Triage L1 的花费
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1

# 输出示例：
# Pattern: daily-triage (L1)
# Cadence: 1d
# Estimated tokens per run:
#   No-op:    5,000
#   Report:   50,000
#   Action:   200,000
# Suggested daily cap: 100,000
# Early exit required: No
```

### 2. CI Sweeper 预算（高花费场景）

```bash
# CI Sweeper 通常花费较高
npx @kevinzhangnothing/loop-cost --pattern ci-sweeper --cadence 15m

# 建议：
# - 设置较高的日上限 (1M tokens)
# - 必须配置早停机制
# - 考虑 branch 白名单限制
```

### 3. 生成 loop-budget.md

```bash
# 获取估算后，创建预算文件
cat > loop-budget.md << 'EOF'
# Loop Budget

## Daily Cap
- Pattern: daily-triage
- Level: L1
- Suggested cap: 100,000 tokens/day

## Kill Switch
Set `LOOP_KILL=true` to immediately stop all loops.

## Per-Run Limits
- No-op: 5,000 tokens
- Report: 50,000 tokens
- Action: 200,000 tokens
EOF
```

## 成本优化策略

### 1. 选择合适的 Cadence

| Pattern | 推荐 Cadence | 原因 |
|---------|-------------|------|
| daily-triage | 1d - 2h | 信息积累需要时间 |
| pr-babysitter | 5m - 15m | PR 状态变化快 |
| ci-sweeper | 5m - 15m | 快速响应失败 |
| dependency-sweeper | 6h - 1d | 依赖更新不紧急 |

### 2. 早停机制 (Early Exit)

对于标记为「需要早停」的 Pattern：

```yaml
# loop-budget.md
early_exit:
  enabled: true
  conditions:
    - same_error_count: 3
    - no_progress_runs: 5
    - token_budget_exceeded: true
```

### 3. Branch 白名单

限制 Loop 只在特定分支行动：

```yaml
# loop-constraints.md
allowed_branches:
  - main
  - develop
  - "hotfix/*"
```

### 4. 分阶段 rollout

```
Week 1: L1 report-only (观察花费)
Week 2: L2 with human gate (控制行动)
Week 3+: L3 for safe patterns only (自动化)
```

## 与 loop-budget 集成

```bash
# 1. 估算花费
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1

# 2. 创建预算文件
npx @kevinzhangnothing/loop-init . --pattern daily-triage

# 3. 运行时检查
# loop-budget 技能会在每次运行前后检查 token 花费
```

## JSON 输出格式

```json
{
  "pattern": "daily-triage",
  "level": "L1",
  "cadence": "1d",
  "tokens": {
    "noop": 5000,
    "report": 50000,
    "action": 200000
  },
  "suggested_daily_cap": 100000,
  "early_exit_required": false,
  "cost_per_day": {
    "min": 5000,
    "expected": 50000,
    "max": 200000
  },
  "cost_per_month": {
    "min": 150000,
    "expected": 1500000,
    "max": 6000000
  }
}
```

## 成本对比示例

### 场景：小型项目（每天 1-2 个 PR）

| Pattern | 月花费 (tokens) | 月花费 (USD) |
|---------|----------------|-------------|
| daily-triage (L1) | 1.5M | ~$10 |
| pr-babysitter (L2) | 3M | ~$20 |
| **Total** | **4.5M** | **~$30** |

### 场景：活跃项目（每天 10+ PR，频繁 CI）

| Pattern | 月花费 (tokens) | 月花费 (USD) |
|---------|----------------|-------------|
| daily-triage (L1) | 3M | ~$20 |
| pr-babysitter (L2) | 15M | ~$100 |
| ci-sweeper (L2) | 30M | ~$200 |
| **Total** | **48M** | **~$320** |

*注：按 Claude API 价格 ~$15/1M input tokens 估算*

## 相关技能

- `loop-audit`: 审计项目就绪度
- `loop-init`: 生成脚手架
- `loop-budget`: 运行时预算守护

## 注意事项

- Token 价格是估算值，实际花费因项目而异
- 第一周用 L1 模式观察实际花费
- 设置合理的日上限防止意外超支
- 定期检查 loop-run-log.md 追踪实际花费
- 考虑使用 spot instances 或低价时段运行
