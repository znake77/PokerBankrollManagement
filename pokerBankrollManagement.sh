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

# Adding a new feature to allow the user to view the current session name.
# Function to view session name
function view_session_name() {
    echo "Current session name is: $session_file"
}

# Adding a new feature to allow the user to view the current backup name.
# Function to view backup name
function view_backup_name() {
    backup_file="${session_file}_backup"
    if [ -f "$backup_file" ]; then
        echo "Current backup name is: $backup_file"
    else
        echo "No backup found for this session."
    fi
}

# Adding a new feature to allow the user to import transaction history from a file.
# Function to import transaction history
function import_history() {
    read -p "Enter the name of the file to import: " import_file
    if [[ -f "$import_file" ]]; then
        cat "$import_file" >> "$history_file"
        echo "Transaction history has been imported from $import_file."
    else
        echo "File not found. Please enter a valid file name."
    fi
}

# Adding a new feature to allow the user to export transaction history to a file.
# Function to export transaction history
function export_history() {
    read -p "Enter the name of the file to export to: " export_file
    if [[ -n "$export_file" ]]; then
        cp "$history_file" "$export_file"
        echo "Transaction history has been exported to $export_file."
    else
        echo "Invalid input. Please enter a valid file name."
    fi
}

# Adding a new feature to allow the user to view the current bankroll limit.
# Function to view bankroll limit
function view_bankroll_limit() {
    echo "Current bankroll limit is: 1,000,000"
}

# Adding a new feature to allow the user to view the current bankroll in different currencies.
# Function to view bankroll in different currencies
function view_bankroll_in_currency() {
    read -p "Enter the currency code (USD, EUR, GBP, etc.): " currency
    if [[ -n "$currency" ]]; then
        # Assuming we have a function called convert_to_currency that takes the amount and currency code as arguments
        converted_bankroll=$(convert_to_currency $bankroll $currency)
        echo "Your current bankroll is: $converted_bankroll $currency"
    else
        echo "Invalid input. Please enter a valid currency code."
    fi
}

# Adding the new feature to the main loop
while true; do
    echo "What would you like to do?"
    echo "1. Add winnings"
    echo "2. Subtract losses"
    echo "3. Display bankroll"
    echo "4. Set bankroll"
    echo "5. Reset bankroll"
    echo "6. Set session name"
    echo "7. View session name"
    echo "8. Display transaction history"
    echo "9. Clear transaction history"
    echo "10. Backup session"
    echo "11. Restore session from backup"
    echo "12. Delete session"
    echo "13. View backup name"
    echo "14. Import transaction history"
    echo "15. Export transaction history"
    echo "16. View bankroll limit"
    echo "17. View bankroll in different currencies"
    echo "18. Exit"
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
            view_session_name
            ;;
        8)
            display_history
            ;;
        9)
            clear_history
            ;;
        10)
            backup_session
            ;;
        11)
            restore_session
            ;;
        12)
            delete_session
            ;;
        13)
            view_backup_name
            ;;
        14)
            import_history
            ;;
        15)
            export_history
            ;;
        16)
            view_bankroll_limit
            ;;
        17)
            view_bankroll_in_currency
            ;;
        18)
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 18."
            ;;
    esac
done