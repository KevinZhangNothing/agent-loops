# Agent Loops 图表文档

Agent Loops 的交互式架构和工作流图表。

<p align="center">
  <strong>🌐 选择语言：</strong>
  <a href="../DIAGRAMS.md">English</a> ·
  <a href="./DIAGRAMS.md">简体中文</a>
</p>

---

## 📐 架构图

**Agent Loops 系统架构** — 展示完整的系统布局，包含所有核心组件、外部集成和数据流。

### 核心组件

- **输入源**（顶部）：GitHub 事件、Cron 调度、手动 `/loop` 命令
- **核心原语**（中间）：每个 agent loop 的 5 个构建块
  - **调度** — 节奏管理、自动化
  - **状态** — 通过 `STATE.md` 的持久化记忆
  - **技能** — 通过 `SKILL.md` 的可复用能力
  - **工作树** — 隔离的 git 执行环境
  - **子代理** — 制作者/检查者验证分离
- **MCP 中心**（中央）：模型上下文协议集成层
- **外部工具**（底部）：GitHub、Linear、Slack MCP 服务器
- **输出动作**（底部）：状态更新、PR 评论、修复提交、报告

### 交互功能

- 🌓 **深色/浅色主题切换** — 点击图表中的主题按钮
- 📥 **导出选项** — 下载 PNG（最高 4× 分辨率）、JPEG、WebP 或 SVG
- 🔍 **缩放和平移** — 探索详细的组件关系

[**打开架构图 →**](../diagrams/agent-loops-architecture.html)

---

## 🔄 执行生命周期

**Agent Loop 执行生命周期** — 状态机展示从触发到完成的完整执行流程，包括验证门禁和错误处理。

### 状态说明

| 状态 | 区域 | 描述 |
|------|------|------|
| **已触发** | 主流程 | Loop 被 cron、事件或手动命令激活 |
| **预算检查** | 主流程 | Token 预算和范围验证 |
| **分类** | 主流程 | 优先级排序和计划 |
| **执行中** | 主流程 | 在隔离工作树中执行技能 |
| **验证** | 等待区 | loop-verifier 和 loop-guard 检查 |
| **已完成** | 终止区 | 成功的状态更新和日志记录 |
| **提前退出** | 终止区 | 预算超出或无可执行工作 |
| **已升级** | 终止区 | 验证失败，需要人工审查 |

### 状态转换

- **正常路径**：已触发 → 预算检查 → 分类 → 执行中 → 验证 → 已完成
- **预算退出**：预算检查 → 提前退出（当 token 超出预算）
- **升级路径**：验证 → 已升级（当验证失败或熔断器触发）

### Loop 等级

- **L1（仅报告）**：只读分析，不修改代码
- **L2（辅助修复）**：创建 PR 供人工审查
- **L3（自动合并）**：带熔断器的保护性自动合并

### 安全机制

- **Token 预算**：`loop-budget` 在花费接近上限时强制提前退出
- **熔断器**：`loop-guard` 跟踪连续失败并在达到阈值时升级给人工
- **验证**：`loop-verifier` 在合并前独立验证所有更改

[**打开生命周期图 →**](../diagrams/loop-execution-lifecycle.html)

---

## 📊 模式对比工作流

**Agent Loop 模式工作流** — 并排对比四种核心模式，展示它们在触发、分析和行动阶段的执行流程。

### 涵盖的模式

| 模式 | 等级 | 节奏 | 人工门禁 |
|------|------|------|----------|
| **每日分类** | L1 | 每日 10:00 UTC | 每周审查 |
| **PR 保姆** | L2 | PR 事件触发 | 人工合并 |
| **CI 清洁工** | L2 | CI 失败触发 | 人工审查 PR |
| **依赖清洁工** | L2 | 每 6 小时 | 仅白名单 |

### 工作流阶段

1. **触发** — 激活 loop 的因素（cron、webhook、事件监控）
2. **分析** — loop 处理信息的方式（扫描、检查、分析）
3. **行动** — loop 产生的输出（报告、评论、修复 PR）

### 执行特征

- **L1 模式** 仅生成报告 — 人工决定行动
- **L2 模式** 创建 PR — 所有更改需要人工合并
- **安全门禁** 适用于所有模式：工作树、验证器、熔断器

[**打开模式工作流图 →**](../diagrams/loop-patterns-workflow.html)

---

## 🛠️ 图表工具

这些图表使用 [archify](https://github.com/tt-a1i/archify) 生成，这是一个专业的图表生成工具，可以创建：

- 独立的 HTML 文件，包含内嵌 SVG
- 内置深色/浅色主题切换
- 一键导出为 PNG/JPEG/WebP/SVG
- 模式验证的 JSON 源文件

### 源文件

- [架构图 JSON](../diagrams/agent-loops-architecture.json)
- [生命周期图 JSON](../diagrams/loop-execution-lifecycle.json)
- [模式工作流 JSON](../diagrams/loop-patterns-workflow.json)

### 重新生成图表

```bash
cd /path/to/archify/skill

# 架构图
node bin/archify.mjs render architecture \
  /path/to/agent-loops/docs/diagrams/agent-loops-architecture.json \
  /path/to/agent-loops/docs/diagrams/agent-loops-architecture.html

# 生命周期图
node bin/archify.mjs render lifecycle \
  /path/to/agent-loops/docs/diagrams/loop-execution-lifecycle.json \
  /path/to/agent-loops/docs/diagrams/loop-execution-lifecycle.html

# 模式工作流
node bin/archify.mjs render workflow \
  /path/to/agent-loops/docs/diagrams/loop-patterns-workflow.json \
  /path/to/agent-loops/docs/diagrams/loop-patterns-workflow.html
```

---

## 📖 相关文档

- [核心概念](concepts.md) — 意图债务、理解债务、harness vs loop
- [原语](PRIMITIVES.md) — 5 个构建块 + 记忆
- [安全](safety.md) — 拒绝列表、自动合并策略、MCP 范围
- [快速入门](../QUICKSTART.md) — 5 分钟从零到第一个 loop
- [模式注册表](../patterns/README.md) — 所有可用模式
