---
id: runoob-agent-openclaw-quickstart
title: OpenClaw 快速上手指南
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/openclaw-quickstart.html
category: 04-主流框架与开发实战
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 主流框架与开发实战
- OpenClaw 快
summary: OpenClaw 快速上手 使用以下命令一键安装。 macOS/Linux： python curl fsSL https://openclaw.ai/install.sh
  | bash Windows（PowerShell）： pytho...
published: true
---

# OpenClaw 快速上手指南

> **出处**：[https://www.runoob.com/ai-agent/openclaw-quickstart.html](https://www.runoob.com/ai-agent/openclaw-quickstart.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`04-主流框架与开发实战`

---

# OpenClaw 快速上手

使用以下命令一键安装。

**macOS/Linux：**

```python

curl -fsSL https://openclaw.ai/install.sh | bash
```

**Windows（PowerShell）：**

```python

iwr -useb https://openclaw.ai/install.ps1 | iex
```

### 启动引导

安装完成后，运行 Onboarding 完成初始配置。这是最关键的一步：

```python
openclaw onboard --install-daemon
```

新手引导会配置认证、Gateway 网关设置和可选渠道。：

- **鉴权配置**：设置 Gateway Token 或 Password，保护你的 API 接口
- **模型提供商配置**：选择并配置你的 LLM（如 Anthropic API Key）
- **渠道配置（可选）**：连接 Telegram Bot、WhatsApp 等聊天渠道
- **安装系统服务**：`--install-daemon` 参数让 Gateway 开机自启

### Gateway 基础操作

Gateway 是 OpenClaw 的核心进程，所有功能都依赖它运行：

```python
# 查看 Gateway 状态
openclaw gateway status

# 在前台运行（适合调试）
openclaw gateway --port 18789

# 详细日志模式
openclaw gateway --port 18789 --verbose

# 强制占用端口并启动（解决端口冲突）
openclaw gateway --force

# 重启 Gateway
openclaw gateway restart

# 停止 Gateway
openclaw gateway stop

# 查看实时日志
openclaw logs --follow
```

### 访问 Control UI

Control UI 是 OpenClaw 的可视化管理界面：

```python
# 打开 Control UI（自动在浏览器中打开）
openclaw dashboard
```

或者直接访问: http://127.0.0.1:18789/。

Control UI 的主要功能：

- **聊天界面**：不需要配置任何渠道，直接在浏览器里和 AI 对话
- **状态监控**：查看 Gateway 健康状态、渠道连接情况
- **会话管理**：查看和管理不同渠道的对话历史

接下来我们就可以在页面开始聊天了：

> 🚀 **最快体验路径**打开 Control UI 后直接开始聊天——不需要配置任何 Channel！这是最快验证 OpenClaw 正常工作的方式。

### 关键命令速查

| 命令 | 说明 |
| --- | --- |
| `openclaw doctor` | 全面健康检查并尝试修复配置问题 |
| `openclaw health` | 快速健康检查 |
| `openclaw status` | 查看 Gateway 和渠道整体状态 |
| `openclaw gateway status` | 查看 Gateway 进程状态 |
| `openclaw gateway status --deep` | 深度状态检查（包含 RPC 探针） |
| `openclaw gateway run` | 前台运行 Gateway |
| `openclaw gateway start` | 后台启动 Gateway 服务 |
| `openclaw gateway stop` | 停止 Gateway 服务 |
| `openclaw gateway restart` | 重启 Gateway 服务 |
| `openclaw gateway probe` | 检测 Gateway 连通性和状态 |
| `openclaw gateway discover` | 发现局域网或远程 Gateway |
| `openclaw gateway call health` | 调用 Gateway 健康检查接口 |
| `openclaw channels status --probe` | 检查所有渠道连接状态 |
| `openclaw dashboard` | 打开浏览器控制面板 |
| `openclaw logs --follow` | 实时跟踪日志输出 |
| `openclaw onboard` | 重新运行初始化配置向导 |
| `openclaw secrets reload` | 热重载 Secrets 配置 |

### Gateway 热重载机制

OpenClaw 支持配置热重载，默认为 `hybrid` 模式：

| `gateway.reload.mode` | 行为说明 |
| --- | --- |
| `off` | 不自动重载，需手动重启 |
| `hot` | 仅应用安全变更（不中断连接） |
| `restart` | 任何变更都重启 Gateway |
| `hybrid`（默认） | 能热应用的热应用，需要重启的自动重启 |

## TUI：终端聊天界面

除了浏览器 Control UI，OpenClaw 还提供了一个完全在终端里运行的交互界面——**TUI（Terminal UI）**，无需浏览器，SSH 连进服务器也能直接聊天。

### 快速启动

```python
# 第一步：确保 Gateway 已运行
openclaw gateway

# 第二步：打开 TUI
openclaw tui
```

连接远程 Gateway：

```python
openclaw tui --url ws://<host>:<port> --token <gateway-token>

# 如果 Gateway 使用密码鉴权
openclaw tui --url ws://<host>:<port> --password <password>
```

### 界面布局

TUI 启动后你会看到四个区域：

| 区域 | 内容 |
| --- | --- |
| **Header（顶栏）** | 连接 URL、当前 Agent、当前 Session |
| **Chat log（消息区）** | 用户消息、AI 回复、系统通知、工具调用卡片 |
| **Status line（状态行）** | 连接 / 运行状态（connecting / running / streaming / idle / error） |
| **Footer（底栏）** | 连接状态 + Agent + Session + 模型 + Token 计数 |

头部区域：

底部区域：

### 键盘快捷键

| 快捷键 | 功能 |
| --- | --- |
| `Enter` | 发送消息 |
| `Esc` | 中止当前运行 |
| `Ctrl+C` | 清空输入（连按两次退出） |
| `Ctrl+D` | 退出 TUI |
| `Ctrl+L` | 打开模型选择器 |
| `Ctrl+G` | 打开 Agent 选择器 |
| `Ctrl+P` | 打开 Session 选择器 |
| `Ctrl+O` | 切换工具输出展开 / 折叠 |
| `Ctrl+T` | 切换 Thinking 显示（会重新加载历史） |

### 常用斜杠命令

使用 / 调出命令：

常用命令：

```python

/help                          # 查看帮助
/status                        # 查看连接状态
/agent <id>                    # 切换 Agent
/session <key>                 # 切换 Session
/model <provider/model>        # 切换模型（如 /model anthropic/claude-sonnet-4-6）
/think <off|minimal|low|medium|high>   # 设置思考深度
/deliver <on|off>              # 开启/关闭消息投递到 Provider
/new                           # 重置当前 Session
/abort                         # 中止当前运行
/exit                          # 退出 TUI
```

### 本地 Shell 命令

在输入框以 `!` 开头，可以直接执行本地 shell 命令：

```python
!ls -la          # 列出当前目录
!cat log.txt     # 查看文件内容
```

> ⚠️ TUI 会在每次会话中首次使用 `!` 时提示确认授权，拒绝后本次会话内 `!` 将不可用。

### 启动选项

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| `--url <url>` | Gateway WebSocket 地址 | 读取配置或 `ws://127.0.0.1:<port>` |
| `--token <token>` | Gateway Token 鉴权 | — |
| `--password <password>` | Gateway 密码鉴权 | — |
| `--session <key>` | 指定 Session | `main` |
| `--deliver` | 启动时开启消息投递 | 默认关闭 |
| `--thinking <level>` | 覆盖思考级别 | — |
| `--history-limit <n>` | 加载历史条数 | 200 |
| `--timeout-ms <ms>` | Agent 超时时间 | 读取 agents.defaults.timeoutSeconds |

## 相关内容

其他相关内容如下：

[OpenClaw 一键部署](/ai-agent/openclaw-cloud.html)
[OpenClaw 配置目录](/ai-agent/openclaw-setup.html)
[OpenClaw 工作原理](/ai-agent/openclaw-how-it-works.html)
[OpenClaw 接入微信](/ai-agent/openclaw-weixin.html)
[OpenClaw 接入飞书](/ai-agent/openclaw-feishu.html)
[OpenClaw Skills](/ai-agent/openclaw-skills.html)
[OpenClaw 卸载指南](/ai-agent/openclaw-uninstall.html)

  其他扩展
