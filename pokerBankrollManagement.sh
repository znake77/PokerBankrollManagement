# Initialize bankroll to 0
bankroll=0
session_file="default_session"
history_file="history.log"

# Function to load session
function load_session() {
    if [ -f "$session_file" ]; then
        bankroll=$(cat "$session_file")
    fi
}

# Function to save session
function save_session() {
    echo "$bankroll" > "$session_file"
}

# Function to log transactions
function log_transaction() {
    echo "$(date): $1" >> "$history_file"
}

# Adding a new feature to validate if the winnings or losses entered are not negative numbers.
# Function to add winnings to bankroll
function add_winnings() {
    read -p "Enter winnings: " winnings
    if [[ $winnings =~ ^[0-9]+$ ]]; then
        bankroll=$((bankroll + winnings))
        log_transaction "Added $winnings to bankroll. New total: $bankroll"
        save_session
    else
        echo "Invalid input. Please enter a positive number."
    fi
}

# Function to subtract losses from bankroll
function subtract_losses() {
    read -p "Enter losses: " losses
    if [[ $losses =~ ^[0-9]+$ ]]; then
        if (( losses > bankroll )); then
            echo "Insufficient funds. Your current bankroll is $bankroll."
        else
            bankroll=$((bankroll - losses))
            log_transaction "Subtracted $losses from bankroll. New total: $bankroll"
            save_session
        fi
    else
        echo "Invalid input. Please enter a positive number."
    fi
}

# Function to display bankroll
function display_bankroll() {
    echo "Your current bankroll is: $bankroll"
}

# Function to display transaction history
function display_history() {
    if [ -f "$history_file" ]; then
        cat "$history_file"
    else
        echo "No transaction history found."
    fi
}

# Adding a new feature to validate if the session name entered contains only alphanumeric characters and is not empty.
# Function to set session name
function set_session_name() {
    read -p "Enter session name (leave blank for default): " name
    if [[ -z "$name" ]]; then
        echo "Session name cannot be empty. Please enter a valid name."
    elif [[ $name =~ ^[a-zA-Z0-9]+$ ]]; then
        session_file="$name"
        load_session
    else
        echo "Invalid input. Session name can only contain alphanumeric characters."
    fi
}

# Adding a new feature to validate if the backup name entered contains only alphanumeric characters and is not empty.
# Function to backup session
function backup_session() {
    read -p "Enter backup name (leave blank for default): " backup_name
    if [[ -z "$backup_name" ]]; then
        echo "Backup name cannot be empty. Please enter a valid name."
    elif [[ $backup_name =~ ^[a-zA-Z0-9]+$ ]]; then
        backup_file="${backup_name}_backup"
        cp "$session_file" "$backup_file"
        echo "Session has been backed up to $backup_file."
    else
        echo "Invalid input. Backup name can only contain alphanumeric characters."
    fi
}
# Function to restore session from backup
function restore_session() {
    backup_file="${session_file}_backup"
    if [ -f "$backup_file" ]; then
        cp "$backup_file" "$session_file"
        echo "Session has been restored from $backup_file."
        load_session
    else
        echo "No backup found for this session."
    fi
}

# Adding a new feature to validate if the bankroll is not exceeding a certain limit.
# Function to set bankroll
function set_bankroll() {
    read -p "Enter bankroll: " new_bankroll
    if [[ $new_bankroll =~ ^[0-9]+$ ]]; then
        if (( new_bankroll > 1000000 )); then
            echo "Bankroll cannot exceed 1,000,000."
        else
            bankroll=$new_bankroll
            log_transaction "Bankroll set to $bankroll"
            save_session
        fi
    else
        echo "Invalid input. Please enter a positive number."
    fi
}

# Adding a new feature to allow the user to reset the bankroll to 0.
# Function to reset bankroll
function reset_bankroll() {
    bankroll=0
    log_transaction "Bankroll reset to 0"
    save_session
}

# Adding a new feature to allow the user to delete a session.
# Function to delete session
function delete_session() {
    read -p "Are you sure you want to delete this session? (y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        rm "$session_file"
        echo "Session has been deleted."
    else
        echo "Session deletion cancelled."
    fi
}

# Adding a new feature to allow the user to clear transaction history.
# Function to clear transaction history
function clear_history() {
    read -p "Are you sure you want to clear transaction history? (y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        > "$history_file"
        echo "Transaction history has been cleared."
    else
        echo "Transaction history clearing cancelled."
    fi
}

# main loop
while true; do
    echo "What would you like to do?"
    echo "1. Add winnings"
    echo "2. Subtract losses"
    echo "3. Display bankroll"
    echo "4. Set bankroll"
    echo "5. Reset bankroll"
    echo "6. Set session name"
    echo "7. Display transaction history"
    echo "8. Clear transaction history"
    echo "9. Backup session"
    echo "10. Restore session from backup"
    echo "11. Delete session"
    echo "12. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            add_winnings
            ;;
        2)
            subtract_losses
            ;;
        3)
            display_bankroll
            ;;
        4)
            set_bankroll
            ;;
        5)
            reset_bankroll
            ;;
        6)
            set_session_name
            ;;
        7)
            display_history
            ;;
        8)
            clear_history
            ;;
        9)
            backup_session
            ;;
        10)
            restore_session
            ;;
        11)
            delete_session
            ;;
        12)
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 12."
            ;;
    esac
done