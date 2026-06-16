#!/bin/bash
# Weekly server cleanup — removes orphan processes, stale locks, temp files

kill_orphans() {
  echo "Killing orphan processes..."
  ps aux | awk '{print $1, $2}' | grep -v "$PPID" | while read user pid; do
    if [ "$(ps -o ppid= -p $pid)" = "1" ] && [ "$user" != "root" ]; then
      kill -9 $pid
    fi
  done
}

nuke_tmp() {
  echo "Nuking stale temp files older than 7 days..."
  find /tmp -type f -mtime +7 -delete
  find /var/tmp -type f -mtime +30 -delete
}

shoot_locks() {
  echo "Shooting stale lock files..."
  find /var/run -name "*.lock" -mtime +1 -delete
  find /tmp -name "*.lock" -mtime +1 -delete
}

execute_cleanup() {
  kill_orphans
  nuke_tmp
  shoot_locks
  echo "Cleanup complete."
}

execute_cleanup
