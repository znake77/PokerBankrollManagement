#!/bin/bash

# Initialize bankroll to 0
bankroll=0
session_file="default_session"

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

# Function to add winnings to bankroll
function add_winnings() {
    read -p "Enter winnings: " winnings
    if [[ $winnings =~ ^[0-9]+$ ]]; then
        bankroll=$((bankroll + winnings))
        save_session
    else
        echo "Invalid input. Please enter a number."
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
            save_session
        fi
    else
        echo "Invalid input. Please enter a number."
    fi
}

# Function to display bankroll
function display_bankroll() {
    echo "Your current bankroll is: $bankroll"
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

# Main loop
while true; do
    echo "What would you like to do?"
    echo "1. Add winnings"
    echo "2. Subtract losses"
    echo "3. Display bankroll"
    echo "4. Set session name"
    echo "5. Exit"
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
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 5."
            ;;
    esac
done
