# bash-notebook
Bash script

Tips
* Quote everything
* Use functions to organize logic
* Validate everything
* Use trap for cleanup
* read -r: prevtn backslash escapes
* shellcheck
* shfmt
* jq - JSON parsing
* Use Parameter expansion instead of external tools:w
* Fail fast, fail loud
* Use local variables inside functions
* Safe temporary files
```
tmp=$(mktemp)
cleanup() {
    rm -f "$tmp"
}
trap cleanup EXIT
```
* Ctrl + K - Cut everything after cursor
* Ctrl + W - Cut word before cursor
* Alt + B/Alt + F - Move word backward/forward one word
