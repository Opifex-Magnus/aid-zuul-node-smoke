#!/bin/bash
set -euo pipefail
cd /home/zuul/smoke
bazel test --config=remote --nocache_test_results //:remote_smoke > /home/zuul/remote.log 2>&1 || { cat /home/zuul/remote.log; exit 1; }
if bazel test --config=remote --remote_instance_name=main --nocache_test_results //:remote_smoke > /home/zuul/denied.log 2>&1; then
  echo 'ERROR: PR credential was accepted for main'; exit 1
fi
grep -Ei 'permission.?denied|permission denied' /home/zuul/denied.log
cat /home/zuul/remote.log
echo 'Zuul PR identity executed remotely and was refused under main'
