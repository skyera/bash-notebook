#!/usr/bin/env bash

set -euo pipefail

print_usage() {
    cat <<EOF
Usage: ${0##*/} [-i|--input-file FILE]

EOF
}

parse() {
    if [[ $# -eq 0 ]]; then
        print_usage
        exit 2
    fi

    INPUT_FILE=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i|--input-file)
                if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then
                    INPUT_FILE="$2"
                    shift 2
                else
                    echo "Error: --input-file requires a value" >&2
                    print_usage
                    exit 2
                fi
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                print_usage
                exit 2
                ;;
        esac
    done

    if [[ -n "$INPUT_FILE" && ! -f "$INPUT_FILE" ]]; then
        echo "Error: Input file '$INPUT_FILE' does not exist." >&2
        exit 1
    fi
}

parse "$@"

AWK_INPUT="${INPUT_FILE:-/dev/stdin}"

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
' "$AWK_INPUT"
