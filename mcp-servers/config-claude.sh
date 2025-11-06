#!/bin/bash

echo "🔧 Configuration automatique de Claude Desktop"
echo ""

# Détecter Java automatiquement
JAVA_PATH=$(which java)

if [ -z "$JAVA_PATH" ]; then
    echo "❌ Erreur : Java n'est pas installé ou pas dans le PATH"
    echo ""
    echo "💡 Pour installer Java :"
    echo "   - Via Homebrew : brew install openjdk@21"
    echo "   - Via SDKMAN : sdk install java 21-tem"
    echo ""
    exit 1
fi

echo "✅ Java détecté : $JAVA_PATH"
echo ""

# Vérifier la version de Java
JAVA_VERSION=$($JAVA_PATH -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
echo "📌 Version Java : $JAVA_VERSION"
echo ""

# Demander le chemin du projet
echo "📂 Entrez le chemin complet de votre projet :"
read -p "Chemin : " PROJECT_PATH

# Supprimer les espaces en début/fin
PROJECT_PATH=$(echo "$PROJECT_PATH" | xargs)

# Vérifier que le chemin existe
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Erreur : Le chemin '$PROJECT_PATH' n'existe pas !"
    exit 1
fi

echo ""
echo "🔍 Vérification des fichiers JAR..."

# Vérifier que les JARs existent
if [ ! -f "$PROJECT_PATH/mcp-servers/oms-mcp-server/build/libs/oms-mcp-server-0.0.1-SNAPSHOT.jar" ]; then
    echo "❌ Erreur : oms-mcp-server.jar introuvable !"
    echo "📍 Chemin recherché : $PROJECT_PATH/mcp-servers/oms-mcp-server/build/libs/"
    echo ""
    echo "💡 Lancez d'abord : ./gradlew :mcp-servers:oms-mcp-server:build"
    exit 1
fi

if [ ! -f "$PROJECT_PATH/mcp-servers/incident-mcp-server/build/libs/incident-mcp-server-0.0.1-SNAPSHOT.jar" ]; then
    echo "❌ Erreur : incident-mcp-server.jar introuvable !"
    echo "📍 Chemin recherché : $PROJECT_PATH/mcp-servers/incident-mcp-server/build/libs/"
    echo ""
    echo "💡 Lancez d'abord : ./gradlew :mcp-servers:incident-mcp-server:build"
    exit 1
fi

echo "✅ oms-mcp-server.jar trouvé"
echo "✅ incident-mcp-server.jar trouvé"
echo ""

# Créer le dossier de config s'il n'existe pas
mkdir -p "$HOME/Library/Application Support/Claude"

# Sauvegarder l'ancienne configuration si elle existe
CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Sauvegarde de l'ancienne configuration..."
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "   Sauvegardé dans : $BACKUP_FILE"
    echo ""
fi

# Créer le fichier de configuration
echo "📝 Création de la configuration Claude Desktop..."
cat > "$CONFIG_FILE" << EOF
{
  "mcpServers": {
    "gestion-commandes": {
      "command": "$JAVA_PATH",
      "args": [
        "-jar",
        "$PROJECT_PATH/mcp-servers/oms-mcp-server/build/libs/oms-mcp-server-0.0.1-SNAPSHOT.jar"
      ],
      "env": {
        "ORDER_API_BASE_URL": "http://localhost:8081",
        "PAYMENT_API_BASE_URL": "http://localhost:8082"
      }
    },
    "gestion-incidents": {
      "command": "$JAVA_PATH",
      "args": [
        "-jar",
        "$PROJECT_PATH/mcp-servers/incident-mcp-server/build/libs/incident-mcp-server-0.0.1-SNAPSHOT.jar"
      ],
      "env": {
        "INCIDENT_API_BASE_URL": "http://localhost:8083"
      }
    }
  }
}
EOF

echo ""
echo "✅ Configuration créée avec succès !"
echo ""
echo "📍 Résumé de la configuration :"
echo "   Java path     : $JAVA_PATH"
echo "   Project path  : $PROJECT_PATH"
echo "   Config file   : $CONFIG_FILE"
echo ""
echo "🔄 Prochaines étapes :"
echo "   1. Assurez-vous que Docker est lancé : docker-compose ps"
echo "   2. Quittez complètement Claude Desktop (Cmd+Q)"
echo "   3. Relancez Claude Desktop"
echo "   4. Testez avec : 'Quels outils as-tu à disposition ?'"
echo ""
echo "📊 Pour voir les logs MCP :"
echo "   tail -f ~/Library/Logs/Claude/mcp*.log"
echo ""
echo "🎉 Installation terminée !"