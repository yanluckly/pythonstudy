---
description: Run all project scripts (Python + ABAP review) and summarize results in one report. Use when the user runs /testcommand or asks to run a comprehensive test of all project code.
---

# Comprehensive Test Command

Execute the following tests in order and produce a summary report.

## Step 1: Run Python Scripts

Run each Python script and capture the output:

1. `python testforgg01.py` — Leap year calculator
2. `python "abc=28.py"` — Mathematical puzzle solver
3. `python "爬取天气.py"` — Weather data scraper

For each script, record:
- Status: PASS / FAIL / ERROR
- Key output or error message
- Execution time if notable

If a script requires user input or runs interactively, note that and skip gracefully.

## Step 2: ABAP Code Review

Activate the `abap-dev-assistant` skill and review all `.abap` files using the Code Review Checklist:

- Program name follows Z/Y prefix convention
- File header is complete
- BAPI calls have proper commit/rollback handling
- Error messages use defined message class
- Selection screen has proper validation
- ALV field catalog covers all display fields
- SY-SUBRC is checked after function module calls
- Internal tables are sorted before BINARY SEARCH
- No obsolete language elements

For each file, record checklist results with PASS / WARNING / FAIL.

## Step 3: Summary Report

Output a consolidated report in this format:

```
=== Project Test Report ===
Date: [current date]

--- Python Scripts ---
| Script        | Status | Notes |
|---------------|--------|-------|
| testforgg01   | ...    | ...   |
| abc=28        | ...    | ...   |
| 爬取天气      | ...    | ...   |

--- ABAP Review ---
| File          | Checklist Score | Critical Issues |
|---------------|----------------|-----------------|
| zbc001.prog   | x/9 passed     | ...             |

--- Overall ---
Total PASS: x
Total WARNING: x
Total FAIL: x
```
