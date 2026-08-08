# server-stats.sh
Project for DevOps roadmap on roadmap.sh

https://roadmap.sh/projects/server-stats

# System Usage Report Script

A Bash script that prints a quick snapshot of CPU, memory, and disk usage, along with the top 5 processes by CPU and memory consumption.

## What it does

- **CPU usage** — overall current usage, calculated as `100% - idle%`
- **Memory usage** — total / used / free (including cache/buffers as reclaimable), with percentage used
- **Disk usage** — total / used / available across all mounted filesystems, with percentage used
- **Top 5 processes by CPU usage** — PID, command, and CPU%
- **Top 5 processes by memory usage** — PID, command, and MEM%

All sections are computed from a single cached `top -bn2` snapshot, so the script only pays the `top` sampling delay once.

## Requirements

This script was built and tested on a standard Linux desktop/server setup and depends on the following:

| Tool | Required version / notes |
|---|---|
| `bash` | Any modern version |
| `top` | **procps-ng** flavor (standard on Debian, Ubuntu, Fedora, RHEL/CentOS, Arch). BusyBox `top` (Alpine, minimal containers) is **not** supported — different output format. |
| `free` | procps-ng version with an `available` column (v3.3.10+, i.e. most systems from ~2014 onward) |
| `df` | Standard GNU coreutils `df` |
| `awk` | Any POSIX-compliant awk (gawk, mawk, BusyBox awk all work — no gawk-only features used) |

### Not guaranteed to work on
- Alpine Linux or other BusyBox-based systems (different `top` output format)
- Very old distros with legacy `free` (no `available` column)
- Minimal containers without `bash` installed

## Usage

1. Clone the repository
2. Make it executable:
   ```bash
   chmod +x server-stats.sh
   ```
3. Run it:
   ```bash
   ./server-stats.sh
   ```

No arguments or flags — it just runs and prints the full report.

## Example output

```
----------------------CPU usage:----------------------
Your current CPU usage is 4.3%
----------------------Memory usage:----------------------
You are using 47.03% of your memory
Total: 14.94Gi
Used: 7.04Gi
Free: 7.90Gi
----------------------Disk usage:----------------------
You are using 62.15% of your disk
Size: 512.00G
Used: 318.20G
Available: 193.80G
----------------------Top 5 processes by CPU usage:----------------------
   Usage  PID  Command
1. 9.1% 10998 Discord
2. 9.1% 57966 top
3. 0.0% 1 systemd
4. 0.0% 2 kthreadd
5. 0.0% 3 pool_wo+
----------------------Top 5 processes by memory usage:----------------------
   Usage  PID  Command
1. 5.6% 5388 brave
2. 3.5% 11367 Discord
3. 1.4% 10998 Discord
4. 0.1% 1 systemd
5. 0.0% 57966 top
```

## Known limitations

- **CPU snapshot accuracy**: `top -bn2` takes two samples ~3 seconds apart and uses the second (more accurate) one for the top-5 lists. The single-line "current CPU usage" figure is drawn from the same second sample.
- Colored/bold output uses ANSI escape codes — these render correctly in a normal terminal but will appear as raw escape characters if output is redirected to a file or a non-ANSI-aware destination (e.g. some log viewers, `cron` mail).

## Troubleshooting

- **Output looks wrong or empty**: check your `top` flavor with `top --version` — it should say "procps-ng". If not, the script's column-position logic won't match your `top`'s output format.
- **Memory section errors out**: check `free -m` — the header row should include an `available` column. If it doesn't, your `free` version is too old for this script as written.
