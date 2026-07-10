# pi Integration Kit

**Agent Loops** × **pi coding agent** 完整集成包。

> [pi](https://pi.mcp.dev) 是一个强大的 coding agent 框架，支持 Skills、MCP 服务器、Workflows 和 Shortcuts。

---

## 目录结构

```
pi/
├── README.md                 # 本文件
├── mcp.json                  # pi MCP 配置模板（1 个 MCP 服务器 + 10 shortcuts）
├── skills/                   # pi 格式的技能定义（12 个）
│   ├── loop-audit/           # Loop Readiness Score 审计
│   ├── loop-budget/          # Token 预算守护
│   ├── loop-cost/            # Token 花费估算
│   ├── loop-guard/           # 电路熔断器
│   ├── loop-init/            # 脚手架生成
│   ├── loop-sync/            # STATE.md ↔ LOOP.md drift 检测
│   ├── loop-triage/          # 日常任务分类
│   ├── loop-verifier/        # 独立验证器
│   ├── minimal-fix/          # 最小修复
│   ├── ci-triage/            # CI 失败分类
│   ├── pr-review-triage/     # PR 状态分类
│   └── rebase-and-clean/     # PR rebase 与清理
└── workflows/                # Workflow 定义
    ├── daily-triage.yaml
    ├── pr-babysitter.yaml
    └── ci-sweeper.yaml
```

---

## 快速开始

### 1. 复制配置到 pi

推荐使用 `install.sh` 一键安装：

```bash
bash pi/install.sh
```

或手动复制（注意所有 12 个 skill）：

```bash
# 复制 MCP 配置
cp pi/mcp.json ~/.pi/agent/

# 复制 Skills（使用 . 复制全部内容，含非 loop-* 前缀的 skill）
cp -r pi/skills/. ~/.pi/agent/skills/

# 复制 Workflows (可选)
cp -r pi/workflows/ ~/.pi/agent/workflows/
```

### 2. 配置 MCP 服务器

编辑 `~/.pi/agent/mcp.json`，确保包含：

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

### 3. 测试集成

在 pi 中运行：

```
+loop-score
```

应该输出 Loop Readiness Audit 结果。

---

## 可用技能

| 技能 | 等级 | 描述 | 触发词 |
|------|------|------|--------|
| `loop-audit` | L1 | Loop 就绪度审计 | "审计项目", "loop 评分" |
| `loop-init` | L1 | 脚手架生成（7 patterns × 4 tools） | "初始化 loop", "创建脚手架" |
| `loop-triage` | L1 | 日常任务分类 | "日常分类", "triage report" |
| `loop-cost` | L1 | Token 花费估算（JSON 输出） | "token 花费", "预算估算" |
| `loop-budget` | L1 | Token 预算守护 | "loop budget", "kill switch" |
| `loop-sync` | L1 | STATE.md ↔ LOOP.md drift 检测 | "loop drift", "一致性检查" |
| `loop-verifier` | L2 | 独立验证器 | "verify", "maker/checker" |
| `minimal-fix` | L2 | 最小修复实现 | "fix this", "minimal patch" |
| `loop-guard` | L2 | 电路熔断器 | "circuit breaker", "熔断器" |
| `ci-triage` | L2 | CI 失败分类 | "CI failure", "flake check" |
| `pr-review-triage` | L2 | PR 状态分类 | "PR status", "review queue" |
| `rebase-and-clean` | L2 | PR rebase 与清理 | "rebase PR", "clean commits" |

---

## Shortcuts

| 快捷键 | 描述 |
|--------|------|
| `+loop-score` | 审计当前项目 |
| `+loop-score-suggest` | 获取改进建议 |
| `+loop-init` | 初始化脚手架 |
| `+loop-cost` | 估算 token 花费 |
| `+loop-state` | 查看 STATE.md |
| `+loop-log` | 查看运行日志 |

---

## Workflows

### Daily Triage

- **触发**: 工作日早上 9 点
- **等级**: L1 (报告模式)
- **预算**: 100,000 tokens/天

### PR Babysitter

- **触发**: 每 15 分钟
- **等级**: L2 (辅助模式)
- **预算**: 200,000 tokens/天

### CI Sweeper

- **触发**: 每 10 分钟
- **等级**: L2 (辅助修复)
- **预算**: 1,000,000 tokens/天
- **熔断器**: 启用

---

## 文档

完整集成指南：[docs/PI-INTEGRATION.md](../docs/PI-INTEGRATION.md)

---

## 版本兼容性

| 组件 | 最低版本 | 推荐版本 |
|------|----------|----------|
| pi | 1.0 | Latest |
| loop-audit | 1.5 | 1.6+ |
| loop-init | 1.2 | 1.3+ |
| loop-mcp-server | 1.0 | Latest |

---

## 故障排除

### MCP 服务器无法连接

```bash
# 测试 npx
which npx

# 手动运行 MCP 服务器
npx -y @kevinzhangnothing/loop-mcp-server
```

### Skills 未加载

```bash
# 检查技能目录（列出全部 12 个）
ls ~/.pi/agent/skills/

# 使用 install.sh 重新安装
bash pi/install.sh

# 或手动重新复制（使用 . 复制全部内容）
cp -r pi/skills/. ~/.pi/agent/skills/
```

---

## 贡献

欢迎提交新的 Skills 和 Workflows！

- 新技能模板：`pi/skills/{name}/SKILL.md`
- 新 Workflow：`pi/workflows/{name}.yaml`
- 集成问题：[GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues)

---

*Last updated: 2026-07-09*
