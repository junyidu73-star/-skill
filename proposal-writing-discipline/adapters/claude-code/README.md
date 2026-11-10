# Claude Code 接入

Claude Code 通过 skills 目录发现技能，读取 `SKILL.md` 的 frontmatter，用 `description` 判断何时加载，加载后把正文注入上下文。

## 个人级安装

所有项目都能用：

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\proposal-writing-discipline" | Out-Null
Copy-Item "adapters\claude-code\skills\proposal-writing-discipline\SKILL.md" "$env:USERPROFILE\.claude\skills\proposal-writing-discipline\SKILL.md"
```

macOS 与 Linux：

```bash
mkdir -p ~/.claude/skills/proposal-writing-discipline
cp adapters/claude-code/skills/proposal-writing-discipline/SKILL.md ~/.claude/skills/proposal-writing-discipline/
```

## 项目级安装

只对当前仓库生效，适合团队共用一个写作规范：

```powershell
New-Item -ItemType Directory -Force ".claude\skills\proposal-writing-discipline" | Out-Null
Copy-Item "adapters\claude-code\skills\proposal-writing-discipline\SKILL.md" ".claude\skills\proposal-writing-discipline\SKILL.md"
```

## 验证

启动会话后输入 `/skills`，列表里应出现 `proposal-writing-discipline`。也可以直接说“按 proposal-writing-discipline 改这一节”，看它是否先产出本意清单和脉络表。

## 说明

`SKILL.md` 的 frontmatter 只用了 `name` 和 `description`，没有加 `allowed-tools`，这样不会限制模型使用读写与检索工具。如果团队想强制每次会话都加载，可以把 `description` 改成显式触发语，或在项目的 `CLAUDE.md` 里加一行“写申报书时必须先读 `.claude/skills/proposal-writing-discipline/SKILL.md`”。

改动规则请改仓库根目录的 `SKILL.md`，再运行 `scripts/sync-adapters.ps1` 把副本同步过来。
