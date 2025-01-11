#!/bin/bash
REMOTE_URL="https://github.com/Ismail-Mouyahada/Master-Quiz-Satoshi-Square-App-v01.git"

# Vérifier si on est dans un repo git
if [ ! -d .git ]; then
    echo "Initialisation du dépôt Git..."
    git init
fi

# Générer un nombre aléatoire de commits entre 1 et 6
nb_commits=$((RANDOM % 6 + 1))

# Dates de début et fin
start_date="2024-01-01T00:00:00"
end_date="2025-01-11T23:59:59"

# Convertir les dates en timestamps
start_ts=$(date -d "$start_date" +%s)
end_ts=$(date -d "$end_date" +%s)

# Fonction pour générer une date aléatoire
random_date() {
    local random_ts=$((RANDOM % (end_ts - start_ts) + start_ts))
    date -d "@$random_ts" "+%Y-%m-%d %H:%M:%S"
}

# Messages de commit organisés par type
declare -A commit_messages=(
    # Messages pour de nouvelles fonctionnalités
    ["feat"]="
        feat: ajouter la fonctionnalité de login
        feat: implémenter la recherche avancée
        feat: ajouter le support multilangue
        feat: intégrer le système de notifications
        feat: ajouter le tableau de bord utilisateur"

    # Messages pour les corrections de bugs
    ["fix"]="
        fix: corriger le problème d'authentification
        fix: résoudre le bug d'affichage sur mobile
        fix: corriger la pagination des résultats
        fix: résoudre le problème de cache
        fix: corriger les erreurs de validation"

    # Messages pour la documentation
    ["docs"]="
        docs: mettre à jour la documentation API
        docs: ajouter les exemples d'utilisation
        docs: documenter les nouveaux endpoints
        docs: améliorer le guide d'installation
        docs: mettre à jour le changelog"

    # Messages pour les changements de configuration
    ["config"]="
        config: mettre à jour les dépendances
        config: optimiser la configuration Docker
        config: ajuster les paramètres de cache
        config: configurer l'intégration continue
        config: mettre à jour les variables d'environnement"

    # Messages pour le refactoring
    ["refactor"]="
        refactor: optimiser les requêtes de base de données
        refactor: améliorer la structure du code
        refactor: simplifier la logique métier
        refactor: réorganiser les composants
        refactor: optimiser les performances"

    # Messages pour les tests
    ["test"]="
        test: ajouter les tests unitaires
        test: implémenter les tests d'intégration
        test: ajouter les tests de performance
        test: améliorer la couverture des tests
        test: mettre à jour les scénarios de test"
)

# Types de commits disponibles
commit_types=("feat" "fix" "docs" "config" "refactor" "test")

echo "Génération de $nb_commits commits vides..."

# Choisir un type de commit principal pour la cohérence
main_type=${commit_types[$RANDOM % ${#commit_types[@]}]}

for ((i=1; i<=$nb_commits; i++)); do
    # Sélectionner le type (80% de chance d'utiliser le type principal)
    if [ $((RANDOM % 100)) -lt 80 ]; then
        type=$main_type
    else
        type=${commit_types[$RANDOM % ${#commit_types[@]}]}
    fi
    
    # Convertir la chaîne de messages en tableau et sélectionner un message aléatoire
    IFS=$'\n' read -r -d '' -a messages <<< "${commit_messages[$type]}"
    message="${messages[$RANDOM % ${#messages[@]}]}"
    
    # Générer une date aléatoire
    commit_date=$(random_date)
    
    # Créer un commit vide avec la date spécifiée
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
    git commit --allow-empty -m "$(echo -e "$message" | xargs)"
    
    echo "Commit $i/$nb_commits créé à la date: $commit_date"
done

echo "Terminé ! $nb_commits commits vides ont été créés."
echo "Utilisez 'git log' pour voir l'historique des commits."
