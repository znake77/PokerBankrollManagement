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

# Function to set session name
function set_session_name() {
    read -p "Enter session name (leave blank for default): " name
    if [ -z "$name" ]; then
        session_file="default_session"
    else
        session_file="$name"
    fi
    load_session
}

# Function to backup session
function backup_session() {
    backup_file="${session_file}_backup"
    cp "$session_file" "$backup_file"
    echo "Session has been backed up to $backup_file."
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
# Add restore option to main loop
while true; do
    echo "What would you like to do?"
    echo "1. Add winnings"
    echo "2. Subtract losses"
    echo "3. Display bankroll"
    echo "4. Set session name"
    echo "5. Display transaction history"
    echo "6. Backup session"
    echo "7. Restore session from backup"
    echo "8. Exit"
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
            set_session_name
            ;;
        5)
            display_history
            ;;
        6)
            backup_session
            ;;
        7)
            restore_session
            ;;
        8)
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 8."
            ;;
    esac
done