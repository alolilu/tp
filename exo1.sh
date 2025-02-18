read -p "Entrez une note (0-20) : " note

if ! [[ "$note" =~ ^[0-9]+$ || "$note" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Veuillez entrer un nombre valide."
    exit 1
fi

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

