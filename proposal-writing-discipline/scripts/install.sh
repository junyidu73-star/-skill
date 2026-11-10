#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$ROOT/SKILL.md"

if [[ ! -f "$SKILL_SRC" ]]; then
    echo "找不到 SKILL.md：$SKILL_SRC" >&2
    exit 1
fi

targets=("$@")
if [[ ${#targets[@]} -eq 0 || " ${targets[*]} " == *" all "* ]]; then
    targets=(claude opencode codex universal cursor windsurf)
fi

install_skill() {
    local dest="$1"
    mkdir -p "$dest"
    cp "$SKILL_SRC" "$dest/SKILL.md"
    echo "已安装到 $dest"
}

install_rule() {
    local src="$1" dest_dir="$2" name="$3"
    mkdir -p "$dest_dir"
    cp "$src" "$dest_dir/$name"
    echo "已安装到 $dest_dir/$name"
}

for t in "${targets[@]}"; do
    case "$t" in
        claude)
            install_skill "$HOME/.claude/skills/proposal-writing-discipline"
            ;;
        opencode)
            install_skill "$HOME/.config/opencode/skills/proposal-writing-discipline"
            ;;
        codex)
            codex_dir="$HOME/.codex"
            if [[ -f "$codex_dir/AGENTS.md" ]]; then
                cp "$ROOT/adapters/codex/AGENTS.md" "$codex_dir/AGENTS.proposal-writing-discipline.md"
                echo "已存在 $codex_dir/AGENTS.md，未覆盖。规则写到 $codex_dir/AGENTS.proposal-writing-discipline.md"
                echo "请在该文件末尾加一行引用，或手动合并内容。"
            else
                install_rule "$ROOT/adapters/codex/AGENTS.md" "$codex_dir" "AGENTS.md"
            fi
            ;;
        universal)
            echo "通用提示词不在本机安装，文件位置："
            echo "  完整版 $ROOT/adapters/universal/system-prompt.md"
            echo "  精简版 $ROOT/adapters/universal/system-prompt-compact.md"
            echo "把内容粘贴到模型的自定义指令或系统提示词即可。"
            ;;
        cursor)
            install_rule "$ROOT/adapters/cursor/.cursor/rules/proposal-writing-discipline.mdc" "$PWD/.cursor/rules" "proposal-writing-discipline.mdc"
            ;;
        windsurf)
            install_rule "$ROOT/adapters/windsurf/.windsurf/rules/proposal-writing-discipline.md" "$PWD/.windsurf/rules" "proposal-writing-discipline.md"
            ;;
        *)
            echo "未知目标：$t" >&2
            exit 1
            ;;
    esac
done

echo "完成。"
