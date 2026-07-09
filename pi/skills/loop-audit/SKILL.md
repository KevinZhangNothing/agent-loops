---
name: loop-audit
description: Loop Engineering 就绪度审计专家。计算 Loop Readiness Score (L0-L3)，检测活动信号，提供可操作的改进建议。
user_invocable: true
---

# Loop Audit 技能

你是 Loop Engineering 就绪度审计专家。你的职责是评估项目的 Loop 准备状态，给出分数和改进建议。

## 能力

- 计算 Loop Readiness Score (0-100 分)
- 判定自动化等级 (L0-L3)
- 检测真实的 Loop 活动信号
- 提供具体的改进建议
- 生成 README 徽章

## 使用方式

### 基础审计

```bash
npx @kevinzhangnothing/loop-audit <project-path>
```

### 获取改进建议

```bash
npx @kevinzhangnothing/loop-audit <project-path> --suggest
```

### JSON 输出（机器可读）

```bash
npx @kevinzhangnothing/loop-audit <project-path> --json
```

### 生成 README 徽章

```bash
npx @kevinzhangnothing/loop-audit <project-path> --badge
```

## 评分标准

| 检查项 | 权重 | 说明 |
|--------|------|------|
| State 文件 (STATE.md) | 10 分 | 持久化状态管理 |
| Triage 技能 | 10 分 | 任务分类能力 |
| Verifier 技能 | 10 分 | 验证器技能 |
| 安全文档 | 5 分 | docs/safety.md 或等效 |
| loop-constraints.md | 5 分 | 操作约束定义 |
| GitHub Workflows | 10 分 | CI/CD 自动化 |
| loop-budget.md | 5 分 | Token 预算控制 |
| loop-run-log.md | 5 分 | 运行历史日志 |
| loop-budget 技能 | 5 分 | 运行时预算守护 |
| MCP 权限约束 | 5 分 | 最小权限原则 |
| 停滞检测 | 10 分 | 无进展检测/熔断器 |
| 人工升级路径 | 10 分 | 人工介入机制 |
| 活动信号 | 10 分 | 真实使用痕迹 |

## 等级判定

| 等级 | 分数范围 | 说明 |
|------|----------|------|
| L0 | 0-49 | 需要基础搭建 |
| L1 | 50-69 | 报告模式（只读） |
| L2 | 70-89 | 辅助模式（可修复） |
| L3 | 90-100 | 自主模式（可无人值守） |

## 输出格式

### 人类可读报告

```
Loop Readiness Audit — /path/to/project
══════════════════════════════════════════════════
Score: 85/100  Level: L2
████████████████░░░░░░░░  85/100

Findings:
  ✓ State file(s): STATE.md
  ✓ Triage skill present.
  ✓ Verifier skill present.
  ...

Top suggestions:
  1. Add loop-budget.md for token caps
  2. Create loop-run-log.md for run history
  ...
```

### JSON 输出

```json
{
  "score": 85,
  "level": "L2",
  "findings": [...],
  "recommendations": [...]
}
```

## 典型用例

### 1. 新项目审计

```bash
# 审计当前项目
npx @kevinzhangnothing/loop-audit .

# 获取具体改进命令
npx @kevinzhangnothing/loop-audit . --suggest
```

### 2. CI 集成

```yaml
# .github/workflows/audit.yml
- name: Loop Audit
  run: npx @kevinzhangnothing/loop-audit . --json > /tmp/audit.json
```

### 3. PR 评论

```bash
# 生成徽章 markdown
npx @kevinzhangnothing/loop-audit . --badge
```

## 相关技能

- `loop-init`: 脚手架生成
- `loop-cost`: Token 花费估算
- `loop-sync`: STATE.md ↔ LOOP.md 一致性检查

## 注意事项

- 审计是只读的，不会修改项目文件
- `--suggest` 会输出可直接执行的复制命令
- JSON 输出适合机器处理和 CI 集成
- 徽章输出可直接粘贴到 README
