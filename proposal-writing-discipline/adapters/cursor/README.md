# Cursor 接入

规则文件使用 `.mdc` 扩展名，放在项目根目录的 `.cursor/rules/` 下。

```powershell
New-Item -ItemType Directory -Force ".cursor\rules" | Out-Null
Copy-Item "adapters\cursor\.cursor\rules\proposal-writing-discipline.mdc" ".cursor\rules\proposal-writing-discipline.mdc"
```

文件头部的配置是：

```yaml
---
description: 撰写、修改或审查申报书、项目方案、研究计划等正式文案时必须全程使用……
globs:
alwaysApply: false
---
```

`alwaysApply: false` 且不设 `globs`，属于 Agent Requested 模式，由 Cursor 依据 `description` 判断是否加载。写申报书、改方案时会被拉进来，日常写代码不会占用上下文。

如果项目里全是文档，希望规则一直生效，把 `alwaysApply` 改成 `true`。代价是每次对话都占用上下文。

规则正文由 `scripts/sync-adapters.ps1` 从根目录 `SKILL.md` 生成，不要直接改 `.mdc` 里的正文。
