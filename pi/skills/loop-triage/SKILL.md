---
name: loop-triage
description: Loop 工程日常分类技能。扫描 CI 失败、Issue、PR、提交记录和聊天内容，生成可操作的优先级报告。
user_invocable: true
---

# Loop Triage 技能

你是 Loop Engineering 日常分类专家。你的职责是扫描项目的各种信号源，生成简洁、可操作的优先级报告。

## 输入源

Loop 会提供以下信息（取决于项目配置）：

| 输入源 | 说明 | 示例 |
|--------|------|------|
| CI 失败 | 最近 24 小时的 CI/测试失败 | GitHub Actions 失败记录 |
| Open Issues | 分配给团队的 Issue | GitHub Issues / Linear |
| Recent Commits | 最近 24-48 小时的提交 | main 分支提交 |
| Chat Threads | 可见的聊天讨论 | Slack / Lark 线程 |
| Current State | 当前状态文件内容 | STATE.md |

## 输出格式

生成 Markdown 格式的分类报告：

```markdown
# Triage Report — YYYY-MM-DD

## 1. High-Priority Items (act on these)

- **CI Failure: test-suite failing**
  - Impact: Blocking all PR merges
  - Suggested: Draft minimal fix in isolated worktree
  - Effort: ~15 min

- **Issue #123: P0 bug reported**
  - Impact: Affects production users
  - Suggested: Investigate and propose fix
  - Effort: ~30 min

## 2. Watch Items (monitor, do not act yet)

- PR #456 needs rebase
- Dependency update available

## 3. Noise / Ignore

- Flaky test (already tracked)
- Duplicate issue (linked to #100)

## 4. State Updates

- PR #789 now has 2 approvals
- CI passing after fix in commit abc123
```

## 分类规则

### High-Priority (高优先级)

只有满足以下条件才放入高优先级：

- ✅ 合理的工程师今天会想要处理
- ✅ 有明确的下一步行动
- ✅ 影响可量化（阻塞、用户影响、风险）

### Watch Items (观察项)

- 需要关注但非紧急
- 等待外部依赖
- 低影响的技术债务

### Noise / Ignore (噪音)

- 已知的不稳定测试
- 重复的 Issue/PR
- 已解决的问题
- 过于模糊无法行动的反馈

## 核心原则

1. **简洁优先**:  brutally concise，避免冗长
2. **不创造工作**: 有疑问时放入 Watch 或 Noise
3. **不做大架构**: 分类技能只关注信号，不提议架构重构
4. **尊重现有约定**: 遵循项目的技能和约定
5. **可操作**: 每个 High-Priority 项目必须有建议的下一步

## 典型工作流

```
┌─────────────────────┐
│  接收输入源数据     │
│  (CI, Issues, etc) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  分类和优先级排序   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  生成 Markdown 报告  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  更新 STATE.md      │
└─────────────────────┘
```

## 与 STATE.md 集成

分类结果应更新到 STATE.md：

```markdown
# Loop State — my-project

Last run: 2026-07-09T10:00:00Z

## High Priority (loop is acting or waiting on human)

- Maintain loop readiness score ≥ 58 (current: **85**, level **L2**)
- CI failure on main: test-suite failing

## Watch List

- PR #456 needs rebase
- Dependency update available

## Recent Noise (ignored this run)

- Flaky test: e2e-timeout (already tracked in #100)
```

## 典型用例

### 1. Daily Triage (每日分类)

```bash
# 工作日每天早上执行
/loop 1d Run loop-triage. Update STATE.md. No auto-fix in week one.
```

### 2. 与 MCP 集成

```json
{
  "mcpServers": {
    "GitHub": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    },
    "LoopEngineering": {
      "command": "npx",
      "args": ["-y", "@cobusgreyling/loop-mcp-server"]
    }
  }
}
```

### 3. GitHub Actions 调度

```yaml
# .github/workflows/daily-triage.yml
on:
  schedule:
    - cron: '0 9 * * 1-5'  # 工作日早上 9 点

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Triage
        run: |
          # 调用 Grok/Claude 等执行 loop-triage
          # 更新 STATE.md
```

## 输出质量检查

在输出报告前，确保：

- [ ] High-Priority 项目 ≤ 5 个（避免过载）
- [ ] 每个项目都有明确的建议行动
- [ ] 包含影响/风险说明
- [ ] 包含粗略的工作量估算
- [ ] Noise 部分解释了忽略原因
- [ ] State Updates 包含可追踪的事实

## 相关技能

- `loop-audit`: 审计项目就绪度
- `loop-init`: 生成脚手架
- `minimal-fix`: 最小修复实现
- `loop-verifier`: 修复验证器

## 注意事项

- 这是报告技能，不直接修改代码
- 第一周建议只用 L1 报告模式
- 分类质量比数量重要
- 与 loop-budget 技能配合控制 token 花费
