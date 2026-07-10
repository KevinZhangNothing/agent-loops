# 五个原语 + 记忆

Agent loops 由六个构建块组成。掌握这些，你就可以为任何工具设计 loops。

## 1. 调度 / 自动化

**目的：** 按节奏运行分类，无需手动触发。

| 工具 | 机制 | 示例 |
|------|------|------|
| **Grok** | `/loop [interval]` | `/loop 1d Run loop-triage` |
| **Claude Code** | `/loop`、cron | `/loop 5m /babysit` |
| **Codex** | Automations 标签 | Project → Automations → 1d cadence |
| **Opencode** | cron/systemd | `0 9 * * * opencode run "..."` |
| **Cursor** | Automations | Settings → Automations → cron trigger |
| **GitHub Actions** | Workflow `on.schedule` | `cron: '0 9 * * *'` |

**设计提示：** 从每日节奏开始。仅在 L1 稳定后增加频率。

## 2. 状态 / 记忆

**目的：** 对话外的持久化记忆。Loop 在开始时读取状态，在结束时写入。

**常见模式：**
- `STATE.md` — 通用分类状态
- `issue-triage-state.md` — issue 队列健康
- `ci-sweeper-state.md` — 活动的 CI 失败
- Linear/GitHub Projects — 结构化状态

**`STATE.md` 示例：**
```markdown
## 上次运行
2026-07-10 09:00

## 高优先级
- CI 失败：main 分支的 `test-api`（3 次失败）

## 监控列表
- PR #47：等待审查
- Issue #120：需要复现

## 已完成
- [x] 为 v1.5.0 更新变更日志
```

**设计提示：** 状态必须是**机器可读的**。使用一致的标题、项目符号格式、时间戳。

## 3. 技能

**目的：** 可复用的能力。技能是定义代理应该做什么的 `SKILL.md` 文件。

**结构：**
```markdown
# loop-triage

## 目的
扫描 CI、issues 和 commits。用优先级更新 STATE.md。

## 步骤
1. 读取 STATE.md
2. 检查 main 分支的 CI 状态
3. 扫描新的 issues（过去 24 小时）
4. 扫描新的 commits（过去 24 小时）
5. 更新 STATE.md：高优先级、监控列表、已完成
6. 编写 5 行摘要

## 约束
- 不修改代码
- 不在 issues/PRs 上评论
- 如果 CI 失败超过 3 次则升级
```

**调用：**
- Grok: "运行 loop-triage 技能"
- Claude Code: `$loop-triage`
- Opencode: 从 `skills/` 文件夹自动发现技能

**设计提示：** 技能应该是**工具无关的**。技能描述*做什么*；调度是*如何*调用。

## 4. 工作树

**目的：** 安全的并行执行。每个修复在隔离的 git worktree 中运行。

**为什么需要隔离：**
- 防止并发修改冲突
- 允许安全回滚
- 支持多个并行 loops
- 保持干净的 git 历史

**示例工作流：**
```bash
# Loop 为每次修复创建 worktree
git worktree add -b fix/ci-failure-2026-07-10 ../worktrees/fix-1
cd ../worktrees/fix-1
# ... 应用修复 ...
git add . && git commit -m "Fix CI failure"
cd ../../
git worktree remove ../worktrees/fix-1
```

**设计提示：** 始终为自动修复使用 worktrees。永远不要在主工作树上直接修改。

## 5. 子代理

**目的：** 制作者/检查者分离。一个代理执行工作，另一个验证。

**为什么需要验证：**
- 捕捉无意的错误
- 确保更改符合约束
- 防止 loop 漂移
- 建立信任

**示例模式：**
```
实现者子代理:
  - 读取 STATE.md 中的待处理项目
  - 在 worktree 中应用修复
  - 运行测试
  - 提交更改

验证者子代理:
  - 读取实现者的 diff
  - 确认修复解决问题
  - 验证没有意外更改
  - 批准或拒绝合并
```

**设计提示：** 验证者应该**独立运行**。不要让它看到实现者的推理，只查看最终 diff。

## + 记忆

**目的：** 跨会话的主干。记忆使 loops 能够随时间学习和适应。

### 记忆组件

| 组件 | 用途 | 示例 |
|------|------|------|
| **LOOP.md** | 活动的 loops 和配置 | 节奏、模式、约束 |
| **STATE.md** | 当前状态 | 待处理项目、失败计数 |
| **运行日志** | 执行历史 | 时间戳、token 花费、结果 |
| **约束** | 操作边界 | 拒绝列表、自动合并策略 |

### 记忆模式

**连续失败跟踪：**
```markdown
## CI Sweeper
连续失败：2
上次失败：2026-07-10 14:30
升级阈值：3
```

**学习模式：**
```markdown
## 学到的教训
- 不要修改 `package-lock.json`（导致冲突）
- 在评论前始终检查现有评论
- 测试运行 > 5 分钟时需要通知
```

**设计提示：** 定期审查记忆。清理过时的条目，记录新模式。

## 组合原语

强大的 loops 组合多个原语：

### 示例：CI Sweeper Loop

```
调度：每 15 分钟（GitHub Actions cron）
状态：ci-sweeper-state.md
技能：ci-sweeper-skill.md
工作树：每次修复一个
子代理：实现者 + 验证者
记忆：连续失败计数、学到的教训
```

**执行流程：**
1. Cron 触发 GitHub Action
2. Loop 读取 `ci-sweeper-state.md`
3. 扫描新的 CI 失败
4. 为每个失败创建 worktree
5. 实现者应用修复
6. 验证者审查 diff
7. 如果通过：合并；如果失败：更新状态
8. 写入更新的状态和运行日志

## 相关文档

- [概念](./concepts.md) — 意图债务、理解债务
- [工具矩阵](./TOOL_MATRIX.md) — 跨工具能力
- [安全](../safety.md) — 拒绝列表、自动合并策略
- [快速入门](../QUICKSTART.md) — 5 分钟从零到第一个 loop
