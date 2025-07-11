#!/bin/bash


# mkdir $HOME/ssh_script_base
CURRENT_DIR=$(pwd)

#Scegli la porta che vuoi configurare in ascolto per il server SSH
PORT=12345

# Percorso del file di stato
STATE_FILE="$CURRENT_DIR/ssh_script_state.txt"

# Funzione per creare o aggiornare il file di stato
function update_state_file() {
    echo "First_Run=False" > "$STATE_FILE"
}

# Controlla se il file di stato esiste e contiene First_Run=True
if [ ! -f "$STATE_FILE" ] || grep -q "First_Run=True" "$STATE_FILE"; then
    echo "Prima esecuzione dello script. Eseguo operazioni di setup iniziale..."

    # Esegui qui le operazioni di setup iniziale
    # Directory contenente i file di configurazione
    cd /etc/yum.repos.d/

echo "Updating all .repo files: converting HTTP baseurls to HTTPS..."

for repo_file in *.repo; do
    if grep -q "baseurl=http://" "$repo_file"; then
        echo " - Updating $repo_file"
        sudo sed -i 's|baseurl=http://|baseurl=https://|g' "$repo_file"
    fi
done

echo "All matching repository URLs updated to HTTPS."


    sudo yum install -y openssh-server
    ssh-keygen -b 4096 -f $HOME/.ssh/ssh_host_rsa_key -t rsa -N ""
    ssh-keygen -b 4096 -f $HOME/.ssh/ssh_host_rsa_key -t ed25519 -N ""
    sudo ssh-keygen -A
    cat $HOME/.ssh/ssh_host_rsa_key.pub >> $HOME/.ssh/authorized_keys
    cat $HOME/.ssh/ssh_host_rsa_key
    cp $HOME/.ssh/ssh_host_rsa_key $CURRENT_DIR
    sudo cp /etc/environment /etc/environment2
    sudo chmod 666 /etc/environment
    env | grep OCI >> /etc/environment
    echo "Run the OpenSSH Server on Port: $PORT"
    sudo /usr/sbin/sshd -p $PORT &
    echo "Wait..."
    sleep 5
    echo "Setup iniziale completato."
    private_ip=$(python3 $CURRENT_DIR/nb_ip.py)
    echo "L'indirizzo IP privato del notebook è: $private_ip"
    echo "Per connettersi usare la chiave mostrata sopra o nel file ssh_host_rsa_key:"
    echo "ssh -i <key_name>.key datascience@$private_ip -p  $PORT"

    # Crea o aggiorna il file di stato
    update_state_file
    echo "File di stato aggiornato a First_Run=False."
else
    echo "SSH Script già eseguito in precedenza. Eseguo le operazioni di start..."


    # Esegui qui le operazioni successive
    cat $HOME/.ssh/ssh_host_rsa_key
    sudo cp /etc/environment /etc/environment2
    sudo chmod 666 /etc/environment
    env | grep OCI >> /etc/environment
    echo "Run the OpenSSH Server on Port: $PORT"
    sudo /usr/sbin/sshd -p $PORT &
    echo "Wait..."
    sleep 5
    echo "Start avvenuto con successo."

    private_ip=$(python3 $CURRENT_DIR/nb_ip.py)
    echo "L'indirizzo IP privato del notebook è: $private_ip"
    echo "Per connettersi usare la chiave mostrata sopra o nel file ssh_host_rsa_key:"
    echo "ssh -i <key_name>.key datascience@$private_ip -p  $PORT"
fi
