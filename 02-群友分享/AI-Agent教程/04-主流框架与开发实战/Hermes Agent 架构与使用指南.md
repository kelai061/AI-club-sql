---
id: runoob-agent-hermes-agent
title: Hermes Agent 架构与使用指南
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/hermes-agent.html
category: 04-主流框架与开发实战
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 主流框架与开发实战
- Hermes Age
summary: Hermes Agent 近年来，AI 智能体（AI Agent）领域发展迅猛，从单纯的聊天机器人进化到能真正做事、持久记忆并自主成长的智能体。
  Hermes Agent 是 Nous Research 开源的自主 AI Agent 框架，...
published: true
---

# Hermes Agent 架构与使用指南

> **出处**：[https://www.runoob.com/ai-agent/hermes-agent.html](https://www.runoob.com/ai-agent/hermes-agent.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`04-主流框架与开发实战`

---

# Hermes Agent

近年来，AI 智能体（AI Agent）领域发展迅猛，从单纯的聊天机器人进化到能真正做事、持久记忆并自主成长的智能体。

Hermes Agent 是 Nous Research 开源的自主 AI Agent 框架，通过自然语言交互的自主 AI Agent，它可以执行终端命令、操控浏览器、读写文件、联网搜索、生成图像，并且跨会话保持记忆。

- GitHub 仓库：[https://github.com/nousresearch/hermes-agent](https://github.com/nousresearch/hermes-agent)
- Hermes Agent 官网：[https://hermes-agent.nousresearch.com/](https://hermes-agent.nousresearch.com/)

> 官方定义非常直接：
>
> ```python
>
> The agent that grows with you.
>
> 一个会随着使用不断成长的 Agent。
>
> ```
>
> 它是一个自主智能体，运行时间越长，能力就越强。

Hermes Agent 的核心理念是：**让 AI 成为长期在线的数字员工，而非一次性聊天机器人。**

Hermes Agent 是业内少见的**原生内置学习闭环的 AI Agent**，可从执行经验中沉淀技能、自主优化能力、持久化知识、检索历史对话，并在跨会话中持续完善用户认知模型。

和普通 AI 聊天工具的区别：

| 维度 | 普通 AI 聊天（如 ChatGPT） | Hermes Agent |
| --- | --- | --- |
| 记忆 | 每次对话从零开始 | 跨会话持久记忆，越用越懂你 |
| 执行能力 | 只能生成文字 | 可执行终端命令、操作文件、控制浏览器 |
| 运行位置 | 云端，数据上传服务商 | 本地或你的服务器，数据不离开你 |
| 扩展性 | 封闭生态 | 开放技能标准（agentskills.io）、MCP 生态 |
| 触达方式 | 网页 | CLI + Telegram/Discord/Slack/WhatsApp 等 |
| 模型绑定 | 固定模型 | 支持 300+ 模型，随时切换，不锁定 |

**核心特性:**

- **连接（Connect）:** Telegram、Discord、Slack、WhatsApp、Signal、Email、CLI——一个 Agent，统一内存，所有平台。在 Telegram 发起的对话，可以在终端无缝继续。
- **记忆（Remember）:** Hermes 会学习你的项目、自动生成技能，并且永远不会忘记它解决过的问题。每次会话结束后，重要信息都会写入持久记忆。
- **定时（Schedule）:**用自然语言设定定时任务——日报、备份、例行审查、晨间简报——在后台无人值守运行。
- **委派（Delegate）:** 生成拥有独立对话上下文、独立终端和 Python RPC 脚本的隔离子 Agent，实现零上下文成本的并行流水线。
- **搜索与多模态（Search）:**网页搜索、浏览器自动化、视觉理解、图像生成、文字转语音、多模型推理，全部内置。

Hermes Agent 支持自由切换任意大模型，包括 **Nous Portal、OpenRouter（200+ 模型）、OpenAI、GLM、Kimi、MiniMax** 等，执行 `hermes model` 即可切换，无需改代码、无厂商锁定。

| 提供商 | 说明 | 设置方式 |
| --- | --- | --- |
| **Nous Portal** | 订阅制，零配置 | 通过 `hermes model` 进行 OAuth 登录 |
| **OpenAI Codex** | ChatGPT OAuth，使用 Codex 模型 | 通过 `hermes model` 进行设备代码认证 |
| **Anthropic** | 直接使用 Claude 模型 | 通过 Claude Code 认证或 Anthropic API 密钥 |
| **OpenRouter** | 多提供商路由 | 输入您的 API 密钥 |
| **DeepSeek** | 直接 DeepSeek API 访问 | 设置 `DEEPSEEK_API_KEY` |
| **Hugging Face** | 通过统一路由器访问 20+ 开放模型 | 设置 `HF_TOKEN` |
| **自定义端点** | VLLM、SGLang、Ollama 或任何 OpenAI 兼容 API | 设置基础 URL 和 API 密钥 |

当然买 Coding Plan 这种还是最划算的，毕竟包月：

| 特性 | 能力说明 |
| --- | --- |
| **原生终端交互** | 完整 TUI 界面，支持多行编辑、命令补全、历史回溯、流式输出等 |
| **全平台接入** | 一个网关接入 CLI、Telegram、Discord、Slack、WhatsApp 等多端 |
| **闭环学习体系** | 自主管理记忆、技能生成与优化、跨会话召回、用户建模 |
| **定时自动化** | 内置 Cron 调度，支持日报、备份、审计等 7×24 自动任务 |
| **并行任务处理** | 支持子 Agent 并行执行、多工作流拆分与 RPC 工具调用 |
| **多环境运行** | 支持本地、Docker、SSH、Daytona、Modal 等 6 种后端 |
| **科研级能力** | 支持轨迹生成、强化学习环境、训练数据压缩 |

### 整体架构

整体流程：

架构图：

| 模块 | 作用 | 示例 |
| --- | --- | --- |
| 接入层（Clients） | 接收用户请求 | Web、App、API、飞书 |
| 输入层（Input） | 处理各种输入数据 | 文本、图片、PDF、Excel |
| 调度器（Agent Orchestrator） | 理解任务并拆分执行流程 | 分析需求 → 制定计划 |
| 能力层（Capabilities） | 提供执行能力 | 对话、检索、代码执行 |
| 记忆层（Memory） | 保存上下文和历史信息 | 会话记忆、长期记忆 |
| 知识层（Knowledge） | 提供知识检索能力 | RAG、向量数据库 |
| 模型层（Model Layer） | 提供推理能力 | GPT、Claude、本地模型 |
| 工具层（Tools） | 调用外部工具完成任务 | 搜索、数据库、API |
| 外部服务层（External Services） | 对接业务系统 | ERP、CRM、云服务 |
| 基础设施层（Infrastructure） | 支撑系统运行 | 权限、日志、监控 |

## 快速安装

以下安装命令适用于 Linux、macOS 与 WSL2 系统：

```python
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

安装完成后重新加载 Shell：

```python


bashsource ~/.bashrc   # 使用 bash
# 或
source ~/.zshrc    # 使用 zsh
```

Windows 原生安装（PowerShell）:

```python
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

Windows 原生支持仍为实验性功能，推荐优先使用 WSL2。

**macOS / Windows 桌面版（Desktop App）:**前往 [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com/) 下载对应平台的桌面安装包，CLI 与桌面应用会同时安装。


下载后双击安装即可：

验证安装:

```python
hermes --version
```

输出版本号即表示安装成功。

安装程序会自动处理所有依赖项：

- **uv** — 快速 Python 包管理器
- **Python 3.11** — 通过 uv 安装，无需 sudo
- **Node.js v22** — 用于浏览器自动化和 WhatsApp 桥接
- **ripgrep** — 快速文件搜索
- **ffmpeg** — TTS 音频格式转换

**Windows 系统说明**：不支持原生 Windows 环境，请先安装 WSL2，再在 WSL2 终端中执行上述命令。

如果安装过 OpenClaw 还可以直接导入配置：

<p>然后配置服务商，可以设置你已有的 API key，这里选百炼的 Coding Plan：</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2026/04/d186a7cf-fe80-4ea7-8631-dd3f9e425cc5.png"></p>
<p>设置模型名称，比如 <span class="marked">MiniMax-M2.5</span>。</p>

这里选择不导入，输入 n，进入模型设置，选择第一个快速设置：

接下来我们选择倒数第二项的 More providers：

这里可以选择更多国内或国际的大模型：

接下来我们使用 [字节方舟 Coding Plan](https://www.volcengine.com/activity/codingplan?utm_campaign=hw&utm_content=hw&utm_medium=devrel_tool_web&utm_source=OWO&utm_term=runoob) ，所以选择的是 **Customer endpoint**，就是自定义 API 地址与 API key。

Base URL 设置字节方舟兼容 OpenAI 接口协议工具：https://ark.cn-beijing.volces.com/api/coding/v3

设置 API key 与支持的大模型，比如 ark-code-latest。

安装完成后执行以下命令：

```python

source ~/.bashrc    # 重载shell配置（若使用zsh，执行：source ~/.zshrc）
hermes              # 开启智能体对话！
```

### 快速上手

```python
hermes              # 交互式命令行界面 — 开启对话
hermes model        # 选择大语言模型服务商与对应模型
hermes tools        # 配置启用的工具集
hermes config set   # 设置单项配置项
hermes gateway      # 启动消息网关（支持Telegram、Discord等平台）
hermes setup        # 运行全量配置向导（一站式完成所有配置）
hermes claw migrate # 从OpenClaw迁移数据（适用于原OpenClaw用户）
hermes update       # 更新至最新版本
hermes doctor       # 诊断运行环境与配置问题
```

## 手动安装

如果您更喜欢完全控制安装过程，请按照以下步骤操作。

### 步骤 1：克隆仓库

使用 `--recurse-submodules` 克隆以获取所需的子模块：

```python

git clone --recurse-submodules https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
```

如果已经克隆但没有子模块：

```python

git submodule update --init --recursive
```

### 步骤 2：安装 uv 并创建虚拟环境

```python

# 安装 uv（如果尚未安装）
curl -LsSf https://astral.sh/uv/install.sh | sh

# 创建 Python 3.11 的虚拟环境（uv 会在需要时下载，无需 sudo）
uv venv venv --python 3.11
```

**提示：**您**不需要**激活虚拟环境来使用 `hermes`。入口点有一个硬编码的 shebang 指向虚拟环境中的 Python，因此全局链接后即可使用。

### 步骤 3：安装 Python 依赖

```python

# 告诉 uv 要安装到哪个虚拟环境
export VIRTUAL_ENV="$(pwd)/venv"

# 安装所有扩展
uv pip install -e ".[all]"
```

如果您只想要核心智能体（不包含 Telegram/Discord/cron 支持）：

```python

uv pip install -e "."
```

**可选扩展说明：**

| 扩展 | 功能 | 安装命令 |
| --- | --- | --- |
| `all` | 包含以下所有功能 | `uv pip install -e ".[all]"` |
| `messaging` | Telegram 和 Discord 网关 | `uv pip install -e ".[messaging]"` |
| `cron` | 定时任务的 Cron 表达式解析 | `uv pip install -e ".[cron]"` |
| `voice` | CLI 麦克风输入和音频播放 | `uv pip install -e ".[voice]"` |
| `mcp` | 模型上下文协议支持 | `uv pip install -e ".[mcp]"` |
| `honcho` | AI 原生记忆（Honcho 集成） | `uv pip install -e ".[honcho]"` |

我们可以组合使用：`uv pip install -e ".[messaging,cron]"`

### 步骤 4：创建配置目录

```python

# 创建目录结构
mkdir -p ~/.hermes/{cron,sessions,logs,memories,skills,pairing,hooks,image_cache,audio_cache,whatsapp/session}

# 复制示例配置文件
cp cli-config.yaml.example ~/.hermes/config.yaml

# 创建空的 .env 文件用于存储 API 密钥
touch ~/.hermes/.env
```

### 步骤 5：添加 API 密钥

打开 `~/.hermes/.env` 并添加至少一个 LLM 提供商密钥：

```python

# 必需 — 至少一个 LLM 提供商：
OPENROUTER_API_KEY=sk-or-v1-your-key-here

# 可选 — 启用其他工具：
FIRECRAWL_API_KEY=fc-your-key          # 网页搜索和抓取
FAL_KEY=your-fal-key                   # 图像生成（FLUX）
```

或者通过 CLI 设置：

```python

hermes config set OPENROUTER_API_KEY sk-or-v1-your-key-here
```

### 步骤 6：将 hermes 添加到 PATH

```python

mkdir -p ~/.local/bin
ln -sf "$(pwd)/venv/bin/hermes" ~/.local/bin/hermes
```

如果 `~/.local/bin` 不在 PATH 中，请添加到 shell 配置：

```python

# Bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

# Zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

### 步骤 7：配置您的提供商

```python

hermes model       # 选择您的 LLM 提供商和模型
```

### 步骤 8：验证安装

```python

hermes version    # 检查命令是否可用
hermes doctor     # 运行诊断以验证一切正常
hermes status     # 检查您的配置
hermes chat -q "Hello! What tools do you have available?"
```

### 故障排除

| 问题 | 解决方案 |
| --- | --- |
| `hermes: command not found` | 重新加载 shell（`source ~/.bashrc`）或检查 PATH |
| API 密钥未设置 | 运行 `hermes model` 配置提供商，或 `hermes config set OPENROUTER_API_KEY your_key` |
| 更新后配置丢失 | 运行 `hermes config check` 然后 `hermes config migrate` |

如需更多诊断信息，运行 `hermes doctor` — 它会告诉您缺少什么以及如何修复。

> **提示：**您可以随时通过 `hermes model` 切换提供商——无需更改代码，没有锁定。

 卡片标题


    更多内容

 内容列表

[Hermes Agent 配置](https://www.runoob.com/hermes-agent/hermes-agent-setup.html)
[Hermes Agent CLI](https://www.runoob.com/hermes-agent/hermes-agent-cli.html)
[Hermes Agent 工具](https://www.runoob.com/hermes-agent/hermes-agent-tools.html)
[Hermes Agent Skills](https://www.runoob.com/hermes-agent/hermes-agent-skills.html)
[Hermes Agent MCP 集成](https://www.runoob.com/hermes-agent/hermes-agent-mcp.html)

## 消息网关

Hermes Agent 消息网关允许您通过多个平台与智能体交互——Telegram、Discord、Slack、WhatsApp、Signal、Email、Home Assistant 等。

> 从一个网关向 15+ 个平台发送消息。无论您身在何处，都可以与 Hermes 保持联系。

### 支持的平台

| 平台 | 说明 | 状态 |
| --- | --- | --- |
| Telegram | 最完整的消息平台集成 | ✅ 支持 |
| Discord | 支持服务器和语音频道 | ✅ 支持 |
| Slack | 工作区集成 | ✅ 支持 |
| WhatsApp | 通过 WhatsApp Web | ✅ 支持 |
| Signal | 隐私消息应用 | ✅ 支持 |
| Matrix | 去中心化通信 | ✅ 支持 |
| Mattermost | 自托管消息 | ✅ 支持 |
| Email | SMTP 邮件 | ✅ 支持 |
| SMS | 短信发送 | ✅ 支持 |
| DingTalk | 钉钉 | ✅ 支持 |
| Feishu | 飞书 | ✅ 支持 |
| WeCom | 企业微信 | ✅ 支持 |
| BlueBubbles | macOS iMessage | ✅ 支持 |
| Home Assistant | 智能家居 | ✅ 支持 |
| Webhooks | 自定义 HTTP 回调 | ✅ 支持 |

### 设置消息平台

#### 交互式设置:

```python

hermes gateway setup
```

这将启动交互式配置向导，引导您完成每个平台的设置。

#### 手动配置:

或直接编辑 `~/.hermes/config.yaml`：

Telegram:

```python

# 在 ~/.hermes/.env 中
TELEGRAM_BOT_TOKEN=your-bot-token

# config.yaml
gateway:
  adapters:
    telegram:
      enabled: true
```

Discord:

```python

# 在 ~/.hermes/.env 中
DISCORD_BOT_TOKEN=your-discord-token

# config.yaml
gateway:
  adapters:
    discord:
      enabled: true
      allowed_channels:
        - "123456789"
```

Slack:

```python

# 在 ~/.hermes/.env 中
SLACK_BOT_TOKEN=xoxb-your-token
SLACK_SIGNING_SECRET=your-signing-secret

# config.yaml
gateway:
  adapters:
    slack:
      enabled: true
```

WhatsApp:

```python

# WhatsApp 需要浏览器自动化
# 首次设置需要扫描二维码

# config.yaml
gateway:
  adapters:
    whatsapp:
      enabled: true
      session_dir: ~/.hermes/whatsapp/session
```

Email (SMTP):

```python

# 在 ~/.hermes/.env 中
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# config.yaml
gateway:
  adapters:
    email:
      enabled: true
      from_email: your-email@gmail.com
```

Home Assistant:

```python

# 在 ~/.hermes/.env 中
HA_URL=http://homeassistant.local:8123
HA_TOKEN=your-long-lived-access-token

# config.yaml
gateway:
  adapters:
    homeassistant:
      enabled: true
```

### 启动网关

#### 前台运行:

```python

hermes gateway
```

#### 后台运行（推荐）:

```python

hermes gateway &
# 或使用 systemd
systemctl enable hermes-agent
systemctl start hermes-agent
```

#### Docker 运行:

```python

docker run -d \
  --name hermes-gateway \
  -v ~/.hermes:/home/hermes/.hermes \
  ghcr.io/nousresearch/hermes-agent:latest \
  hermes gateway
```

### 平台特定配置

#### Telegram:

1. 通过 @BotFather 创建新机器人
2. 获取 bot token
3. 配置并运行 Hermes
4. 在 Telegram 中向您的机器人发送 `/start`

#### Discord:

1. 在 Discord 开发者门户创建应用
2. 添加机器人到服务器
3. 获取 bot token
4. 配置并运行 Hermes

#### Slack:

1. 在 Slack 应用门户创建新应用
2. 添加 bot token 作用域
3. 安装到工作区
4. 配置并运行 Hermes

#### 发送消息:

使用 `send_message` 工具通过任何配置的通道发送消息：

```python

send_message(
  platform="telegram",
  chat_id="123456789",
  message="Hello from Hermes!"
)
```

或通过 cron 安排自动化消息：

```python

# 设置每日简报
hermes
❯ 每天早上9点检查 Hacker News 上的 AI 新闻，并通过 Telegram 给我发送摘要
```

### 语音支持

某些平台支持语音交互：

- **Telegram**：语音消息和语音通话
- **Discord**：语音频道和语音消息
- **CLI**：麦克风输入和 TTS

有关语音模式的详细信息，请参阅语音模式指南。

### 安全考虑

**重要：**

- 不要将 API 密钥提交到源代码控制
- 使用环境变量或安全的凭据存储
- 限制允许与智能体交互的用户/频道
- 定期轮换 API 密钥
- 在公共平台上启用命令审批

### 故障排除

| 问题 | 解决方案 |
| --- | --- |
| 机器人无响应 | 检查网关是否正在运行 |
| 权限错误 | 验证 bot token 和权限 |
| 消息未发送 | 检查通道 ID 和配置 |
| 连接超时 | 检查网络和防火墙设置 |

> **提示：**使用 `hermes gateway --verbose` 查看详细日志以调试问题。

 其他扩展
