# pi Integration Kit

**Loop Engineering** × **pi coding agent** 完整集成包。

> [pi](https://pi.mcp.dev) 是一个强大的 coding agent 框架，支持 Skills、MCP 服务器、Workflows 和 Shortcuts。

---

## 目录结构

```
pi/
├── README.md                 # 本文件
├── mcp.json                  # pi MCP 配置模板
├── skills/                   # pi 格式的技能定义
│   ├── loop-audit/
│   │   ├── SKILL.md          # 技能定义
│   │   └── eval.yaml         # 评估配置
│   ├── loop-init/
│   │   ├── SKILL.md
│   │   └── eval.yaml
│   ├── loop-triage/
│   │   ├── SKILL.md
│   │   └── eval.yaml
│   └── loop-cost/
│       ├── SKILL.md
│       └── eval.yaml
└── workflows/                # Workflow 定义
    ├── daily-triage.yaml
    ├── pr-babysitter.yaml
    └── ci-sweeper.yaml
```

---

## 快速开始

### 1. 复制配置到 pi

```bash
# 复制 MCP 配置
cp pi/mcp.json ~/.pi/agent/

# 复制 Skills
cp -r pi/skills/loop-* ~/.pi/agent/skills/

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
      "args": ["-y", "@cobusgreyling/loop-mcp-server"],
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

| 技能 | 描述 | 触发词 |
|------|------|--------|
| `loop-audit` | Loop 就绪度审计 | "审计项目", "loop 评分" |
| `loop-init` | 脚手架生成 | "初始化 loop", "创建脚手架" |
| `loop-triage` | 日常分类 | "日常分类", "triage report" |
| `loop-cost` | Token 花费估算 | "token 花费", "预算估算" |

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
npx -y @cobusgreyling/loop-mcp-server
```

### Skills 未加载

```bash
# 检查技能目录
ls ~/.pi/agent/skills/loop-*

# 重新复制
cp -r pi/skills/loop-* ~/.pi/agent/skills/
```

---

## 贡献

欢迎提交新的 Skills 和 Workflows！

- 新技能模板：`pi/skills/{name}/SKILL.md`
- 新 Workflow：`pi/workflows/{name}.yaml`
- 集成问题：[GitHub Issues](https://github.com/cobusgreyling/loop-engineering/issues)

---

*Last updated: 2026-07-09*
