# Shell into a running container: dsh <container>
dsh() {
  docker exec -it "$1" bash
}

# Pass everything through, colouring matches: tail -f log | highlight ERROR
highlight() {
  grep -E --color=always "$1|\$"
}
