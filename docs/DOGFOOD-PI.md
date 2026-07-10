# 使用 pi + agent-loops 完善 agent-loops 项目

> **Dogfooding:** 用自己的产品来开发产品。通过 pi 集成，让 agent-loops 自己维护自己。

## 快速开始

### 1. 确认安装

```bash
# 验证 pi 集成
ls ~/.pi/agent/skills | grep loop
ls ~/.pi/agent/workflows
cat ~/.pi/agent/mcp.json | jq '.shortcuts'
```

应该看到：
- 12 个 loop-* skills
- 3 个 workflows (daily-triage, pr-babysitter, ci-sweeper)
- 6 个 shortcuts (+loop-*)

### 2. 初始化 agent-loops 项目

```bash
cd /Users/kevin/Desktop/Nothing/agent-loops

# 在 pi 中运行
+loop-init
```

这会创建：
- `STATE.md` — 项目状态
- `LOOP.md` — 活跃 loops
- `loop-budget.md` — token 预算
- `loop-run-log.md` — 运行日志
- `skills/` — 项目特定 skills

## 工作流

### 日常开发流程

```
┌─────────────────────────────────────────────────────┐
│  1. +loop-score (审计当前状态)                       │
│       ↓                                             │
│  2. +loop-score-suggest (获取改进建议)               │
│       ↓                                             │
│  3. 实现建议 (手动或通过 loop)                       │
│       ↓                                             │
│  4. +loop-score (验证改进)                           │
│       ↓                                             │
│  5. 提交到 GitHub                                    │
└─────────────────────────────────────────────────────┘
```

### 在 pi 中的实际操作

#### 场景 1: 审计项目状态

```
+loop-score
```

输出示例：
```
Loop Readiness Audit — /Users/kevin/Desktop/Nothing/agent-loops
Score: 85/100 (L2)
Assessment: Strong loop readiness — good candidate for L2 with worktrees.

Signals:
✓ State file: STATE.md
✓ Loop config: LOOP.md
✓ Skills: 12 loop skills detected
✓ Run log: 45 runs logged
✓ Worktrees: enabled

Recommendations:
1. Add CI sweeper workflow for automated testing
2. Enable loop-guard for circuit breaker
3. Update docs after npm publish
```

#### 场景 2: 获取具体改进建议

```
+loop-score-suggest
```

输出示例：
```
## Improvement Suggestions

### High Priority
1. **Add CI sweeper** — Auto-fix failing CI checks
   Command: npx @kevinzhangnothing/loop-init . --pattern ci-sweeper --tool claude
   
2. **Enable circuit breaker** — Prevent infinite fix loops
   File: Create loop-constraints.md with:
   ```markdown
   ## Attempt Cap
   - Max 3 fix attempts per issue
   - On 4th failure: escalate to human
   ```

### Medium Priority
3. **Update documentation** — Add pi integration examples
   File: docs/PI-INTEGRATION.md
   Action: Add dogfooding section with real examples

4. **Add token cost tracking** — Monitor daily spend
   Command: +loop-cost daily-triage L2
```

#### 场景 3: 估算 Token 花费

```
+loop-cost
```

输出示例：
```
Pattern: daily-triage
Level: L2
Cadence: 1d
Est. tokens/run: 2K-5K
Est. tokens/day: 2K-5K
Est. cost/day: $0.04-0.10 (at $20/1M tokens)
```

#### 场景 4: 查看项目状态

```
+loop-state
```

输出示例：
```markdown
## Last run
2026-07-10 09:00

## High Priority
- [ ] Fix npm publish script (CI failing)
- [ ] Update SECURITY.md with npm versions

## Watch List
- [ ] GitHub settings (description, topics)
- [ ] Social preview image

## Completed
- [x] pi integration install script
- [x] 12 skills installed
- [x] 3 workflows configured
```

## 具体任务示例

### 任务 1: 完善 GitHub 仓库设置

**在 pi 中运行：**
```
使用 loop-audit 审计项目，然后帮我完成 docs/GITHUB-SETTINGS.md 中列出的所有待办事项。
当前需要：
1. 更新 GitHub 仓库的 Description
2. 添加 Topics
3. 配置 Social Preview

请逐步指导我完成，并在每步后验证。
```

**期望输出：**
```
## Step 1: 更新 GitHub Description

当前状态：❌ 没有 description
推荐描述："Practical reference for agent loop patterns..."

操作步骤：
1. 打开 https://github.com/KevinZhangNothing/agent-loops
2. 点击右侧 About 旁的 ⚙️
3. 粘贴描述...

验证命令：
curl -s https://api.github.com/repos/KevinZhangNothing/agent-loops | jq .description
```

### 任务 2: 优化 pi 集成

**在 pi 中运行：**
```
我需要优化 pi 集成。请：
1. 运行 +loop-score-suggest 获取改进建议
2. 针对每条建议，给出具体的实现步骤
3. 帮我生成需要修改的文件内容
4. 验证修改后的效果

从最高优先级的建议开始。
```

**期望输出：**
```
## 优先级 1: 修复 install.sh 的 skill 复制问题

问题：cp -r "$skill" "$dst_dir/" 应该改为 cp -r "$skill" "$dst_dir/$skill_name/"

修复步骤：
1. 打开 pi/install.sh
2. 找到第 X 行
3. 替换...

验证：
./install.sh --dry-run
```

### 任务 3: 自动化文档更新

**在 pi 中运行：**
```
创建一个 daily-triage workflow，每天自动：
1. 检查 GitHub Issues 新动态
2. 检查 npm 包下载量
3. 更新 STATE.md
4. 生成日报

请帮我配置这个 workflow。
```

**期望输出：**
```yaml
# .github/workflows/daily-triage.yaml
name: Daily Triage

on:
  schedule:
    - cron: '0 9 * * *'  # 每天 9am UTC

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run loop-triage
        run: npx @kevinzhangnothing/loop-triage
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 最佳实践

### 1. 从 L1 开始（报告模式）

第一周只运行审计，不自动修改：
```
+loop-score  # 只读
+loop-state  # 只读
```

### 2. 渐进式自动化

```
Week 1: +loop-score (报告)
Week 2: +loop-init (脚手架)
Week 3: +loop-cost (预算跟踪)
Week 4: workflows (自动化)
```

### 3. 设置预算限制

在 `loop-budget.md` 中：
```markdown
## Daily token budget
- Max: 500K tokens/day
- Current: 127K (25%)
- Kill switch: 1M tokens/day

## Alert threshold
- Notify at 80% (400K tokens)
```

### 4. 使用熔断器

在 `loop-constraints.md` 中：
```markdown
## Attempt Cap
- Max 3 fix attempts per issue
- On 4th failure: escalate to human
- Log failure in loop-run-log.md

## Denylist Paths
- `.env*`
- `**/*.key`
- `package-lock.json` (require explicit approval)
```

## 常见问题

### Q: 如何验证 pi 集成是否工作？

**A:** 运行以下命令：
```bash
# 1. 检查 skills
ls ~/.pi/agent/skills | grep loop

# 2. 检查 workflows
ls ~/.pi/agent/workflows

# 3. 测试 shortcut
+loop-score

# 4. 验证 MCP 服务器
npx @kevinzhangnothing/loop-mcp-server --help
```

### Q: 如何追踪 agent-loops 自己的改进？

**A:** 使用 STATE.md 和 loop-run-log.md：
```markdown
# STATE.md
## 2026-07-10 Improvements
- [x] Fixed pi install.sh skill copy
- [x] Added GITHUB-SETTINGS.md
- [ ] Pending: Update GitHub topics
```

### Q: 如何平衡自动化和手动控制？

**A:** 遵循 L1→L2→L3 渐进：
- **L1:** 只报告，不修改
- **L2:** 辅助修改，人工审核
- **L3:** 完全自动化（仅限 allowlist）

## 下一步

1. **运行第一次审计:**
   ```
   +loop-score
   ```

2. **选择改进建议:**
   ```
   +loop-score-suggest
   ```

3. **实现并验证:**
   ```
   # 实现建议后
   +loop-score  # 验证分数提升
   ```

4. **提交到 GitHub:**
   ```bash
   git add -A
   git commit -m "improve: <description>"
   git push
   ```

5. **重复循环:**
   ```
   +loop-score → +loop-score-suggest → 实现 → 验证 → 提交
   ```

---

*Last updated: 2026-07-10*
