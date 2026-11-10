# opencode 接入

opencode 与 Claude Code 使用同一种 skills 结构：一个目录，里面放 `SKILL.md`，靠 frontmatter 的 `name` 和 `description` 被检索到。

## 个人级

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\opencode\skills\proposal-writing-discipline" | Out-Null
Copy-Item "adapters\opencode\skills\proposal-writing-discipline\SKILL.md" "$env:USERPROFILE\.config\opencode\skills\proposal-writing-discipline\SKILL.md"
```

## 项目级

```powershell
New-Item -ItemType Directory -Force ".opencode\skills\proposal-writing-discipline" | Out-Null
Copy-Item "adapters\opencode\skills\proposal-writing-discipline\SKILL.md" ".opencode\skills\proposal-writing-discipline\SKILL.md"
```

## 验证

新开会话，问“有哪些可用的 skill”，列表里应出现 `proposal-writing-discipline`。也可以直接让它改一段申报书文字，看是否先建底稿。

## 说明

如果沿用默认配置，`description` 就足够触发。希望在某个项目里强制加载，可以在项目根目录建 `AGENTS.md`，写一行“写申报书时必须先加载 skill: proposal-writing-discipline”。

规则正文由 `scripts/sync-adapters.ps1` 从根目录 `SKILL.md` 生成。
