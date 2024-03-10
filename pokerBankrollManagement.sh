#!/bin/bash

# Initialize bankroll to 0
bankroll=0

# Function to add winnings to bankroll
function add_winnings() {
    echo "Enter winnings: "
    read winnings
    bankroll=$((bankroll + winnings))
}

# Function to subtract losses from bankroll
function subtract_losses() {
    echo "Enter losses: "
    read losses
    bankroll=$((bankroll - losses))
}

# Function to display bankroll
function display_bankroll() {
    echo "Your current bankroll is: $bankroll"
}

# Main loop
while true; do
    echo "What would you like to do?"
    echo "1. Add winnings"
    echo "2. Subtract losses"
    echo "3. Display bankroll"
    echo "4. Exit"
    read choice

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
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 4."
            ;;
    esac
done
