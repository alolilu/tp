declare -a board
difficulty=""

init_board() {
    board=( " " " " " " " " " " " " " " " " " " )
}

display_board() {
    echo "    A   B   C"
    echo "  +---+---+---+"
    for row in {0..2}; do
        printf "%d |" $((row+1))
        for col in {0..2}; do
            index=$((row*3 + col))
            printf " %s |" "${board[$index]}"
        done
        echo ""
        echo "  +---+---+---+"
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

ai_move_easy() {
    local available_moves=()
    for index in {0..8}; do
        if [[ "${board[$index]}" == " " ]]; then
            available_moves+=($index)
        fi
    done
    
    if [[ ${#available_moves[@]} -gt 0 ]]; then
        echo ${available_moves[$((RANDOM % ${#available_moves[@]}))]}
    else
        echo -1
    fi
}

ai_move_hard() {
    local player=$1
    local opponent=$2

    for index in {0..8}; do
        if [[ "${board[$index]}" == " " ]]; then
            board[$index]=$player
            if check_winner > /dev/null; then
                board[$index]=" "
                echo $index
                return
            fi
            board[$index]=" "
        fi
    done

    for index in {0..8}; do
        if [[ "${board[$index]}" == " " ]]; then
            board[$index]=$opponent
            if check_winner > /dev/null; then
                board[$index]=" "
                echo $index
                return
            fi
            board[$index]=" "
        fi
    done

    local available_moves=()
    for index in {0..8}; do
        if [[ "${board[$index]}" == " " ]]; then
            available_moves+=($index)
        fi
    done

    if [[ ${#available_moves[@]} -gt 0 ]]; then
        echo ${available_moves[$((RANDOM % ${#available_moves[@]}))]}
    else
        echo -1
    fi
}

# Choix du niveau de difficulté
echo "Choisissez le niveau de difficulté de l'IA (facile/difficile) :"
read -r difficulty
clear

while true; do
    init_board
    clear
    display_board
    current_player="X"
    
    while true; do
        if [[ "$current_player" == "X" ]]; then
            echo -n "Joueur $current_player, entrez votre coup (ex: B2) : "
            read -r move
            
            index=$(parse_move "$move")
            while [[ $index -eq -1 || "${board[$index]}" != " " ]]; do
                echo -n "Mouvement invalide, réessayez : "
                read -r move
                index=$(parse_move "$move")
            done
        else
            echo "L'IA réfléchit..."
            sleep 1
            if [[ "$difficulty" == "facile" ]]; then
                index=$(ai_move_easy)
            else
                index=$(ai_move_hard "O" "X")
            fi
        fi
        
        board[$index]=$current_player
        clear
        display_board
        
        if check_winner > /dev/null; then
            if [[ "$current_player" == "X" ]]; then
                echo "Le joueur $current_player a gagné !"
            else
                echo "L'IA a gagné !"
            fi
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
