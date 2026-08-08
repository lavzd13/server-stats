#!/bin/bash

top_output=$(top -bn2)

# CPU usage script
echo -e "\e[1m----------------------CPU usage:----------------------\e[0m"
echo "$top_output" | grep "%Cpu" | tail -n1 | LC_NUMERIC=C awk '{for(i=1;i<=NF;i++) if($i=="id,") idle=$(i-1); gsub(",", ".", idle); printf "Your current CPU usage is %.1f%%\n", 100.0-idle}'

# Memory usage script
echo -e "\e[1m----------------------Memory usage:----------------------\e[0m"
free -m | grep "Mem:" | awk -F' ' '{printf "You are using %.2f%% of your memory\nTotal: %.2fGi\nUsed: %.2fGi\nFree: %.2fGi\n", ($3/$2)*100, $2/1024, $3/1024, ($4+$7)/1024}'

# Disk usage script
echo -e "\e[1m----------------------Disk usage:----------------------\e[0m"
df | awk -F ' ' '{SIZE+=$2};{USED+=$3};{AVAILABLE+=$4}; END{printf "You are using %.2f%% of your disk\nSize: %.2fG\nUsed: %.2fG\nAvailable: %.2fG\n", (USED/SIZE)*100, SIZE/(1024*1024), USED/(1024*1024), AVAILABLE/(1024*1024)}'

# Top 5 processes by CPU usage
echo "$top_output" | awk 'BEGIN{block=0} /^top -/{block++} block==2' | tail -n +8 | LC_NUMERIC=C awk 'BEGIN { printf "\033[1m----------------------Top 5 processes by CPU usage:----------------------\033[0m\n   Usage  PID  Command\n"; start=0 } {gsub(",", ".", $9); start++ ;printf "%d. %.1f%% %s %s\n", start, $9, $1, $12; if (start==5) exit}'

# Top 5 processes by memory usage
echo "$top_output" | awk 'BEGIN{block=0} /^top -/{block++} block==2' | tail -n +8 | sort -nrk10 | LC_NUMERIC=C awk 'BEGIN { printf "\033[1m----------------------Top 5 processes by memory usage:----------------------\033[0m\n   Usage  PID  Command\n"; start=0 } {gsub(",", ".", $10); start++ ; printf "%d. %.1f%% %s %s\n", start, $10, $1, $12; if (start==5) exit}'
