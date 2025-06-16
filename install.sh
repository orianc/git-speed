#!/bin/bash

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages d'information
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Fonction pour afficher les avertissements
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Vérifier si gum est installé
if ! command -v gum &> /dev/null; then
    warning "gum n'est pas installé. Installation en cours..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install gum
    elif [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install gum
    else
        echo "Système non supporté. Veuillez installer gum manuellement: https://github.com/charmbracelet/gum"
        exit 1
    fi
fi

# Rendre le script commit.sh exécutable
chmod +x "$(dirname "$0")/commit.sh"

# Déterminer le shell de l'utilisateur
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""

# Trouver le bon fichier de configuration
case $SHELL_NAME in
    bash)
        if [ -f "$HOME/.bashrc" ]; then
            CONFIG_FILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            CONFIG_FILE="$HOME/.bash_profile"
        fi
        ;;
    zsh)
        if [ -f "$HOME/.zshrc" ]; then
            CONFIG_FILE="$HOME/.zshrc"
        fi
        ;;
    fish)
        CONFIG_FILE="$HOME/.config/fish/config.fish"
        mkdir -p "$(dirname "$CONFIG_FILE")"
        touch "$CONFIG_FILE"
        ;;
    *)
        warning "Shell non reconnu. Veuillez ajouter manuellement l'alias dans votre fichier de configuration."
        exit 1
        ;;
esac

if [ -z "$CONFIG_FILE" ]; then
    warning "Impossible de trouver le fichier de configuration du shell."
    exit 1
fi

# Chemin absolu vers le script commit.sh
COMMIT_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/commit.sh"

# Vérifier si l'alias existe déjà
if grep -q "alias gitc=" "$CONFIG_FILE"; then
    info "L'alias 'gitc' existe déjà dans $CONFIG_FILE"
else
    # Ajouter l'alias
    echo -e "\n# Alias pour gitc" >> "$CONFIG_FILE"
    echo "alias gitc='$COMMIT_SCRIPT'" >> "$CONFIG_FILE"
    info "Alias 'gitc' ajouté à $CONFIG_FILE"
fi

# Sourcer le fichier de configuration pour appliquer les changements immédiatement
if [ "$SHELL_NAME" = "fish" ]; then
    source "$CONFIG_FILE"
else
    source "$CONFIG_FILE" 2> /dev/null || true
fi

info "Installation terminée ! Vous pouvez maintenant utiliser 'gitc' pour créer des commits conventionnels."
info "Si la commande n'est pas disponible, redémarrez votre terminal ou exécutez 'source $CONFIG_FILE'"

# Vérifier si le dépôt git est configuré
if [ ! -d ".git" ]; then
    warning "Ce répertoire n'est pas un dépôt Git. L'alias 'gitc' ne fonctionnera que dans des dépôts Git."
fi