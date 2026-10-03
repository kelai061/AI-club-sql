---
id: runoob-agent-pi-coding-agent
title: Pi Coding Agent 编码智能体实战
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/pi-coding-agent.html
category: 04-主流框架与开发实战
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 主流框架与开发实战
- 'Pi Coding '
summary: Pi Coding Agent 入门教程 Pi 是一个运行在终端里的 AI 编码 Agent，类似于 Claude Code、OpenAI Codex
  CLI 这类工具。 Pi 的官方理念是："There are many agent ha...
published: true
---

# Pi Coding Agent 编码智能体实战

> **出处**：[https://www.runoob.com/ai-agent/pi-coding-agent.html](https://www.runoob.com/ai-agent/pi-coding-agent.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`04-主流框架与开发实战`

---

# Pi Coding Agent 入门教程

Pi 是一个运行在终端里的 AI 编码 Agent，类似于 Claude Code、OpenAI Codex CLI 这类工具。

Pi 的官方理念是："There are many agent harnesses but this one is yours"（Agent 工具很多，但这个是你自己的）。

你给 Pi 一句话，它就能在你的项目目录里读文件、写文件、跑命令，循环调用大模型直到完成任务。

核心理念是用最小的内核加极强的可扩展性，让你把工具改造成适合自己的样子，而不是反过来去适应工具。

> Pi Agent 完整教程：[https://www.runoob.com/pi-agent/pi-agent-tutorial.html](https://www.runoob.com/pi-agent/pi-agent-tutorial.html)

### Pi 包含什么

Pi 不是一个单独的程序，而是一套由四个 npm 包组成的工具链。

普通用户只需安装最上层的 `@earendil-works/pi-coding-agent`，就能得到一个开箱即用的命令行 Agent。

### 适合谁用

Pi 特别适合以下场景和人群：

- 偏好终端工作流、不想在 IDE 和命令行之间来回切换的开发者
- 想要一个可以深度定制、甚至让 Agent 自己改写自己的工具的进阶用户
- 需要同时接入多家大模型（Anthropic、OpenAI、Google 等）的人
- 想把 Agent 能力嵌入到自己程序里的开发者（通过 SDK 或 RPC 模式）

> 注意：Pi 默认以你的用户权限运行，没有内置沙箱。在不受信任的代码仓库上使用前，请先阅读本文的「安全须知」章节。

## 核心设计哲学：原语而非功能

理解 Pi 的设计哲学，你会明白它为什么故意「不内置」很多其他 Agent 都有的功能。

Pi 把这个理念叫做 Primitives, Not Features（提供原语，而非功能）。

### 故意不内置的功能

下面这些功能，Pi 都没有内置，而是让你按需通过扩展或外部工具来实现：

| 不内置的功能 | Pi 的替代方案 |
| --- | --- |
| MCP 协议集成 | 把工具写成带 README 的 CLI，或装一个 MCP 扩展 |
| 子 Agent（subagents） | 用 tmux 开多个会话，或自己写扩展 |
| 权限确认弹窗 | 放进容器里跑，或自己写确认流程扩展 |
| 计划模式（plan mode） | 把计划写到文件里，或写扩展 |
| 内置待办事项 | 用一个 TODO.md 文件，或装扩展 |
| 后台 bash | 用 tmux 获得完整可观测性 |

### 为什么要这样做

Pi 认为这些功能在不同团队里需求差异巨大，强行内置反而会让工具变得臃肿且难以贴合实际工作流。

所以它的做法是：保留一个干净的最小内核，把所有「功能」都变成可安装、可编写、可分享的扩展、技能、提示模板和主题。

甚至你可以直接让 Pi 帮你把这些功能写出来，写完用 `/reload` 重载，立刻就能用。

> 这句话值得记住：Adapt Pi to your workflows, not the other way around（让 Pi 适应你的工作流，而不是你适应 Pi）。

## 架构与核心包

Pi 由四个层级分明的包组成，上层依赖下层。

你平时用的 `pi` 命令，只是最上层那个包提供的入口。

### 四个核心包

| 包名 | 作用 | 何时会单独用到 |
| --- | --- | --- |
| `@earendil-works/pi-coding-agent` | 交互式编码 Agent CLI，用户直接安装使用的入口 | 绝大多数情况只需这个 |
| `@earendil-works/pi-agent-core` | Agent 运行时，负责工具调用循环和状态管理 | 想自己搭一个非编码类的 Agent 时 |
| `@earendil-works/pi-ai` | 统一的多厂商 LLM API（OpenAI、Anthropic、Google 等） | 只想用一个统一接口调多家模型时 |
| `@earendil-works/pi-tui` | 终端 UI 库，支持差分渲染 | 想写自己的终端应用时 |

### 四种运行模式

Pi 不只能交互式运行，它提供了四种模式来适配不同场景：

| 模式 | 说明 | 典型场景 |
| --- | --- | --- |
| Interactive（交互式） | 完整的终端 UI 体验 | 日常编码、对话式开发 |
| Print / JSON | `pi -p "提问"` 一次性输出；`--mode json` 输出事件流 | 脚本自动化、管道处理 |
| RPC | 通过 stdin/stdout 的 JSON 协议通信 | 非 Node 程序集成 |
| SDK | 作为库嵌入到你的应用里 | 在自家产品里集成 Agent 能力 |

## 安装

Pi 提供多种安装方式，覆盖 macOS、Linux 和 Windows。

最常见的是用 npm 全局安装，也可以用官方的一键脚本。

### 方式一：一键脚本（推荐新手）

macOS 和 Linux 用户用 curl：

```python
curl -fsSL https://pi.dev/install.sh | sh
```

Windows 用户用 PowerShell：

```python

powershell -c "irm https://pi.dev/install.ps1 | iex"
```

### 方式二：npm 全局安装

如果你已经装了 Node.js，用包管理器全局安装即可。

注意那个 `--ignore-scripts` 参数：它会跳过依赖的安装期生命周期脚本，Pi 正常使用不需要这些脚本，加上更安全。

```python

# npm 安装
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# pnpm 安装
pnpm add -g --ignore-scripts @earendil-works/pi-coding-agent

# bun 安装
bun add -g --ignore-scripts @earendil-works/pi-coding-agent
```

### 验证安装

安装完成后，查看版本号确认是否成功：

```python

pi --version
```

例如：

```python

$ pi --version
0.80.6
```

### 卸载

卸载方式取决于你当初用什么装的：

```python

# curl 装的或 npm 装的
npm uninstall -g @earendil-works/pi-coding-agent

# pnpm 装的
pnpm remove -g @earendil-works/pi-coding-agent

# bun 装的
bun uninstall -g @earendil-works/pi-coding-agent
```

> 注意：卸载 Pi 不会删除你的配置。设置、凭证、会话记录、已安装的 Pi 包都保留在 `~/.pi/agent/` 目录里，需要手动清理。

## 配置模型 Provider

Pi 本身不包含大模型，它需要你提供至少一个模型供应商（Provider）的访问凭证。

配置方式有两种：订阅登录，或 API Key。

### 方式一：订阅登录（最省事）

如果你已经有 Claude Pro/Max、ChatGPT Plus/Pro 或 GitHub Copilot 订阅，可以直接登录复用。

启动 Pi 后运行 `/login`，然后选择供应商即可：

```python

# 启动 pi
pi

# 在 pi 里执行登录命令
/login
```

可选的订阅供应商有三种：

| 供应商 | 要求 | 说明 |
| --- | --- | --- |
| Claude Pro / Max | Anthropic 订阅 | 第三方工具用量按 Token 计费，不占订阅额度 |
| ChatGPT Plus / Pro（Codex） | OpenAI 订阅 | OpenAI 官方通过 Codex for OSS 认可 |
| GitHub Copilot | Copilot 订阅 | 若提示模型不支持，需在 VS Code 里先启用对应模型 |

登录后凭证会存进 `~/.pi/agent/auth.json`，过期会自动刷新。退出登录用 `/logout`。

### 方式二：API Key（最灵活）

用环境变量传入 API Key 是最通用的方式。比如用 Anthropic 的 Key：

```python

# 设置环境变量后启动
export ANTHROPIC_API_KEY=sk-ant-...
pi
```

你也可以在 Pi 里运行 `/login` 并选择 API Key 类型的供应商，把 Key 持久化存进 `auth.json`。

### 常见供应商的环境变量

Pi 支持 15 家以上的供应商，下面列出最常见的几家：

| 供应商 | 环境变量 | auth.json 里的键名 |
| --- | --- | --- |
| Anthropic | `ANTHROPIC_API_KEY` | anthropic |
| OpenAI | `OPENAI_API_KEY` | openai |
| Google Gemini | `GEMINI_API_KEY` | google |
| DeepSeek | `DEEPSEEK_API_KEY` | deepseek |
| Groq | `GROQ_API_KEY` | groq |
| Mistral | `MISTRAL_API_KEY` | mistral |
| xAI | `XAI_API_KEY` | xai |
| OpenRouter | `OPENROUTER_API_KEY` | openrouter |
| Hugging Face | `HF_TOKEN` | huggingface |

> 提示：`auth.json` 里的凭证优先级高于环境变量。如果两处都配了，以 `auth.json` 为准。

### auth.json 的结构

如果你想手动管理凭证，可以直接编辑 `~/.pi/agent/auth.json`。这个文件创建时会被设为 0600 权限（仅当前用户可读写）：

```python
{
  "anthropic": { "type": "api_key", "key": "sk-ant-..." },
  "openai": { "type": "api_key", "key": "sk-..." },
  "google": { "type": "api_key", "key": "..." }
}
```

Key 字段还支持三种高级写法，方便从密码管理器或环境变量里取值：

| 写法 | 含义 | 示例 |
| --- | --- | --- |
| `"!命令"` | 以感叹号开头，执行该命令并取 stdout 作为 Key | `"!op read 'op://vault/item/cred'"` |
| `"$变量名"` | 取环境变量的值 | `"$MY_ANTHROPIC_KEY"` |
| 纯字面量 | 直接当作 Key 使用 | `"sk-ant-..."` |

### 云平台供应商

如果你用的是云上的模型服务，Pi 也支持 Azure OpenAI、Amazon Bedrock、Google Vertex AI、Cloudflare 等。

这些通常需要额外配置端点、区域或部署名。以 Azure OpenAI 为例：

```python

# Azure OpenAI 所需的环境变量
export AZURE_OPENAI_API_KEY=...
export AZURE_OPENAI_BASE_URL=https://your-resource.ai.azure.com

# 可选：API 版本与部署名映射
export AZURE_OPENAI_API_VERSION=2024-02-01
export AZURE_OPENAI_DEPLOYMENT_NAME_MAP=gpt-4o=my-gpt4o
```

### 配置 DeepSeek 供应商

Pi 通过 models.json 支持自定义供应商，配置文件地址：

- Linux / macOS：~/.pi/agent/models.json
- Windows：%USERPROFILE%\.pi\agent\models.json

先在 DeepSeek 开放平台获取  API Key：[https://platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys)。

```python
{
  "providers": {
    "deepseek": {
      "baseUrl": "https://api.deepseek.com",
      "api": "openai-completions",
      "apiKey": "$DEEPSEEK_API_KEY",
      "models": [
        {
          "id": "deepseek-v4-pro",
          "name": "DeepSeek V4 Pro",
          "contextWindow": 1000000,
          "maxTokens": 384000,
          "input": ["text"],
          "reasoning": true,
          "cost": {
            "input": 1.74,
            "output": 3.48,
            "cacheRead": 0.145,
            "cacheWrite": 0
          },
          "compat": {
            "requiresReasoningContentOnAssistantMessages": true,
            "thinkingFormat": "deepseek",
            "reasoningEffortMap": {
              "minimal": "high",
              "low": "high",
              "medium": "high",
              "high": "high",
              "xhigh": "max"
            }
          }
        },
        {
          "id": "deepseek-v4-flash",
          "name": "DeepSeek V4 Flash",
          "contextWindow": 1000000,
          "maxTokens": 384000,
          "input": ["text"],
          "reasoning": true,
          "cost": {
            "input": 0.14,
            "output": 0.28,
            "cacheRead": 0.028,
            "cacheWrite": 0
          },
          "compat": {
            "requiresReasoningContentOnAssistantMessages": true,
            "thinkingFormat": "deepseek",
            "reasoningEffortMap": {
              "minimal": "high",
              "low": "high",
              "medium": "high",
              "high": "high",
              "xhigh": "max"
            }
          }
        }
      ]
    }
  }
}
```

设置环境变量：

Linux / Mac 用户：

```python

export DEEPSEEK_API_KEY="<你的 DeepSeek API Key>"
```

Windows 用户：

```python

$env:DEEPSEEK_API_KEY="<你的 DeepSeek API Key>"
```

进入项目目录并执行 pi 命令：

```python

cd /path/to/my-project
pi
```

输入 /model 打开模型切换器，选择 deepseek，然后选择 DeepSeek-V4-Pro 或 DeepSeek-V4-Flash。

更多配置选项请参阅：[https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/models.md](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/models.md)。

### 凭证解析顺序

当 Pi 需要某个供应商的凭证时，按以下顺序依次查找，找到即用：

| 优先级 | 来源 |
| --- | --- |
| 1（最高） | 命令行 `--api-key` 参数 |
| 2 | `auth.json` 里的条目（API Key 或 OAuth 令牌） |
| 3 | 环境变量 |
| 4 | `models.json` 里自定义供应商的 Key |

## 第一次运行

配置好凭证后，进入你的项目目录，直接运行 `pi` 启动。

```python

# 进入项目目录
cd /path/to/project

# 启动 pi
pi
```

启动后，直接输入一句话并回车，比如让它分析这个仓库：

```python

Summarize this repository and tell me how to run its checks.
```

Pi 会自动读取文件、运行命令，然后给出总结和检查方式。

### 项目信任提示

如果当前目录或上层目录里有 `.pi` 配置、扩展、技能等项目级资源，Pi 在交互式启动时会先问你信不信任这个项目。

这是为了防止一个仓库在你不知情时静默加载它的扩展或修改设置。

> 注意：信任决策保存在 `~/.pi/agent/trust.json`。非交互模式（`-p`、`--mode json`）不会弹窗，默认按全局设置里的 `defaultProjectTrust` 处理。

### Agent 是怎么工作的

你每发一条消息，Pi 就会启动一个 agent 循环。理解这个循环，就理解了 Pi 的工作方式。

核心是中间那个 turn 循环：模型每轮可能调用工具，Pi 执行工具把结果塞回上下文，再让模型继续，直到模型不再调用工具、给出最终回复。

## 四个内置工具

Pi 默认只给模型四个工具，覆盖了编码最核心的读写和执行能力。

| 工具 | 作用 | 是否默认启用 |
| --- | --- | --- |
| `read` | 读取文件内容 | 是 |
| `write` | 创建或覆盖文件 | 是 |
| `edit` | 对文件做局部补丁修改 | 是 |
| `bash` | 运行 shell 命令 | 是 |
| `grep` | 搜索文件内容 | 否（需通过工具选项开启） |
| `find` | 按条件查找文件 | 否（需通过工具选项开启） |
| `ls` | 列出目录内容 | 否（需通过工具选项开启） |

### 控制可用工具

你可以通过命令行参数精确控制模型能用哪些工具。

这在需要限制 Agent 能力时很有用，比如只让它审查代码而不许改动：

```python

# 只读模式：只允许读取和搜索类工具
pi --tools read,grep,find,ls -p "审查这段代码"

# 禁用某个工具，其余保留
pi --exclude-tools ask_question

# 关闭所有内置工具，只保留扩展提供的工具
pi --no-builtin-tools -e ./my-extension.ts

# 完全禁用工具，纯对话
pi --no-tools -p "解释一下这个概念"
```

> 提醒：Pi 在你的当前工作目录里运行，能修改你的文件。建议配合 git 等版本控制使用，方便随时回滚。

## 用 AGENTS.md 给项目下指令

AGENTS.md 是 Pi 的项目指令文件，告诉模型这个项目有什么规矩、怎么跑、要注意什么。

它的作用类似于 Claude Code 的 CLAUDE.md——而且 Pi 同时支持这两种文件名。

### 写一个 AGENTS.md

在项目根目录创建 `AGENTS.md`，写上你希望模型遵守的规则：

```python

# 项目指令

- 改完代码后运行 `npm run check`。
- 不要在本地跑生产环境的数据库迁移。
- 回答尽量简洁。
```

### Pi 从哪里加载指令

Pi 在启动时会从多个位置加载指令文件，按范围从大到小：

| 位置 | 作用范围 | 说明 |
| --- | --- | --- |
| `~/.pi/agent/AGENTS.md` | 全局 | 对你所有项目生效的通用指令 |
| 父目录的 `AGENTS.md` | 项目级 | 从当前目录向上逐层查找 |
| 当前目录的 `AGENTS.md` | 项目级 | 最具体、优先级最高的指令 |

文件名用 `AGENTS.md` 或 `CLAUDE.md` 都行，Pi 都会识别。

### 修改系统提示

AGENTS.md 是在默认系统提示之外追加的指令。如果你想更彻底地控制，可以替换整个系统提示。

在项目里放 `.pi/SYSTEM.md` 会替换默认系统提示；放 `.pi/APPEND_SYSTEM.md` 则是追加（全局对应 `~/.pi/agent/` 下的同名文件）。

> 注意：改了指令文件后，记得在 Pi 里运行 `/reload` 重载，或者重启 Pi，新指令才会生效。

## 交互模式常用操作

交互模式是 Pi 最常用的形态，掌握几个关键操作就能高效使用。

### 引用文件：@

在编辑器里输入 `@`，会弹出项目文件的模糊搜索，选中后文件内容会作为上下文发给模型。

你也可以在命令行启动时直接带上文件：

```python

# 启动时带上一个文件
pi @README.md "总结一下这个文件"

# 带上多个文件一起审查
pi @src/app.ts @src/app.test.ts "一起审查这两个文件"
```

### 运行 shell 命令：!

在编辑器里以 `!` 开头输入命令，会直接运行并把输出发给模型：

```python

# 运行命令，输出会进入模型上下文
!npm run lint

# 两个感叹号：运行但不把输出加进模型上下文
!!npm run build
```

### 切换模型与思考强度

Pi 支持中途切换模型和思考强度，适配不同任务的复杂度。

| 操作 | 快捷键 / 命令 | 说明 |
| --- | --- | --- |
| 打开模型选择器 | `/model` 或 Ctrl+L | 从所有可用模型里挑一个 |
| 切换思考强度 | Shift+Tab | 在 off / minimal / low / medium / high / xhigh / max 之间循环 |
| 循环收藏模型 | Ctrl+P / Shift+Ctrl+P | 在你预先圈定的几个模型间快速切换 |

启动时也可以直接指定模型和思考强度：

```python

# 指定厂商和模型
pi --provider openai --model gpt-4o "帮我重构"

# 用 厂商/模型 的写法
pi --model openai/gpt-4o "帮我重构"

# 用 名称:思考强度 的简写
pi --model sonnet:high "解决这个复杂问题"

# 限定可在 Ctrl+P 里循环的模型
pi --models "claude-*,gpt-4o"
```

### 输入与编辑技巧

| 操作 | 方式 | 说明 |
| --- | --- | --- |
| 多行输入 | Shift+Enter（Windows Terminal 用 Ctrl+Enter） | 在一条消息里换行 |
| 路径补全 | Tab | 补全文件路径 |
| 粘贴图片 | Ctrl+V（Windows 用 Alt+V） | 也支持把图片拖进终端 |
| 复制回复 | Ctrl+X | 复制最后一条助手消息 |
| 外部编辑器 | Ctrl+G | 打开 $VISUAL / $EDITOR 编辑长文本 |

### 边跑边插话

Agent 在工作时，你不用干等，可以随时插入消息。

| 按键 | 行为 | 适用场景 |
| --- | --- | --- |
| Enter | 转向消息：当前工具跑完后立刻送达，打断剩余工具 | 发现方向跑偏，及时纠正 |
| Alt+Enter | 后续消息：等 Agent 完全跑完再送达 | 想追加一个新需求 |
| Escape | 中止当前工作，把排队消息还原回编辑器 | 想停下来重新组织 |

> 提示：Windows Terminal 里 Alt+Enter 默认是全屏切换，转向和后续消息的按键可以在设置里通过 `steeringMode` 和 `followUpMode` 改。

## 常用斜杠命令速查

在编辑器里输入 `/` 就会弹出命令补全。下面是最常用的一批斜杠命令。

| 命令 | 功能 |
| --- | --- |
| `/login` / `/logout` | 管理 OAuth 或 API Key 凭证 |
| `/model` | 切换模型 |
| `/scoped-models` | 设置哪些模型参与 Ctrl+P 循环 |
| `/settings` | 调整思考强度、主题、消息送达方式等 |
| `/resume` | 从历史会话里选一个继续 |
| `/new` | 开一个新会话 |
| `/name <名称>` | 给当前会话起个显示名 |
| `/session` | 查看会话文件、ID、消息数、Token 用量和花费 |
| `/tree` | 跳到会话树的任意节点，从那里继续 |
| `/fork` | 从某条历史消息分叉出一个新会话 |
| `/clone` | 把当前分支复制成一个新会话 |
| `/compact [提示]` | 手动压缩上下文，可带自定义指令 |
| `/copy` | 复制最后一条助手消息到剪贴板 |
| `/export [文件]` | 把会话导出为 HTML 或 JSONL |
| `/import <文件>` | 从 JSONL 文件导入并恢复会话 |
| `/share` | 上传为私有 GitHub Gist，生成可分享的 HTML 链接 |
| `/reload` | 重载快捷键、扩展、技能、提示、主题和上下文文件 |
| `/trust` | 保存当前项目的信任决策 |
| `/hotkeys` | 显示所有快捷键 |
| `/changelog` | 查看版本更新历史 |
| `/quit` | 退出 Pi |

## 会话管理：树形历史

Pi 的会话不是一条直线，而是一棵树。

这意味着你在任意一个历史节点分叉，都不会丢失原来的分支，所有分支都存在同一个会话文件里。

### 会话存在哪里

会话自动保存到 `~/.pi/agent/sessions/`，按工作目录归类。

从命令行恢复或浏览历史会话：

```python

# 继续最近一次会话
pi -c

# 浏览并选择一个历史会话
pi -r

# 给会话起个名字，方便日后查找
pi --name "my task"

# 打开指定的会话文件或 ID
pi --session <path|id>

# 临时会话，不保存
pi --no-session
```

### 在会话树里导航

用 `/tree` 可以打开会话树视图，跳到任意历史节点继续。

从这里继续会产生一条新分支，原来的分支保持不变。

### 分叉与克隆

| 命令 | 行为 | 区别 |
| --- | --- | --- |
| `/fork` | 从某条更早的用户消息分叉出新会话 | 从历史中间某个点重新开始 |
| `/clone` | 复制当前活跃分支成新会话 | 在当前最新状态基础上开一份副本 |

### 压缩上下文

当对话变长、接近模型的上下文上限时，Pi 会自动把较早的消息压缩成摘要。

你也可以主动用 `/compact` 触发，还能附带一句自定义指令告诉它压缩时保留什么重点：

```python

# 在 pi 里手动压缩，并要求保留最近改动
/compact 重点保留最近的改动和错误处理
```

### 导出与分享

把会话导出成 HTML 方便存档或展示：

```python

# 导出为 HTML 文件
/export my-session.html

# 上传为私有 GitHub Gist，得到分享链接
/share
```

## 非交互模式与集成

Pi 不只能交互式对话，它还能作为命令行工具、事件流、RPC 服务和 SDK 库来用。

### 一次性提问：print 模式

用 `-p` 让 Pi 回答完就退出，适合在脚本里调用：

```python

# 直接提问
pi -p "总结一下这个代码库"

# 配合管道，把内容喂给 Pi
cat README.md | pi -p "总结这段文字"

# 带图片提问
pi -p @screenshot.png "这张图里是什么？"
```

### 事件流：JSON 模式

`--mode json` 会把所有事件以 JSON 行的形式输出，方便程序解析：

```python

# 输出 JSON 事件流
pi --mode json -p "列出 src 下所有 .ts 文件"
```

### 进程集成：RPC 模式

`--mode rpc` 通过 stdin/stdout 走 JSON 协议，适合非 Node 的程序（比如 Python、Go）来驱动 Pi。

### 导出已有会话

不启动新会话，直接把一个已有会话文件导出成 HTML：

```python

# 把会话文件导出为 HTML
pi --export session.jsonl output.html
```

### SDK 模式

如果你要在自己的 Node 应用里嵌入 Pi 的能力，可以用 SDK 模式把它当作库引入。

这是比 RPC 更紧密的集成方式，详见官方文档的 SDK 章节：[https://pi.dev/docs/latest/sdk](https://pi.dev/docs/latest/sdk)。

## 扩展 Extensions

扩展是 Pi 可扩展性的核心。它就是一个 TypeScript 模块，能订阅生命周期事件、注册自定义工具、添加命令和快捷键。

扩展通过 jiti 加载，所以直接写 TypeScript 即可，无需编译。

### 扩展放在哪里

| 位置 | 作用范围 |
| --- | --- |
| `~/.pi/agent/extensions/*.ts` | 全局，所有项目生效 |
| `.pi/extensions/*.ts` | 项目级，仅当前项目生效 |

也可以是子目录形式（`扩展名/index.ts`），或带 `package.json` 的完整包。

### 一个最小扩展示例

下面这个扩展演示了三件事：启动时通知、拦截危险命令、注册一个自定义工具和一个命令。

```python

// 文件路径：~/.pi/agent/extensions/my-extension.ts
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

// 扩展导出一个默认工厂函数，接收 ExtensionAPI
export default function (pi: ExtensionAPI) {

  // 1. 监听 session_start 事件：会话启动时弹个通知
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("扩展已加载！", "info");
  });

  // 2. 监听 tool_call 事件：拦截危险的 bash 命令
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
      // 弹确认框，用户拒绝就阻止执行
      const ok = await ctx.ui.confirm("危险操作！", "允许执行 rm -rf 吗？");
      if (!ok) return { block: true, reason: "被用户阻止" };
    }
  });

  // 3. 注册一个自定义工具，模型可以调用它
  pi.registerTool({
    name: "greet",
    label: "打招呼",
    description: "按名字向某人打招呼",
    parameters: Type.Object({
      name: Type.String({ description: "要打招呼的名字" }),
    }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return {
        content: [{ type: "text", text: `你好，${params.name}！` }],
        details: {},
      };
    },
  });

  // 4. 注册一个斜杠命令 /hello
  pi.registerCommand("hello", {
    description: "打个招呼",
    handler: async (args, ctx) => {
      ctx.ui.notify(`你好 ${args || "world"}！`, "info");
    },
  });
}
```

写完后用 `-e` 参数临时加载测试：

```python

# 临时加载一个扩展来测试
pi -e ./my-extension.ts
```

### 扩展能做什么

扩展的能力远不止上面这些，它几乎能介入 Pi 工作流的每个环节：

| 能力 | 对应方法 | 典型用途 |
| --- | --- | --- |
| 注册自定义工具 | `pi.registerTool()` | 让模型调用你的业务接口 |
| 注册命令 | `pi.registerCommand()` | 添加自己的斜杠命令 |
| 注册快捷键 | `pi.registerShortcut()` | 绑定自定义快捷键 |
| 拦截工具调用 | `tool_call` 事件 | 权限确认、命令改写 |
| 修改上下文 | `context` 事件 | 过滤历史、注入 RAG 内容 |
| 注入消息 | `pi.sendMessage()` | 动态补充上下文 |
| 注册供应商 | `pi.registerProvider()` | 接入私有模型网关 |
| 自定义 UI | `ctx.ui` 系列 | 对话框、状态栏、组件 |

> 提示：Pi 仓库里有 50 多个示例扩展，涵盖子 Agent、计划模式、权限门、SSH 执行、沙箱等，是学习扩展开发的最好参考。

## 技能 Skills

技能是另一种可复用的能力包，和扩展的区别在于：技能主要是给模型看的指令和脚本，按需加载。

Pi 实现了 Agent Skills 标准，所以也能直接用 Claude Code、OpenAI Codex 等工具的技能。

### 技能的工作方式

技能采用渐进式披露（progressive disclosure）的原则。

启动时 Pi 只把每个技能的名字和描述放进系统提示；当任务匹配时，模型才用 `read` 工具加载完整的技能说明。

这样既能装很多技能，又不会一开始就把上下文撑满。

### 技能放在哪里

| 位置 | 作用范围 |
| --- | --- |
| `~/.pi/agent/skills/` | 全局 |
| `~/.agents/skills/` | 全局（跨工具共享） |
| `.pi/skills/` | 项目级（需项目被信任） |
| `.agents/skills/` | 项目级（跨工具共享） |

### 技能的结构

一个技能就是一个包含 `SKILL.md` 的目录，其余文件随意组织：

```python

my-skill/
├── SKILL.md              # 必需：前置信息 + 指令
├── scripts/              # 辅助脚本
│   └── process.sh
├── references/           # 按需加载的详细文档
│   └── api-reference.md
└── assets/
    └── template.json
```

### SKILL.md 的写法

SKILL.md 顶部是前置信息（frontmatter），下面是给模型的指令正文：

```python

---
name: my-skill
description: 这个技能做什么、什么时候用。要写具体。
---

# My Skill

## Setup

首次使用前运行一次：
```bash
cd /path/to/skill && npm install
```

## Usage

```bash
./scripts/process.sh <input>
```
```

前置信息里最重要的两个字段：

| 字段 | 是否必填 | 说明 |
| --- | --- | --- |
| `name` | 必填 | 最多 64 字符，只能用小写字母、数字、连字符 |
| `description` | 必填 | 最多 1024 字符，决定模型何时加载这个技能，要写得具体 |

> 提醒：`description` 写得好不好，直接决定模型会不会在正确时机用上这个技能。写「处理 PDF 文件，提取文本和表格、填表单、合并多个 PDF」远好过写「帮助处理 PDF」。

### 手动调用技能

模型不一定会主动加载技能。你可以用 `/skill:名称` 强制加载并执行：

```python
# 加载并执行技能
/skill:brave-search

# 带参数加载技能
/skill:pdf-tools extract
```

## Pi 包管理

扩展、技能、提示模板、主题都可以打包成 Pi 包，通过 npm 或 git 分享安装。

Pi 内置了一套包管理命令，让你像装插件一样扩展能力。

### 安装与卸载

```python
# 从 npm 安装一个包
pi install npm:@foo/pi-tools

# 从 git 仓库安装
pi install git:github.com/badlogic/pi-doom

# 项目本地安装（加 -l）
pi install npm:@foo/pi-tools -l

# 卸载
pi remove npm:@foo/pi-tools
```

### 更新与查看

| 命令 | 功能 |
| --- | --- |
| `pi list` | 列出已安装的包 |
| `pi update` | 只更新 Pi 自身 |
| `pi update --all` | 更新 Pi 和所有包 |
| `pi update --extensions` | 只更新包，不动 Pi 本体 |
| `pi update --extension <源>` | 更新指定的某个包 |
| `pi config` | 启用或禁用包里的各项资源 |

## 安全须知

安全是使用 Pi 前必须了解的部分。Pi 的安全模型和很多 Agent 工具不同，需要你主动配合。

### 没有内置沙箱

Pi 不包含内置沙箱，它以启动它的用户身份运行，拥有该用户的全部权限。

内置工具可以读写文件、运行 shell 命令；扩展是 TypeScript 模块，权限和 Pi 进程一样。

这是有意为之：Pi 要在本机源码上工作、调用项目工具链、融入开发环境，一个不完整的进程内沙箱会让人误以为是安全边界，实际却仍依赖宿主的 shell、文件系统和凭证。

> 重要：真正的隔离必须来自操作系统或容器/虚拟化边界，而不是 Pi 内部。

### 项目信任

项目信任决定 Pi 是否加载项目级的设置、资源、扩展和包。

当一个目录里存在 `.pi/settings.json`、`.pi/extensions`、`.pi/skills`、`.pi/SYSTEM.md` 等内容时，Pi 会要求先信任才能加载。

| 信任级别 | 行为 | 设置方式 |
| --- | --- | --- |
| `ask`（默认） | 交互式询问；非交互模式忽略项目资源 | settings.json 的 `defaultProjectTrust` |
| `always` | 始终信任项目资源 | 同上，或用 `-a` / `--approve` |
| `never` | 从不信任，忽略项目资源 | 同上，或用 `-na` / `--no-approve` |

信任决策保存在 `~/.pi/agent/trust.json`，按目录路径记录，最近的父目录决策优先。

> 注意：项目信任只是「输入加载守卫」，它防止仓库静默改你的设置或扩展，但不能让不可信的代码、提示或模型输出变得安全。仓库文件、注释、文档里的提示注入是本地 Agent 固有的风险，Pi 无法可靠阻止。

### 处理不可信或无人值守的任务

对于不受信任的仓库、需要密切监控的生成代码、或无人值守的自动化，官方建议把 Pi 放进隔离环境里跑。

推荐做法：

- 把整个 `pi` 进程放进容器、虚拟机或远程沙箱
- 只挂载 Agent 应该访问的工作区路径
- 除非必要，不要挂载宿主的 `~/.pi/agent`（里面有你的凭证和会话）
- 只传最少必要的 API Key，或用短期凭证
- 任务不需要联网时，限制网络访问
- 把结果复制回可信系统前，先审查 diff 和输出

> 提醒：如果你把宿主工作区以读写方式挂载进容器，容器内的写入仍会改到宿主文件。要更强地防范误写，用只读挂载，或把文件复制进出沙箱。

## 资源与社区

### 官方资源

- GitHub 仓库：[github.com/earendil-works/pi](https://github.com/earendil-works/pi)
- 官网：[pi.dev](https://pi.dev/)
- 官方文档：[pi.dev/docs/latest](https://pi.dev/docs/latest)
- npm 包：[@earendil-works/pi-coding-agent](https://www.npmjs.com/package/@earendil-works/pi-coding-agent)

 其他扩展
