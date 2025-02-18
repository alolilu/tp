read -p "Entrez un nombre : " n

if ! [[ "$n" =~ ^[0-9]+$ ]]; then
    echo "Veuillez entrer un nombre entier positif."
    exit 1
fi

result=1

for ((i=1; i<=n; i++)); do
    result=$((result * n))
done

echo "$n élevé à la puissance $n est : $result"
