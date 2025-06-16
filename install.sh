#!/bin/bash

# --- CONFIG ---
ALIASES_FILE="aliases.json"
OUTPUT_CONFIG="preview.gitconfig"
REAL_INSTALL=true

# --- PARAM HANDLING ---
if [[ "$1" == "--output" ]]; then
  REAL_INSTALL=false
  echo "🔧 Mode développement : les alias seront écrits dans $OUTPUT_CONFIG"
fi

# --- DETECT GUM ---
if command -v gum &> /dev/null; then
  echo "✅ gum détecté. Interface interactive activée."
  USE_GUM=true
else
  echo "⚠️ gum non installé. Passage en mode texte simple.\n"
  echo "gum n'est pas installé. Voulez-vous l'installer ? [y/N]"
  read -r install_gum
  if [[ "$install_gum" == "y" || "$install_gum" == "Y" ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      curl -s https://gum.cool/install.sh | bash
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      brew install gum
    else
      echo "Installation automatique non supportée. Installez gum manuellement."
    fi
    if command -v gum &> /dev/null; then
      echo "✅ gum installé. Interface interactive activée."
      USE_GUM=true
    else
      echo "❌ gum non installé. Passage en mode texte simple."
      USE_GUM=false
    fi
  fi
fi

# --- LIRE ALIAS JSON ---
if [ ! -f "$ALIASES_FILE" ]; then
  echo "❌ Fichier $ALIASES_FILE introuvable."
  exit 1
fi

ALIASES_LIST=$(jq -r '.[] | "\(.name): \(.description)"' "$ALIASES_FILE")

# --- SÉLECTION D'ALIAS ---
if [ "$USE_GUM" = true ]; then
  echo "🔍 Choisissez les alias à ajouter (Espace pour sélectionner, Entrée pour valider) :"
  CHOICES=$(echo "$ALIASES_LIST" | gum choose --no-limit)
else
  echo "🔍 Liste des alias disponibles :"
  echo "$ALIASES_LIST"
  echo ""
  echo "📝 Saisissez les noms d'alias à activer (séparés par des espaces, ex: s aa ll):"
  read -r selected_aliases
  CHOICES=""
  for name in $selected_aliases; do
    match=$(echo "$ALIASES_LIST" | grep "^$name:")
    if [ -n "$match" ]; then
      CHOICES+="$match"$'\n'
    fi
  done
fi

if [ -z "$CHOICES" ]; then
  echo "❌ Aucun alias sélectionné, abandon."
  exit 0
fi

# --- PRÉPARER SORTIE ---
if [ "$REAL_INSTALL" = false ]; then
  echo "[alias]" > "$OUTPUT_CONFIG"
fi

# --- AJOUT DES ALIAS ---
while IFS= read -r choice; do
  alias_name=$(echo "$choice" | cut -d':' -f1 | xargs)
  alias_cmd=$(jq -r --arg name "$alias_name" '.[] | select(.name == $name) | .command' "$ALIASES_FILE")

  if [ "$USE_GUM" = true ]; then
    custom_cmd=$(gum input --prompt "✏️  [$alias_name] Modifier la commande (ou Entrée pour garder) : " --value "$alias_cmd")
    final_cmd=${custom_cmd:-$alias_cmd}
  else
    final_cmd=$alias_cmd
  fi

  if [ "$REAL_INSTALL" = true ]; then
    git config --global alias."$alias_name" "$final_cmd"
    echo "✅ Ajouté : $alias_name = $final_cmd"
  else
    echo "    $alias_name = $final_cmd" >> "$OUTPUT_CONFIG"
    echo "✏️  Simulé : $alias_name = $final_cmd"
  fi
done <<< "$CHOICES"