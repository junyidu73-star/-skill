param(
    [ValidateSet('claude', 'opencode', 'codex', 'universal', 'cursor', 'windsurf', 'all')]
    [string[]]$Target = @('all'),
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

if ($Target -contains 'all') {
    $Target = @('claude', 'opencode', 'codex', 'universal', 'cursor', 'windsurf')
}

$skillSrc = Join-Path $Root 'SKILL.md'
if (-not (Test-Path -LiteralPath $skillSrc)) {
    throw "找不到 SKILL.md：$skillSrc"
}

function Install-Skill {
    param([string]$DestDir)
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    Copy-Item -LiteralPath $skillSrc -Destination (Join-Path $DestDir 'SKILL.md') -Force
    Write-Output "已安装到 $DestDir"
}

function Install-Rule {
    param([string]$Source, [string]$DestDir, [string]$DestName)
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    Copy-Item -LiteralPath $Source -Destination (Join-Path $DestDir $DestName) -Force
    Write-Output "已安装到 $(Join-Path $DestDir $DestName)"
}

foreach ($t in $Target) {
    switch ($t) {
        'claude' {
            Install-Skill (Join-Path $env:USERPROFILE '.claude\skills\proposal-writing-discipline')
        }
        'opencode' {
            Install-Skill (Join-Path $env:USERPROFILE '.config\opencode\skills\proposal-writing-discipline')
        }
        'codex' {
            $codexDir = Join-Path $env:USERPROFILE '.codex'
            $agents = Join-Path $codexDir 'AGENTS.md'
            if (Test-Path -LiteralPath $agents) {
                $sidecar = Join-Path $codexDir 'AGENTS.proposal-writing-discipline.md'
                Copy-Item -LiteralPath (Join-Path $Root 'adapters\codex\AGENTS.md') -Destination $sidecar -Force
                Write-Output "已存在 $agents，未覆盖。规则写到 $sidecar"
                Write-Output "请在该文件末尾加一行引用，或手动合并内容。"
            }
            else {
                Install-Rule (Join-Path $Root 'adapters\codex\AGENTS.md') $codexDir 'AGENTS.md'
            }
        }
        'universal' {
            Write-Output "通用提示词不在本机安装，文件位置："
            Write-Output "  完整版 $(Join-Path $Root 'adapters\universal\system-prompt.md')"
            Write-Output "  精简版 $(Join-Path $Root 'adapters\universal\system-prompt-compact.md')"
            Write-Output "把内容粘贴到模型的自定义指令或系统提示词即可。"
        }
        'cursor' {
            Install-Rule (Join-Path $Root 'adapters\cursor\.cursor\rules\proposal-writing-discipline.mdc') (Join-Path (Get-Location) '.cursor\rules') 'proposal-writing-discipline.mdc'
        }
        'windsurf' {
            Install-Rule (Join-Path $Root 'adapters\windsurf\.windsurf\rules\proposal-writing-discipline.md') (Join-Path (Get-Location) '.windsurf\rules') 'proposal-writing-discipline.md'
        }
    }
}

Write-Output '完成。'
