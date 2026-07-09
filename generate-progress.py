#!/usr/bin/env python3
from __future__ import annotations

import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
OUTPUT = ROOT / "progress.svg"

DIFFICULTIES = (
    ("Easy", "#22c55e"),
    ("Medium", "#f59e0b"),
    ("Hard", "#ef4444"),
)


def count_solutions(difficulty: str) -> int:
    folder = SRC / difficulty
    if not folder.exists():
        return 0
    return sum(1 for item in folder.iterdir() if item.is_file() and not item.name.startswith("."))


def build_segments(counts: dict[str, int]) -> str:
    total = sum(counts.values())
    radius = 68
    circumference = 2 * math.pi * radius

    if total == 0:
        return (
            f'<circle cx="100" cy="100" r="{radius}" fill="none" '
            'stroke="#e5e7eb" stroke-width="22" />'
        )

    segments: list[str] = []
    offset = 0.0
    for difficulty, color in DIFFICULTIES:
        count = counts[difficulty]
        if count == 0:
            continue

        length = count / total * circumference
        gap = circumference - length
        segments.append(
            f'<circle cx="100" cy="100" r="{radius}" fill="none" '
            f'stroke="{color}" stroke-width="22" '
            f'stroke-dasharray="{length:.3f} {gap:.3f}" '
            f'stroke-dashoffset="{-offset:.3f}" '
            'transform="rotate(-90 100 100)" />'
        )
        offset += length

    return "\n  ".join(segments)


def build_legend(counts: dict[str, int]) -> str:
    rows: list[str] = []
    y = 58
    for difficulty, color in DIFFICULTIES:
        rows.append(
            f'<rect x="220" y="{y - 10}" width="12" height="12" rx="2" fill="{color}" />'
        )
        rows.append(
            f'<text x="242" y="{y}" class="legend">{difficulty}: {counts[difficulty]}</text>'
        )
        y += 30
    return "\n  ".join(rows)


def main() -> None:
    counts = {difficulty: count_solutions(difficulty) for difficulty, _ in DIFFICULTIES}
    total = sum(counts.values())

    svg = f"""<svg width="420" height="200" viewBox="0 0 420 200" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="LeetCode progress">
  <style>
    .title {{ fill: #111827; font: 700 18px Arial, sans-serif; }}
    .total {{ fill: #111827; font: 700 28px Arial, sans-serif; text-anchor: middle; }}
    .caption {{ fill: #6b7280; font: 500 12px Arial, sans-serif; text-anchor: middle; }}
    .legend {{ fill: #374151; font: 600 14px Arial, sans-serif; }}
  </style>
  <rect width="420" height="200" rx="16" fill="#ffffff" />
  <circle cx="100" cy="100" r="68" fill="none" stroke="#f3f4f6" stroke-width="22" />
  {build_segments(counts)}
  <text x="100" y="96" class="total">{total}</text>
  <text x="100" y="116" class="caption">solved</text>
  <text x="220" y="30" class="title">Progress by difficulty</text>
  {build_legend(counts)}
</svg>
"""

    OUTPUT.write_text(svg, encoding="utf-8")


if __name__ == "__main__":
    main()
