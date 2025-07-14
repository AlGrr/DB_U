#!/bin/bash

# === KONFIGURATION ===
DB_ROOT_USER="root"
DB_ROOT_PASS="DEIN_ROOT_PASSWORT"

# Datenbanken, Benutzer und Passwörter definieren
declare -A databases=(
  ["projekt1"]="user1:passwort1"
  ["projekt2"]="user2:passwort2"
  ["projekt3"]="user3:passwort3"
)

# === FUNKTION ===
create_db_and_user() {
  local dbname=$1
  local userpass=$2
  local user=${userpass%%:*}
  local pass=${userpass##*:}

  echo "Erstelle Datenbank '$dbname' mit Benutzer '$user'..."

  mysql -u "$DB_ROOT_USER" -p"$DB_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS \`$dbname\`;
CREATE USER IF NOT EXISTS '$user'@'localhost' IDENTIFIED BY '$pass';
GRANT ALL PRIVILEGES ON \`$dbname\`.* TO '$user'@'localhost';
FLUSH PRIVILEGES;
EOF
}

# === AUSFÜHRUNG ===
for db in "${!databases[@]}"; do
  create_db_and_user "$db" "${databases[$db]}"
done

echo "✅ Alle Datenbanken und Benutzer wurden erstellt."
