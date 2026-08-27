#!/usr/bin/env bash

# Server info
hostnamectl | grep "Operating System"
echo "Kernel version: $(uname -r)"
echo "Uptime: $(uptime | awk '{print $1, $2, $3}' | sed 's/,//')"
echo "Connected users: $(uptime | awk '{print $4}')"
echo "Load average: $(uptime | awk '{print $8, $9, $10}')"
echo "\n"

# CPU usage
echo "<---- CPU ---->"
cpu_usage=$(top -bn2 -d 1 | grep "Cpu(s)" | tail -1 | awk '{print $2 + $4 + $14}')
echo "Usage: ${cpu_usage}%\n"

# Total memory usage (Free vs Used)
echo "<---- Memory ---->"
memory_total=$(free -m | awk 'NR==2 {print $2}')
memory_free=$(free -m | awk 'NR==2 {print $4}')
memory_used=$(free -m | awk 'NR==2 {print $3}')
memory_usage=$(echo "scale=2; $memory_used / $memory_total * 100" | bc)

echo "Total: ${memory_total} MiB"
echo "Free: $memory_free MiB"
echo "Used: $memory_used MiB"
echo "Usage: ${memory_usage}%\n"

# Total disk usage (Free vs Used)
echo "<---- Disk ---->"
disk_line_info=$(df -h / | tail -1)
disk_total=$(echo "$disk_line_info" | awk '{print $2}')
disk_used=$(echo "$disk_line_info" | awk '{print $3}')
disk_free=$(echo "$disk_line_info" | awk '{print $4}')
disk_usage=$(echo "$disk_line_info" | awk '{print $5}')

echo "Size: ${disk_total}"
echo "Free: $disk_free"
echo "Used: $disk_used"
echo "Usage: ${disk_usage}\n"


echo "<---- TOP 5 processes by CPU ---->"
ps aux --sort=-%cpu | tail -n +2 | head -5 | while read line; do
    pid=$(echo "$line" | awk '{print $2}')
    cpu=$(echo "$line" | awk '{print $3}')
    mem=$(echo "$line" | awk '{print $4}')
    command=$(echo "$line" | awk '{print $11}')
    echo "PID: $pid, CPU: $cpu, MEM: $mem, COMMAND: $command"
done
echo "\n"

echo "<---- TOP 5 processes by MEMORY ---->"
ps aux --sort=-%mem | tail -n +2 | head -5 | while read line; do
    pid=$(echo "$line" | awk '{print $2}')
    cpu=$(echo "$line" | awk '{print $3}')
    mem=$(echo "$line" | awk '{print $4}')
    command=$(echo "$line" | awk '{print $11}')
    echo "PID: $pid, CPU: $cpu, MEM: $mem, COMMAND: $command"
done
echo "\n"