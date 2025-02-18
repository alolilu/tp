total_notes=0
count_notes=0

while true; do
    read -p "Entrez une note (0-20) ou 'q' pour quitter : " input
    
    if [[ "$input" == "q" || "$input" =~ ^-?[0-9]+$ && "$input" -lt 0 ]]; then
        break
    fi

    if ! [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Veuillez entrer un nombre valide ou 'q' pour quitter."
        continue
    fi

    note=$input
    ((total_notes+=$note))
    ((count_notes++))

    if (( $(echo "$note >= 16" | bc -l) && $(echo "$note <= 20" | bc -l) )); then
        echo "Très bien"
    elif (( $(echo "$note >= 14" | bc -l) && $(echo "$note < 16" | bc -l) )); then
        echo "Bien"
    elif (( $(echo "$note >= 12" | bc -l) && $(echo "$note < 14" | bc -l) )); then
        echo "Assez bien"
    elif (( $(echo "$note >= 10" | bc -l) && $(echo "$note < 12" | bc -l) )); then
        echo "Moyen"
    else
        echo "Insuffisant"
    fi
done

if (( count_notes > 0 )); then
    average=$(echo "scale=2; $total_notes / $count_notes" | bc -l)
    echo "Vous avez saisi $count_notes notes."
    echo "La moyenne des notes est : $average"
else
    echo "Aucune note saisie."
fi