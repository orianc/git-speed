#!/bin/bash

# Couleurs pour les messages
GREEN='\033[0;32m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Vérifier si le répertoire bin existe
if [ ! -d "bin" ]; then
    mkdir bin
fi

# Rendre le script exécutable
chmod +x bin/gitc

# Créer le lien symbolique
INSTALL_DIR="/usr/local"
BIN_DIR="$INSTALL_DIR/bin"
MAN_DIR="$INSTALL_DIR/share/man/man1"

# Créer les répertoires si nécessaires
sudo mkdir -p "$BIN_DIR" "$MAN_DIR"

# Installer le binaire
sudo cp bin/gitc "$BIN_DIR/"
sudo cp share/man/man1/gitc.1 "$MAN_DIR/"

info "Installation terminée ! Vous pouvez maintenant utiliser 'gitc' dans n'importe quel dépôt Git."