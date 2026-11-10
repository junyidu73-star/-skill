param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

$skillPath = Join-Path $Root 'SKILL.md'
$raw = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8
$m = [regex]::Match($raw, '(?s)^---\r?\n(.*?)\r?\n---\r?\n')
if (-not $m.Success) { throw 'SKILL.md 缺少 frontmatter' }

$front = $m.Groups[1].Value
$body = $raw.Substring($m.Length)
$descMatch = [regex]::Match($front, 'description:\s*(.+)')
if (-not $descMatch.Success) { throw 'SKILL.md 缺少 description' }
$desc = $descMatch.Groups[1].Value.Trim()

$enc = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    $dir = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, $enc)
}

Write-Utf8 (Join-Path $Root 'adapters\claude-code\skills\proposal-writing-discipline\SKILL.md') $raw
Write-Utf8 (Join-Path $Root 'adapters\opencode\skills\proposal-writing-discipline\SKILL.md') $raw

$cursor = "---`ndescription: $desc`nglobs:`nalwaysApply: false`n---`n`n" + $body
Write-Utf8 (Join-Path $Root 'adapters\cursor\.cursor\rules\proposal-writing-discipline.mdc') $cursor

$windsurf = "---`ntrigger: model_decision`ndescription: $desc`n---`n`n" + $body
Write-Utf8 (Join-Path $Root 'adapters\windsurf\.windsurf\rules\proposal-writing-discipline.md') $windsurf

$agentsHeader = @'
# AGENTS.md

撰写、修改或审查申报书、项目方案、研究计划等正式文案时，按下面这份纪律执行。规则对每一段都生效，不许只用在其中一部分，全文写完必须做终审并输出终审报告。

开工前先建立四份底稿，并在整个任务中持续维护：

- 本意清单：必须保留的事实、数字、姓名、术语、方法名、时间节点。
- 脉络表：全文一句话主张，每一节要回答的问题，每一段的中心句。
- 术语表：同一概念只用一个名字，首次出现时解释一次。
- 引用台账：格式见下文第六部分。

下面是从 SKILL.md 同步的规则正文，修改时请改 SKILL.md，然后运行 scripts/sync-adapters.ps1。

---

'@
Write-Utf8 (Join-Path $Root 'adapters\codex\AGENTS.md') ($agentsHeader + $body)

$promptHeader = @'
以下是一份写作纪律，适用于申报书、项目方案、研究计划、开题报告等正式文案的撰写、修改和审查。请把这份纪律当作本次任务的强制约束，对每一段都生效，结束时按第九部分输出终审报告。

'@
Write-Utf8 (Join-Path $Root 'adapters\universal\system-prompt.md') ($promptHeader + $body)

Write-Output 'adapters 已同步'
