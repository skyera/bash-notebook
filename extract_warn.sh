#!/usr/bin/env bash

awk '
/warning:|note:/ {
    # Match: file:line:col: warning|note: message
    if (match($0, /^([^:]+):([0-9]+):([0-9]+): (warning|note): (.*)$/, m)) {
        file = m[1]
        line = m[2]
        col  = m[3]
        type = m[4]
        msg  = m[5]

        warnings[file] = warnings[file] sprintf("  %s:%s  [%s] %s\n", line, col, type, msg)
        files[file] = 1
    }
}

END {
    for (f in files) {
        print "== " f " =="
        printf "%s\n", warnings[f]
    }
}
' 

