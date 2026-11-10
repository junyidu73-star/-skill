# Windsurf 接入

规则文件放在项目根目录的 `.windsurf/rules/` 下。

```powershell
New-Item -ItemType Directory -Force ".windsurf\rules" | Out-Null
Copy-Item "adapters\windsurf\.windsurf\rules\proposal-writing-discipline.md" ".windsurf\rules\proposal-writing-discipline.md"
```

文件头部使用 `model_decision` 触发方式：

```yaml
---
trigger: model_decision
description: 撰写、修改或审查申报书、项目方案、研究计划等正式文案时必须全程使用……
---
```

Cascade 会依据 `description` 决定是否加载。若希望常驻，把 `trigger` 改成 `always_on`；也可以改成 `glob` 并指定文档目录，只在处理该目录时生效。

Windsurf 对单个规则文件的长度有上限，当前版本约 6000 字符以内是安全的。这份规则正文约 3000 字，未超限。若后续扩写超过上限，改用 `adapters/universal/system-prompt-compact.md` 作为规则正文。

规则正文由 `scripts/sync-adapters.ps1` 从根目录 `SKILL.md` 生成，不要直接改正文。
