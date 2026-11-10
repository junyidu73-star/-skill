# Codex 接入

Codex 的规则入口是 `AGENTS.md`。支持项目根目录、父目录逐级向上，以及 `~/.codex/AGENTS.md` 全局配置。本目录的 `AGENTS.md` 已经包含完整的规则正文，由 `scripts/sync-adapters.ps1` 从根目录 `SKILL.md` 同步生成。

## 项目级

把 `AGENTS.md` 放到项目根目录：

```powershell
Copy-Item "adapters\codex\AGENTS.md" ".\AGENTS.md"
```

如果项目已有 `AGENTS.md`，不要覆盖，改为在文件末尾追加一行：

```markdown
撰写或修改申报书、项目方案、研究计划时，先读 <本仓库路径>\SKILL.md 并全程遵守，结束时输出终审报告。
```

## 全局

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex" | Out-Null
Copy-Item "adapters\codex\AGENTS.md" "$env:USERPROFILE\.codex\AGENTS.md"
```

`~/.codex/AGENTS.md` 对这台机器上的所有 Codex 会话生效。已存在同名文件时先备份，别直接覆盖。

## 说明

`AGENTS.md` 是纯文本约定，模型是否逐段执行取决于它自己的遵守程度。规则里保留了“开工先建四份底稿”“每节快查”“全文终审”这三道可观察的卡点，用来判断它有没有真的执行。验收时看两样东西：四份底稿是否存在，终审报告是否包含四遍结果。

规则正文较长，约三千字，常见上下文窗口足够。上下文很紧的模型改用 `adapters/universal/system-prompt-compact.md`。

改动规则请改根目录 `SKILL.md`，再运行 `scripts/sync-adapters.ps1`。
