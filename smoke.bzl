def _test(ctx):
    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(script, """#!/bin/sh
set -eu
# The node has no Swift. Only the farm's worker can pass this test.
test -x /usr/bin/swift
echo "Zuul remote test on $(hostname)"
/usr/bin/swift --version
""", is_executable = True)
    return [DefaultInfo(executable = script)]

farm_test = rule(implementation = _test, test = True)
