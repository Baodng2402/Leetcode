#!/usr/bin/env python3
from __future__ import annotations

import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
OUTPUT = ROOT / "progress.svg"

DIFFICULTIES = (
    ("Easy", "#00b8a3"),
    ("Medium", "#ffc01e"),
    ("Hard", "#ff375f"),
)


def count_solutions(difficulty: str) -> int:
    folder = SRC / difficulty
    if not folder.exists():
        return 0
    return sum(1 for item in folder.iterdir() if item.is_file() and not item.name.startswith("."))


def build_segments(counts: dict[str, int]) -> str:
    total = sum(counts.values())
    radius = 72
    circumference = 2 * math.pi * radius

    if total == 0:
        return (
            f'<circle cx="120" cy="120" r="{radius}" fill="none" '
            'stroke="#2d2d3a" stroke-width="18" />'
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
            f'<circle cx="120" cy="120" r="{radius}" fill="none" '
            f'stroke="{color}" stroke-width="18" stroke-linecap="round" '
            f'stroke-dasharray="{length:.3f} {gap:.3f}" '
            f'stroke-dashoffset="{-offset:.3f}" '
            'transform="rotate(-90 120 120)" />'
        )
        offset += length

    return "\n  ".join(segments)


def build_legend(counts: dict[str, int]) -> str:
    rows: list[str] = []
    y = 72
    for difficulty, color in DIFFICULTIES:
        count = counts[difficulty]
        rows.append(f'<circle cx="268" cy="{y - 4}" r="6" fill="{color}" />')
        rows.append(
            f'<text x="284" y="{y}" class="legend-label">{difficulty}</text>'
        )
        rows.append(
            f'<text x="390" y="{y}" class="legend-value" text-anchor="end">{count}</text>'
        )
        y += 36
    return "\n  ".join(rows)


def main() -> None:
    counts = {difficulty: count_solutions(difficulty) for difficulty, _ in DIFFICULTIES}
    total = sum(counts.values())

    svg = f"""<svg width="480" height="240" viewBox="0 0 480 240" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="LeetCode progress">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1a1a2e" />
      <stop offset="100%" stop-color="#16213e" />
    </linearGradient>
    <linearGradient id="ring-glow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ffa116" stop-opacity="0.15" />
      <stop offset="100%" stop-color="#ffa116" stop-opacity="0" />
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-color="#000" flood-opacity="0.35" />
    </filter>
  </defs>
  <style>
    .title {{ fill: #f8fafc; font: 700 20px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }}
    .subtitle {{ fill: #94a3b8; font: 500 12px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }}
    .total {{ fill: #ffffff; font: 800 36px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; text-anchor: middle; }}
    .caption {{ fill: #94a3b8; font: 600 11px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; text-anchor: middle; letter-spacing: 0.08em; }}
    .legend-label {{ fill: #cbd5e1; font: 600 14px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }}
    .legend-value {{ fill: #f8fafc; font: 700 16px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }}
    .divider {{ stroke: #2d3748; stroke-width: 1; }}
  </style>
  <rect width="480" height="240" rx="20" fill="url(#bg)" />
  <rect x="1" y="1" width="478" height="238" rx="19" fill="none" stroke="#ffa116" stroke-opacity="0.25" stroke-width="1" />
  <circle cx="120" cy="120" r="88" fill="url(#ring-glow)" />
  <circle cx="120" cy="120" r="{72 + 9}" fill="none" stroke="#2d2d3a" stroke-width="18" />
  {build_segments(counts)}
  <text x="120" y="112" class="total">{total}</text>
  <text x="120" y="134" class="caption">SOLVED</text>
  <line x1="230" y1="40" x2="230" y2="200" class="divider" />
  <text x="250" y="44" class="title">Progress</text>
  <text x="250" y="62" class="subtitle">by difficulty</text>
  {build_legend(counts)}
</svg>
"""

    OUTPUT.write_text(svg, encoding="utf-8")


if __name__ == "__main__":
    main()
