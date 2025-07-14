#!/bin/bash

# Zugangsdaten zum MySQL-Server (Root-Zugang)
MYSQL_ROOT_USER="root"
MYSQL_ROOT_PASSWORD="dein_root_passwort"

# Anzahl der Datenbanken / Benutzer
ANZAHL=17

# Zwei Arrays für Vornamen und Nachnamen für Randomisierung
VORNAMEN=("Anna" "Ben" "Clara" "David" "Eva" "Felix" "Greta" "Hans" "Ida" "Jonas")
NACHNAMEN=("Müller" "Schmidt" "Schneider" "Fischer" "Weber" "Meyer" "Wagner" "Becker" "Hoffmann" "Koch")
KLASSEN=("5A" "6B" "7C" "8D" "9E")

# SQL-Befehle pro DB/Benutzer generieren und ausführen
for i in $(seq 1 $ANZAHL); do
    DBNAME="myDB$i"
    USERNAME=$(printf "schueler%02d" $i)
    PASSWORD="Passwort$i"

    echo "🔧 Erstelle: $DBNAME mit Benutzer $USERNAME"

    # Zufällige Daten generieren
    for j in 1 2; do
        VORNAME=${VORNAMEN[$RANDOM % ${#VORNAMEN[@]}]}
        NACHNAME=${NACHNAMEN[$RANDOM % ${#NACHNAMEN[@]}]}
        GEBURTSTAG="$((RANDOM%28+1)).$((RANDOM%12+1)).200$((RANDOM%10))"
        KLASSE=${KLASSEN[$RANDOM % ${#KLASSEN[@]}]}

        # Speichere die INSERT-Befehle in Variable
        INSERTS+="INSERT INTO \`$DBNAME\`.\`personen\` (vorname, nachname, geburtstag, klasse) VALUES ('$VORNAME', '$NACHNAME', '$GEBURTSTAG', '$KLASSE');"$'\n'
    done

    SQL=$(cat <<EOF
CREATE DATABASE IF NOT EXISTS \`$DBNAME\`;

CREATE TABLE IF NOT EXISTS \`$DBNAME\`.\`personen\` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vorname VARCHAR(100),
    nachname VARCHAR(100),
    geburtstag VARCHAR(10),
    klasse VARCHAR(10)
);

CREATE USER IF NOT EXISTS '$USERNAME'@'%' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON \`$DBNAME\`.* TO '$USERNAME'@'%';
FLUSH PRIVILEGES;

$INSERTS
EOF
    )

    # SQL ausführen
    echo "$SQL" | mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD"

    # INSERTS zurücksetzen für nächsten Benutzer
    INSERTS=""
done

echo "✅ Alle Datenbanken, Benutzer und Tabellen wurden erfolgreich eingerichtet."
