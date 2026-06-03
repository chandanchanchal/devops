mkdir -p ~/scratch_demo && cd ~/scratch_demo

cat > main.go << 'EOF'
package main
import (
    "fmt"
    "net/http"
)
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello from a scratch image!")
}
func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
EOF
