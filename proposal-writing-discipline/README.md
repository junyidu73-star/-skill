# proposal-writing-discipline

一份跨模型的写作纪律，用于申报书、项目方案、研究计划、开题报告等正式文案。目标是压住四类常见毛病：翻译腔、强行因果、上下文跳脱、引用没读透。

内容本身不绑定任何厂商。同一份规则可以放进 Claude Code 的 skills 目录、Codex 的 `AGENTS.md`、DeepSeek 或其他网页模型的自定义指令、Cursor / Windsurf 的规则文件，也可以直接贴进系统提示词。

## 它约束什么

| 问题 | 对应章节 | 具体做法 |
| --- | --- | --- |
| 文字生硬、像译文 | 第三部分 | 动词还原、拆长句、去掉空词与口号 |
| 因果强行绑定 | 第四部分 | 每个连接词做三项检查，缺推理就降级 |
| 全文结构散 | 第五部分 | 先写脉络表，一节一问，一段一句 |
| 文献没读透 | 第六部分 | 引用台账，标注是否读过全文与支撑位置 |
| 一眼看出是模型写的 | 第七部分 | 限制引号、冒号、反问、破折号、套话 |

技能是强制性的：每一段都要按它写，每节写完做一次快查，全文写完做四遍终审并输出终审报告。

## 仓库结构

```
proposal-writing-discipline/
├── SKILL.md                          # 唯一的规范源文件
├── README.md
├── LICENSE
├── adapters/
│   ├── claude-code/
│   │   ├── README.md
│   │   └── skills/proposal-writing-discipline/SKILL.md
│   ├── codex/
│   │   ├── README.md
│   │   └── AGENTS.md
│   ├── universal/
│   │   ├── README.md
│   │   ├── system-prompt.md
│   │   └── system-prompt-compact.md
│   ├── cursor/
│   │   ├── README.md
│   │   └── .cursor/rules/proposal-writing-discipline.mdc
│   ├── windsurf/
│   │   ├── README.md
│   │   └── .windsurf/rules/proposal-writing-discipline.md
│   └── opencode/
│       ├── README.md
│       └── skills/proposal-writing-discipline/SKILL.md
├── templates/
│   ├── 四份底稿.md
│   └── 终审报告.md
└── scripts/
    ├── install.ps1
    └── install.sh
```

`adapters/` 下每个目录都带一份与 `SKILL.md` 同源的副本，方便直接拷贝，不必手动改路径。改动规则时只改 `SKILL.md`，再运行 `scripts/sync-adapters.ps1`（或手动覆盖副本）。

## 快速开始

### Claude Code

个人级安装，所有项目可用：

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\proposal-writing-discipline" | Out-Null
Copy-Item SKILL.md "$env:USERPROFILE\.claude\skills\proposal-writing-discipline\SKILL.md"
```

项目级安装，只对当前仓库生效：

```powershell
New-Item -ItemType Directory -Force ".claude\skills\proposal-writing-discipline" | Out-Null
Copy-Item SKILL.md ".claude\skills\proposal-writing-discipline\SKILL.md"
```

装好后在会话里说“用 proposal-writing-discipline 写这段”或直接让它改申报书，Claude Code 会按 description 自动加载。

### Codex

Codex 读取 `AGENTS.md`。把 `adapters/codex/AGENTS.md` 放到项目根目录，或者在 `~/.codex/AGENTS.md` 里加一行引用：

```markdown
撰写或修改申报书、项目方案、研究计划时，先读 <本仓库路径>/SKILL.md 并全程遵守，最后输出终审报告。
```

项目根目录方式更适合单项目；全局方式适合所有会话。

### DeepSeek、GPT、Gemini 等网页模型

没有文件系统，用提示词接入。把 `adapters/universal/system-prompt.md` 全文粘贴到“自定义指令”“系统提示词”或对话第一条消息。上下文较紧的模型用 `system-prompt-compact.md`，它保留了强制项，删掉了举例。

### Cursor

把 `adapters/cursor/.cursor/rules/proposal-writing-discipline.mdc` 复制到项目根目录的 `.cursor/rules/`。规则默认不常驻，由 Cursor 根据 description 判断何时加载。

### Windsurf

把 `adapters/windsurf/.windsurf/rules/proposal-writing-discipline.md` 复制到项目根目录的 `.windsurf/rules/`。

### opencode

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\opencode\skills\proposal-writing-discipline" | Out-Null
Copy-Item SKILL.md "$env:USERPROFILE\.config\opencode\skills\proposal-writing-discipline\SKILL.md"
```

也可以放到项目的 `.opencode/skills/` 下。

### 一键脚本

```powershell
.\scripts\install.ps1 -Target claude,codex,opencode
```

```bash
./scripts/install.sh claude codex opencode
```

脚本只复制文件，不改动已有配置；重复执行会覆盖同名文件。

## 怎么用起来才有效

触发词尽量具体，例如“按申报书纪律改这一节”“检查这段的因果”“核对这份参考文献列表”“做整篇终审”。只说“润色一下”容易让模型跳过底稿和台账。

前四份底稿值得让模型先输出，再动笔。省掉这一步，后面的自查和终审就没有对照物。`templates/四份底稿.md` 是空表，可以直接贴给模型。

终审报告不要省略。它同时是验收材料，能看出模型有没有真按纪律走：因果遍要给出成立、降级、拆开、删除的处理，引用遍要能说清每条文献读到哪一节。

## 各模型的实际差异

| 接入方式 | 是否常驻 | 是否自动触发 | 说明 |
| --- | --- | --- | --- |
| Claude Code skills | 常驻可发现 | 是 | 最完整，支持按需加载 |
| Codex `AGENTS.md` | 常驻 | 是 | 纯文本，靠模型自觉 |
| 网页模型系统提示词 | 会话内常驻 | 是 | 需手动粘贴，长文档注意上下文 |
| Cursor rules | 按需 | 是 | Agent 请求时加载 |
| Windsurf rules | 按需 | 是 | `model_decision` 触发 |
| opencode skills | 常驻可发现 | 是 | 与 Claude Code 同格式 |

小上下文模型（8k 到 16k）建议用精简版，并把待改章节分段提交，避免终审时丢掉前半部分。

## 已知边界

这套规则约束的是写作过程和常见缺陷，不能替代作者判断。事实、数据、方法名、申报体例的最终责任在作者。第六部分的文献要求依赖模型实际能读到的全文；读不到时它会标【待核实】，这种情况必须人工补齐，不能当作已核实。

技能不负责生成申报书内容，也不替作者决定研究方案。

## 许可

MIT，见 `LICENSE`。
