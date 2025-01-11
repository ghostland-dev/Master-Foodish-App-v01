#!/bin/bash

# Configuration
START_DATE="2024-01-01"
END_DATE=$(date +"%Y-%m-%d")
MIN_COMMITS_PER_DAY=5
MAX_COMMITS_PER_DAY=14
REMOTE_URL="https://github.com/Ismail-Mouyahada/Master-Quiz-Satoshi-Square-App-v01.git"
BRANCH="main"
COMMIT_MESSAGES=("fix bug" "ajout de validations" "modification du style" "mise à jour de la documentation" "réorganisation du code" "optimisation des performances" "correction d'une faute de frappe" "ajout de tests" "implémentation d'une nouvelle fonctionnalité")

# Vérifiez si le script est dans un dépôt Git
if [ ! -d ".git" ]; then
    echo "Erreur : ce script doit être exécuté dans un dépôt Git."
    exit 1
fi

# Configure le dépôt distant
git remote add origin "$REMOTE_URL" 2>/dev/null || echo "Remote 'origin' déjà configuré."

# Fonction pour générer une heure aléatoire
generate_random_time() {
    echo "$(printf "%02d" $((RANDOM % 24))):$(printf "%02d" $((RANDOM % 60))):$(printf "%02d" $((RANDOM % 60)))"
}

# Fonction pour générer un nombre aléatoire de commits par jour
generate_random_commits_per_day() {
    echo $((RANDOM % (MAX_COMMITS_PER_DAY - MIN_COMMITS_PER_DAY + 1) + MIN_COMMITS_PER_DAY))
}

# Fonction pour sélectionner un message de commit aléatoire
get_random_commit_message() {
    echo "${COMMIT_MESSAGES[$RANDOM % ${#COMMIT_MESSAGES[@]}]}"
}

# Boucle sur chaque jour entre START_DATE et END_DATE
current_date="$START_DATE"
while [[ "$current_date" < "$END_DATE" ]]; do
    # Générer un nombre aléatoire de commits pour cette journée
    num_commits=$(generate_random_commits_per_day)
    echo "Date : $current_date, Nombre de commits : $num_commits"

    for ((i=1; i<=num_commits; i++)); do
        random_time=$(generate_random_time)
        commit_datetime="$current_date $random_time"
        commit_message=$(get_random_commit_message)

        # Effectuer le commit vide avec un message aléatoire
        GIT_AUTHOR_DATE="$commit_datetime" GIT_COMMITTER_DATE="$commit_datetime" \
            git commit --allow-empty -m "$commit_message - $current_date #$i" --date="$commit_datetime"
        echo "  -> Commit vide #$i à $commit_datetime avec le message : $commit_message"

        # Pousser le commit immédiatement
        git push origin "$BRANCH"
    done

    # Passer au jour suivant
    current_date=$(date -I -d "$current_date + 1 day")
done

echo "Tous les commits vides ont été poussés avec succès vers $REMOTE_URL !"

