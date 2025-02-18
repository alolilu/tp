declare -a board

init_board() {
    board=( " " " " " " " " " " " " " " " " )
}

display_board() {
    echo "    A   B   C"
    echo "  +---+---+---+"
    for row in {0..2}; do
        echo -n "$((row+1)) |"
        for col in {0..2}; do
            index=$((row*3 + col))
            echo -n " ${board[$index]} |"
        done
        echo -e "\n  +---+---+---+"
    done
}

check_winner() {
    local lines=(
        "0 1 2" "3 4 5" "6 7 8" 
        "0 3 6" "1 4 7" "2 5 8"
        "0 4 8" "2 4 6"
    )
    
    for line in "${lines[@]}"; do
        read -r p1 p2 p3 <<< "$line"
        if [[ "${board[$p1]}" != " " && "${board[$p1]}" == "${board[$p2]}" && "${board[$p2]}" == "${board[$p3]}" ]]; then
            echo "${board[$p1]}"
            return 0
        fi
    done
    return 1
}

is_full() {
    for index in {0..8}; do
        if [[ "${board[$index]}" == " " ]]; then
            return 1
        fi
    done
    return 0
}

parse_move() {
    local move=$1
    local col_char=${move:0:1}
    local row_char=${move:1:1}
    
    col_char=$(echo "$col_char" | tr '[:lower:]' '[:upper:]')
    case $col_char in
        A) col=0 ;;
        B) col=1 ;;
        C) col=2 ;;
        *) col=-1 ;;
    esac
    
    if [[ $row_char =~ ^[1-3]$ ]]; then
        row=$((row_char - 1))
    else
        row=-1
    fi
    
    if [[ $col -ge 0 && $col -le 2 && $row -ge 0 && $row -le 2 ]]; then
        echo $((row*3 + col))
    else
        echo -1
    fi
}

ai_move() {
    local available_moves=()
    for i in {0..8}; do
        if [[ "${board[$i]}" == " " ]]; then
            available_moves+=("$i")
        fi
    done
    
    local random_index=$((RANDOM % ${#available_moves[@]}))
    echo "${available_moves[$random_index]}"
}

while true; do
    init_board
    clear
    display_board
    current_player="X"
    
    while true; do
        if [[ "$current_player" == "X" ]]; then
            echo -n "Joueur X, entrez votre coup (ex: B2) : "
            read -r move
            index=$(parse_move "$move")
            while [[ $index -eq -1 || "${board[$index]}" != " " ]]; do
                echo -n "Mouvement invalide, réessayez : "
                read -r move
                index=$(parse_move "$move")
            done
        else
            echo "IA (O) joue..."
            sleep 1
            index=$(ai_move)
        fi
        
        board[$index]=$current_player
        clear
        display_board
        
        if check_winner > /dev/null; then
            echo "Le joueur $current_player a gagné !"
            break
        elif is_full; then
            echo "Match nul !"
            break
        fi
        
        current_player=$([ "$current_player" = "X" ] && echo "O" || echo "X")
    done
    
    echo "Voulez-vous rejouer ? (o/n)"
    read -r replay
    [[ "$replay" != "o" ]] && break

done
exit 0
