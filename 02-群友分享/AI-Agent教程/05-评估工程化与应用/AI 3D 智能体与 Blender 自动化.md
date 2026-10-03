---
id: runoob-agent-ai-3d-blender
title: AI 3D 智能体与 Blender 自动化
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/ai-3d-blender.html
category: 05-评估工程化与应用
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 评估工程化与应用
- AI 3D 智能体与
summary: AI 3D Blender GPT6 Astra 发布后，大家开始用 AI 玩 3D 了： 有人用蒸汽火车草图，让它在 Blender 里生成出几千个物体的完整场景。
  有人让它把特斯拉 Model X 拆解成 334 个独立模型部件。 还有...
published: true
---

# AI 3D 智能体与 Blender 自动化

> **出处**：[https://www.runoob.com/ai-agent/ai-3d-blender.html](https://www.runoob.com/ai-agent/ai-3d-blender.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`05-评估工程化与应用`

---

# AI 3D (Blender)

GPT-6 Astra 发布后，大家开始用 AI 玩 3D 了：

- 有人用蒸汽火车草图，让它在 Blender 里生成出几千个物体的完整场景。
- 有人让它把特斯拉 Model X 拆解成 334 个独立模型部件。
- 还有人让同它制作 3D 游戏。

各种应用层出不穷，现在的 AI 是真的可以在 3D 软件里建模、调材质、跑代码，跟一个真正坐在电脑前操作软件的人没什么区别。

## Blender 是什么

Blender 是一套完全免费开源的 3D 创作软件，先认识一下它，再谈怎么让 AI 接管它。

它覆盖建模、雕刻、绑骨、动画、模拟、渲染、合成、运动跟踪、视频剪辑这一整条 3D 生产链路。

Blender 由 Blender 基金会牵头维护，社区驱动，主要靠捐赠支撑运转，全球有几千名贡献者参与开发。

它支持 Windows、macOS、Linux 三大平台，被 AMD、Apple、Intel、NVIDIA、高通等硬件厂商官方支持。

下载地址：[https://www.blender.org/download/](https://www.blender.org/download/)

## Blender MCP 是什么

blender-mcp 是一个开源项目，负责在 AI 客户端和 Blender 之间传递指令。

它的 GitHub 主页是这样自我介绍的：用你选择的任意 LLM 控制 Blender 3D，目前已经有 27.9k Star。

> - 项目地址：[https://github.com/ahujasid/blender-mcp](https://github.com/ahujasid/blender-mcp)
>
> - 官网：[https://mcp-for-blender.com/](https://mcp-for-blender.com/)

### 工作原理

整条链路分四段：你说需求，客户端规划步骤，blender-mcp 服务转发指令，Blender 内的插件真正执行。

插件执行完每一步，会把视口截图和场景状态返回给 AI。

AI 看到渲染结果后再决定下一步动作，如此循环，直到它认为场景符合你的要求。

### 不用 MCP 行不行

可以，但体验差很多。

像 Codex 这类带电脑操控能力的 Agent，可以直接去看 Blender 的界面、移动鼠标点菜单：

两种方式的对比如下：

| 接入方式 | 原理 | 优点 | 适用场景 |
| --- | --- | --- | --- |
| Blender MCP | 通过插件接口直接调用 Blender API | 快、稳定、能精确传参 | 日常建模、批量操作、自动化出图 |
| 电脑操控 Agent | 识别屏幕像素后模拟鼠标键盘 | 不装插件就能用 | 临时操作，或插件无法覆盖的界面功能 |

需要精确、可重复的操作时，MCP 是明显更好的选择。

## 准备工作

开始之前确认三件事：装好 Blender、Python 版本达标、有一个 MCP 客户端。

| 软件 | 版本要求 | 是否必装 | 说明 |
| --- | --- | --- | --- |
| Blender | 3.0 及以上 | 必装 | 3D 软件本体，从官网下载 |
| Python | 3.10 及以上 | 必装 | 运行 MCP 服务用，macOS 可用 brew 安装 |
| uv | 最新版即可 | 必装 | Python 包管理工具，用来启动 blender-mcp |
| MCP 客户端 | 任意一款 | 任选其一 | Claude Code、Codex、Claude Desktop、Cursor 等都支持 |

> MCP 客户端装一个就够了，下文的命令以 Claude Code 和 Codex 为例，其他客户端配置方式类似。

## 快速开始：四步接上 Blender

整个安装流程只有四步：装 uv、配置客户端、装 Blender 插件、点连接。

### 第一步：安装 uv

uv 是启动 blender-mcp 服务的工具，三个平台的安装命令如下：

## 实例

# macOS（需要先装好 Homebrew）
brew install uv

# Linux，用官方脚本安装
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows，在 PowerShell 里执行
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

装完验证一下，能输出版本号就是成功了：

```python

$ uvx --version
uvx 0.9.5
```

> 一定要用上面的官方方式安装，不要用 pip install uv，pip 方式可能装不出 uvx 这个命令，后面客户端会找不到它。

### 第二步：把 MCP 服务加进客户端

告诉你的 AI 客户端：存在一个叫 blender 的 MCP 服务，启动方式是 uvx blender-mcp。

Claude Code 用户在终端执行：

## 实例

# 把 blender 服务注册进 Claude Code，-- 后面是启动命令
claude mcp add blender -- uvx blender-mcp

Codex 用户执行：

## 实例

# Codex 的注册命令，格式相同
codex mcp add blender -- uvx blender-mcp

Claude Desktop 用户编辑配置文件，文件路径在 macOS 是 ~/Library/Application Support/Claude/claude_desktop_config.json：

## 实例



{
  "mcpServers": {
    "blender": {
      "command": "uvx",
      "args": ["blender-mcp"]
    }
  }
}

注册完用 claude mcp list 检查，状态是 connected 就说明服务能正常启动：

```python

$ claude mcp list
blender: uvx blender-mcp - Connected
```

### 第三步：安装 Blender 插件

Blender 这一侧需要一个插件来接收指令，用一条命令自动安装：

## 实例

# 下载并安装 Blender 插件，只需执行一次
uvx blender-mcp install-addon

然后打开 Blender，进入「编辑 → 偏好设置」：

在「插件」页面搜索并勾选启用 MCP for Blender：

> 客户端连接的对象是这个插件，不是 Blender 本体，所以插件必须先启用。

### 第四步：连接

回到 Blender 的 3D 视图，按 N 键打开右侧边栏，找到「MCP for Blender」标签页：

点「Connect to MCP Server」，状态变为已连接就全部打通了：

现在可以直接跟 AI 说你想做什么了。

## 实战：一条龙守着一罐金币

这是官方给的示例提示词，也是检验安装是否成功最快的方式。

```python

在地牢里做一个低多边形场景，一条龙守着一罐金币
```

Claude Code 收到提示词后，会先查看场景状态，再列一个执行计划分步搭建：

Codex 的执行过程类似，同样是规划、执行、截图验证的循环：

几分钟后 AI 会交付工程文件和渲染图，下面是完成效果：

放大看最终渲染图：石砖地牢、火把、低多边形巨龙和金币罐都齐了：

整个过程你只说了一句话，剩下的规划、建模、打光、验证全部由 AI 完成。

> AI 执行的是真实的 Python 代码，会直接改动当前打开的 .blend 文件，实验前建议先另存一份副本。

## 常用指令与技巧

会连之后，这些提示词可以直接抄走用。

| 目标 | 示例提示词 | 说明 |
| --- | --- | --- |
| 从零建场景 | 在地牢里做一个低多边形场景，一条龙守着一罐金币 | 一句话描述画面即可，AI 会自己规划 |
| 了解场景现状 | 看看现在场景里有什么物体 | 接手别人的工程文件时先用这条 |
| 添加真实资产 | 在场景里加一把中世纪风格的木椅 | 需要先在插件面板启用 PolyHaven 资产库 |
| 调整材质 | 给地板换上潮湿的石砖纹理 | PolyHaven 提供免费的 PBR 贴图 |
| 渲染出图 | 调一个能看清巨龙正面的相机角度，渲染一张效果图 | 让 AI 自己截图检查再交付 |

实测下来有三个技巧能明显提高成功率。

一是 一次只提一个目标，做完一条龙再加地牢，比一口气全要更容易成功。

二是 要求它分步截图自查，AI 每步都能看到视口截图，及时发现塌陷、穿模这类问题。

三是 复杂场景先要计划，让它先列出搭建步骤，确认无误再动手。

## 常见问题

按报错现象归类，遇到问题对号入座。

### 客户端连不上，提示 Connection refused

绝大多数是顺序问题，Blender 没开或者插件没点连接。

正确顺序是：先打开 Blender，在插件面板点 Connect to MCP Server，再去客户端里发指令。

还不行就检查 9876 端口是不是被其他程序占用，插件默认监听这个端口。

### 提示找不到 uvx 命令

多半是用 pip 安装的 uv，这种安装方式不带 uvx。

用官方脚本或 brew 重装一次，然后重开终端让 PATH 生效。

### 客户端里看不到 blender 服务

先跑 claude mcp list 确认注册状态。

Claude Desktop 用户重点检查配置文件的 JSON 语法是否正确，改完配置要重启客户端。

如果只想在某个项目里启用，注意命令默认写入当前项目作用域，全局使用要加 --scope user 参数。

### AI 把场景改坏了怎么办

先在 Blender 里用 Ctrl + Z 撤销，多数操作可以回退。

更稳妥的做法是让 AI 每一步执行前先说明要做什么，执行后截图给你确认，发现不对立刻叫停。

重要工程在动手前另存副本，是成本最低的保险。

 其他扩展
