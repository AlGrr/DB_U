#!/bin/bash

# Zugangsdaten zum MySQL-Server
MYSQL_ROOT_USER="root"
MYSQL_ROOT_PASSWORD=""

# Anzahl der Benutzer/Datenbanken
ANZAHL=17

# Vordefinierte Passwörter
declare -A USER_PASSWORDS=(
  [schueler01]="Sepw557!"
  [schueler02]="Sepw965!"
  [schueler03]="Sepw741!"
  [schueler04]="Sepw645!"
  [schueler05]="Sepw056!"
  [schueler06]="Sepw086!"
  [schueler07]="Sepw107!"
  [schueler08]="Sepw084!"
  [schueler09]="Sepw091!"
  [schueler10]="Sepw150!"
  [schueler11]="Sepw131!"
  [schueler12]="Sepw112!"
  [schueler13]="Sepw143!"
  [schueler14]="Sepw134!"
  [schueler15]="Sepw175!"
  [schueler16]="Sepw136!"
  [schueler17]="Sepw147!"
)

# Vornamen, Nachnamen und Klassen für Zufallsdaten
VORNAMEN=("Anna" "Ben" "Clara" "David" "Eva" "Felix" "Greta" "Hans" "Ida" "Jonas")
NACHNAMEN=("Müller" "Schmidt" "Schneider" "Fischer" "Weber" "Meyer" "Wagner" "Becker" "Hoffmann" "Koch")
KLASSEN=("5A" "6B" "7C" "8D" "9E")

# Tabelle zur Ausgabe am Ende vorbereiten
printf "\n%-12s | %-15s\n" "Benutzer" "Passwort"
printf "%s\n" "-----------------------------"

for i in $(seq 1 $ANZAHL); do
    DBNAME="myDB$i"
    USERNAME=$(printf "schueler%02d" $i)
    PASSWORD="${USER_PASSWORDS[$USERNAME]}"

    echo "🔧 Erstelle Datenbank und Benutzer: $DBNAME / $USERNAME"

    # Zwei zufällige Datensätze vorbereiten
    for j in 1 2; do
        VORNAME=${VORNAMEN[$RANDOM % ${#VORNAMEN[@]}]}
        NACHNAME=${NACHNAMEN[$RANDOM % ${#NACHNAMEN[@]}]}
        GEBURTSTAG="$((RANDOM%28+1)).$((RANDOM%12+1)).200$((RANDOM%10))"
        KLASSE=${KLASSEN[$RANDOM % ${#KLASSEN[@]}]}

        INSERTS+="INSERT INTO \`$DBNAME\`.\`personen\` (vorname, nachname, geburtstag, klasse) VALUES ('$VORNAME', '$NACHNAME', '$GEBURTSTAG', '$KLASSE');"$'\n'
    done

    # SQL-Befehl für Datenbank, Tabelle, Benutzer, Rechte und Inserts
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

    # INSERTS-Block zurücksetzen
    INSERTS=""

    # Zeile für Tabelle drucken
    printf "%-12s | %-15s\n" "$USERNAME" "$PASSWORD"
done

echo -e "\n✅ Alle Datenbanken, Benutzer, Tabellen und Beispieldaten wurden erfolgreich erstellt."
