---
id: runoob-agent-first-ai-agent
title: 编写你的第一个 AI Agent
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/first-ai-agent.html
category: 04-主流框架与开发实战
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 主流框架与开发实战
- 编写你的第一个 AI
summary: 第一个 AI Agent AI Agent 平台种类繁多，但核心目的相同：让模型从回答问题升级为自动执行任务，有的主打零代码拖拽，有的强调工程化定制，也有专门做流程集成或多代理协作。
  不同层级的使用场景拆成三个面向：搭建速度、系统衔接、可控...
published: true
---

# 编写你的第一个 AI Agent

> **出处**：[https://www.runoob.com/ai-agent/first-ai-agent.html](https://www.runoob.com/ai-agent/first-ai-agent.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`04-主流框架与开发实战`

---

# 第一个 AI Agent

AI Agent 平台种类繁多，但核心目的相同：让模型从回答问题升级为自动执行任务，有的主打零代码拖拽，有的强调工程化定制，也有专门做流程集成或多代理协作。

不同层级的使用场景拆成三个面向：搭建速度、系统衔接、可控深度。

| 核心需求 | 推荐工具 | 关键优势 |
| --- | --- | --- |
| MonkeyCode，AI 应用开发平台 | [MonkeyCode 官网](https://monkeycode-ai.com/?ic=019d94af-c5d0-7207-a923-89d7ccf67d91) | 直接在平台里创建任务，让 AI 编码，在云端开发环境中使用终端、文件管理和预览 |
| 小云雀，剪映的 AI 视频生成 | [剪映-小云雀](https://xyq.jianying.com?utm_medium=paidads&utm_source=aitools&utm_campaign=hw_xyq_runoob) | 字节自研 Seedance 2.0 视频模型 + Seedream 5.0 图像模型，搭配豆包大模型做文案理解 |
| 自动化触发与系统对接 | [n8n](https://github.com/n8n-io/n8n) | 集成面广，可自托管，常规内部系统都能打通 |
| 开发者可控的深度定制 | [Dify](https://github.com/langgenius/dify) / [LangChain](https://github.com/langchain-ai/langchain) | 前者提供完整开源方案；后者适合构建复杂推理链路 |
| 多角色协作与任务分解 | [AutoGen](https://github.com/microsoft/autogen) / [CrewAI](https://github.com/crewAIInc/crewAI) | 前者强调动态协作；后者以清晰角色体系驱动流程 |

## 0 代码进行 Vibe Coding

MonkeyCode 不仅是可以进行 Vibe Coding 的 AI 编程工具，它覆盖了 需求 → 设计 → 开发 → Review 全流程，免费使用，无需安装，内置云端开发环境。

### 注册与登录

**首次使用 MonkeyCode，先完成账号注册。
      点击
      [进入官网](https://monkeycode-ai.com/?ic=019d94af-c5d0-7207-a923-89d7ccf67d91)
      ，右上角注册或直接登录，成功后会自动进入主界面开始使用。**

进入页面后，点击右上角 **注册** 创建新账号，已有账号可直接登录使用。

注册成功后，我们进入控制台，输入我们的需求：

```python

帮我写一个 JavaScript 小游戏：程序随机生成 1 到 100 的数字，让我猜，猜大了提示「太大了」，猜小了提示「太小了」，猜中了就结束。
```

点击执行，并选择模型，国内的很多模型都是免费支持的，这里采用 qwen3.8-flash：

开始任务：

任务完成后可以查看生成的效果地址：

查看效果：

### 切换不同模型

我们也可以切换模型，这样可以比较不同模型生成的效果，**旗舰版还执行 Astra。**

使用不同模型再测试这个应用，左边上角可以切换模型：

输入以下内容：

```python

重新优化整个界面
```

修改完成后，访问它生成的链接：

完整效果，好多了：

<hr>
<h2>0 生成应用代码</h2>

<div style="
  padding:14px 18px;
  margin:16px 0;
  border:1px solid #cfe8d5;
  border-radius:12px;
  background:linear-gradient(135deg,#f4fbf6,#eefaf1);
  color:#1f2937;
  font-size:15px;
  line-height:1.8;
  display:flex;
  align-items:flex-start;
  gap:10px;
">
  <i class="fa fa-leaf" style="
    color:#4caf7a;
    font-size:16px;
    margin-top:4px;
    flex-shrink:0;
  "></i>

  <div>
    <strong>
      我们可以先用最简单的秒哒来生成应用，
      先访问官网注册
      <a href="https://www.miaoda.cn/?invitecode=user-93thly701s00"
         target="_blank"
         style="
           color:#2f855a;
           text-decoration:none;
           font-weight:700;
         ">
        秒哒官网
      </a>
      ，登录后在输入框输入要生成的应用。
    </strong>
  </div>
</div>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/3cbb89ab-9035-49cf-9d37-10d699f56608.png"></p><p>
接下来秒哒就开始生成一份需求文档，还是很详细的，然后我们可以在右侧点编辑文档或生成应用按钮，它就会根据我们的需求直接开始生成应用：</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/a79f912c-ac27-499b-8dcc-5185f8ae4992.png"></p>
<p>接下来就会开始生成代码，整个过程，都不用写一行代码，直接生成：</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/6871e121-8c71-45b4-9733-c5d1c6bea507.png"></p>
<p>看下界面及使用效果，非常好用：</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/20559228-55a3-4544-896f-cab55d636178-1.png"></p>

另外插件部分还提供了其他高级功能支持，比如视频：
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/3c692dbf-a9a1-4ba1-82cb-1eb9bd5f725e.png"></p>
<p>如果你还不知道能看啥，还能去应用广场看看其他人做的优秀产品：</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/5db9f27d-eaab-4984-a75c-a32f1608aa47.png"></p>


<hr><h2>桌面级 Agent</h2>

<p>DuMate 是百度推出的桌面级 AI 办公智能体,它可以操作文件、读写 Excel、整理数据、生成 PPT、操作浏览器。</p>
<p>
我们只需用自然语言描述任务，DuMate 就能端到端完成交付。</p>

<h3>下载与安装</h3>
<p>DuMate 支持以下操作系统：</p>

<table class="reference">
<thead>
<tr>
<th>操作系统</th>
<th>芯片架构</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>macOS</td>
<td>Apple Silicon（M 系列芯片）</td>
<td>原生支持，性能更优</td>
</tr>
<tr>
<td>Windows</td>
<td>X86</td>
<td>传统桌面端支持</td>
</tr>
</tbody>
</table><div style="
  padding:14px 18px;
  margin:16px 0;
  border:1px solid #cfe8d5;
  border-radius:12px;
  background:linear-gradient(135deg,#f4fbf6,#eefaf1);
  color:#1f2937;
  font-size:15px;
  line-height:1.8;
  display:flex;
  align-items:flex-start;
  gap:10px;
">
  <i class="fa fa-leaf" style="
    color:#4caf7a;
    font-size:16px;
    margin-top:4px;
    flex-shrink:0;
  "></i>

  <div>
    <strong>
      我们先点击访问
      <a href="https://www.dumate.cn/?track=aiwebsite_3"
         target="_blank"
         style="
           color:#2f855a;
           text-decoration:none;
           font-weight:700;
         ">
        DuMate 官网
      </a>
      注册 DuMate 账号，
    </strong>
      会下载对应系统的安装包。
   
  </div>
</div>
<p>双击安装包，按照引导完成安装。</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2026/05/runoob_1779694866991.png"></p>
h3>登录账号</h3>
<p>DuMate 支持以下账号登录方式：</p>

<table class="reference">
<thead>
<tr>
<th>登录方式</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>百度账号</td>
<td>使用已有的百度账号直接登录</td>
</tr>
<tr>
<td>百度智能云账号</td>
<td>使用百度智能云账号登录，适合企业用户</td>
</tr>
<tr>
<td>手机号注册</td>
<td>未注册用户支持手机号一键注册后登录</td>
</tr>
</tbody>
</table>
<h3>新建任务</h3>
<p>点击左侧栏顶部「新任务」按钮，即可进入对话主界面。</p>

<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob1_8522f39.png"></p>
<h3>新建任务</h3>
<p>可通过「设置工作区」划定专属文件夹，作为 DuMate 独立运行目录，工作区遵循最小权限机制，仅开放AI任务必要访问范围；授权目录内程序拥有完整操作权限，具体包含：</p>
<ul>
    <li>读取：查阅全部文件内容</li>
    <li>编辑：改动已有文件</li>
    <li>创建：新增文件与文件夹</li>
    <li>删除：可执行文件删除操作，操作前会弹窗二次确认</li>
</ul>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob2_8522f39.png"></p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob3_8522f39.png"></p>
<h3>操作流程</h3>
<h4>创建任务</h4>
<p>在对话输入框填写任务内容，回车发送即可发起任务，如需关联本地文件，点击输入框旁「+」按钮选取目标文件。<br>平台兼容主流格式，支持Word、PPT、Excel、TXT、Markdown、图片、视频、压缩包等文件处理。</p><p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob4_8522f39.png"></p>
<h4>右侧功能栏说明</h4>
<ul>
    <li><strong>任务进程</strong>：复杂多步骤任务会自动生成执行清单，可实时查看待办事项与运行状态</li>
    <li><strong>任务文件</strong>：展示任务中途文件及最终产出，部分格式支持在线预览，也可调用本地程序打开查看</li>
    <li><strong>调用能力</strong>：包含工具连接器Connectors与功能技能Skills两类，分别对应运行调用工具与实操技能</li>
</ul><p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob5_8522f39.png"></p>
<h4>任务终止与增补</h4>
<p>任务运行中，点击输入框右下角停止按键即可中止进程。<br>直接输入新需求并发送，系统会自动结束当前任务，切换执行新增指令。</p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob6_8522f39.png"></p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob7_8522f39.png"></p>

<h4>任务删除</h4>
<p>在左侧对话列表右键选中对应任务，便可完成删除操作。</p><p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob8_8522f39.png"></p>
<p><img decoding="async" src="https://www.runoob.com/wp-content/uploads/2025/12/runoob9_8522f39.png"></p>
  其他扩展
