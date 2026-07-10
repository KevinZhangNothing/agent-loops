# 开始使用 pi + agent-loops 改进项目

**5 分钟快速启动指南**

## 前提条件

- ✅ 已安装 pi coding agent
- ✅ 已运行 `pi/install.sh` 安装 agent-loops 集成
- ✅ 有 agent-loops 项目代码

## 第 1 步：验证安装 (30 秒)

```bash
# 检查 skills
ls ~/.pi/agent/skills | grep loop
# 应该看到 12 个 loop-* skills

# 检查 workflows
ls ~/.pi/agent/workflows
# 应该看到 3 个 workflows

# 检查 shortcuts
cat ~/.pi/agent/mcp.json | jq '.shortcuts | keys'
# 应该看到 6 个 shortcuts
```

## 第 2 步：第一次审计 (1 分钟)

**在 pi 中运行：**
```
+loop-score
```

**你会看到：**
```
Loop Readiness Audit — /path/to/agent-loops
Score: XX/100 (LX)

Signals:
✓ State file: STATE.md
✓ Loop config: LOOP.md
✓ Skills: X loop skills detected
...

Recommendations:
1. ...
2. ...
```

**记录分数！** 这是你的基线。

## 第 3 步：获取改进建议 (1 分钟)

**在 pi 中运行：**
```
+loop-score-suggest
```

**你会看到：**
```markdown
## Improvement Suggestions

### High Priority
1. **Fix npm publish script**
   Command: ...
   
2. **Update SECURITY.md**
   File: ...

### Medium Priority
3. **Add documentation**
   ...
```

## 第 4 步：选择并实现一个改进 (2 分钟)

**选择一个高优先级建议，然后在 pi 中运行：**
```
帮我实现建议 #1: Fix npm publish script

请：
1. 诊断问题根因
2. 给出修复方案
3. 生成修复后的代码
4. 提供验证步骤
```

**pi 会输出：**
```markdown
## 问题分析

当前问题：...

修复方案：
1. 打开文件 X
2. 修改第 Y 行
3. 替换为...

修复后的代码：
[完整代码]

验证步骤：
1. 运行命令 A
2. 检查输出 B
```

## 第 5 步：验证改进 (30 秒)

**实现后，在 pi 中运行：**
```
+loop-score
```

**分数应该提升！** 🎉

## 第 6 步：提交到 GitHub (30 秒)

```bash
git add -A
git commit -m "improve: <description>"
git push
```

## 循环重复

```
+loop-score → +loop-score-suggest → 实现 → 验证 → 提交
```

## 常用 Commands

### 审计类

| Command | 描述 | 何时使用 |
|---------|------|---------|
| `+loop-score` | 审计当前状态 | 每天开始工作时 |
| `+loop-score-suggest` | 获取改进建议 | 需要知道做什么时 |
| `+loop-score-json` | JSON 格式输出 | 需要解析结果时 |
| `+loop-badge` | 生成 README 徽章 | 更新文档时 |

### 初始化类

| Command | 描述 | 何时使用 |
|---------|------|---------|
| `+loop-init` | 初始化脚手架 | 第一次设置时 |
| `+loop-init-dry-run` | 预览脚手架 | 想看看会创建什么时 |

### 成本类

| Command | 描述 | 何时使用 |
|---------|------|---------|
| `+loop-cost` | 估算 token 花费 | 选择 pattern 时 |
| `+loop-cost-json` | JSON 格式花费 | 需要解析结果时 |

### 状态类

| Command | 描述 | 何时使用 |
|---------|------|---------|
| `+loop-state` | 查看 STATE.md | 检查当前状态时 |
| `+loop-log` | 查看运行日志 | 调试问题时 |

## 实际场景示例

### 场景 1: 完善文档

**在 pi 中运行：**
```
我需要完善文档。请：
1. 运行 +loop-score-suggest 获取文档相关建议
2. 针对每条建议，给出具体的修改内容
3. 帮我生成修改后的文件
4. 验证修改后的效果
```

### 场景 2: 修复 Bug

**在 pi 中运行：**
```
发现 bug: <描述 bug>

请按照 minimal-fix 技能的模式：
1. 诊断问题根因
2. 给出最小修复方案
3. 生成修复后的代码
4. 提供验证步骤
```

### 场景 3: 优化性能

**在 pi 中运行：**
```
优化 token 花费。请：
1. 运行 +loop-cost 分析当前花费
2. 识别花费最高的 operations
3. 给出优化建议
4. 实现优化
5. 验证优化效果

目标：减少 30% 花费。
```

### 场景 4: 创建新功能

**在 pi 中运行：**
```
我需要添加新功能：<功能描述>

请：
1. 评估是否需要新的 skill 或 workflow
2. 设计实现方案
3. 生成必要的文件
4. 测试功能
5. 更新文档
```

## 每日工作流

### 早上 (5 分钟)

```
1. +loop-score          # 检查当前状态
2. +loop-state          # 查看待办事项
3. 选择今天要完成的任务
```

### 开发中 (按需)

```
1. +loop-score-suggest  # 获取具体建议
2. 实现改进
3. +loop-score          # 验证改进
```

### 晚上 (5 分钟)

```
1. +loop-score          # 对比早上分数
2. 总结今天的改进
3. 更新 loop-run-log.md
4. 规划明天任务
```

## 周工作流

### 周一

```
本周目标：
1. 提升 Loop Readiness Score 从 X → Y
2. 完成 Z 个改进
3. 发布 npm 包更新

请帮我制定详细计划。
```

### 周五

```
本周回顾：
1. 对比周一的分数
2. 列出所有完成的改进
3. 生成周报
4. 规划下周目标
```

## 常见问题

### Q: 分数没有提升怎么办？

**A:** 运行 `+loop-score-suggest` 获取具体建议，然后实现高优先级的建议。

### Q: 如何实现自动化？

**A:** 从 L1（报告模式）开始，熟悉后再启用 L2（辅助模式）。参考 [SAFETY.md](./SAFETY.md)。

### Q: Token 花费太高怎么办？

**A:** 运行 `+loop-cost` 分析花费，然后：
- 减少 workflow 频率
- 使用更小的模型
- 添加 response caching

### Q: 如何追踪进度？

**A:** 使用 STATE.md 和 loop-run-log.md 记录每次改进。每周对比分数变化。

## 下一步

1. **开始第一次审计:**
   ```
   +loop-score
   ```

2. **选择改进建议:**
   ```
   +loop-score-suggest
   ```

3. **实现并验证:**
   ```
   # 实现后
   +loop-score
   ```

4. **持续循环:**
   ```
   每天重复，分数会持续提升！
   ```

## 资源

- [完整 Dogfooding 指南](./DOGFOODING.md)
- [pi 集成文档](./PI-INTEGRATION.md)
- [安全指南](./SAFETY.md)
- [Pattern Picker](./PATTERN_PICKER.md)

---

**Ready to improve agent-loops with agent-loops! 🚀**

*Last updated: 2026-07-10*
