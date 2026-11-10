# -skill

跨模型可用的写作与研究方法 skill 集合。每个子目录是一份独立技能，含规范源文件和若干模型的接入适配。

| 技能 | 用途 | 适用模型 |
| --- | --- | --- |
| [proposal-writing-discipline](proposal-writing-discipline/) | 申报书、项目方案、研究计划的写作纪律：文风、因果、结构、文献、格式、终审 | Claude Code、Codex、DeepSeek 等网页模型、Cursor、Windsurf、opencode |

## 使用

进入对应子目录看 `README.md`。安装脚本：

```powershell
cd proposal-writing-discipline
.\scripts\install.ps1 -Target claude,opencode,codex
```

```bash
cd proposal-writing-discipline
./scripts/install.sh claude opencode codex
```

## 新增技能

新建子目录，放一个带 frontmatter 的 `SKILL.md` 作为唯一规范源，其余文件由脚本生成或说明引用方式，然后在上面表格登记一行。
