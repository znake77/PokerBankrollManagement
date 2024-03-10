#!/bin/bash

# Initialize bankroll to 0
bankroll=0

# Function to add winnings to bankroll
function add_winnings() {
    read -p "Enter winnings: " winnings
    if [[ $winnings =~ ^[0-9]+$ ]]; then
        bankroll=$((bankroll + winnings))
    else
        echo "Invalid input. Please enter a number."
    fi
}

# Function to subtract losses from bankroll
function subtract_losses() {
    read -p "Enter losses: " losses
    if [[ $losses =~ ^[0-9]+$ ]]; then
        bankroll=$((bankroll - losses))
    else
        echo "Invalid input. Please enter a number."
    fi
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
            echo "Exiting the program."
            break
            ;;
        *)
            echo "Invalid choice. Please choose a number between 1 and 4."
            ;;
    esac
done

