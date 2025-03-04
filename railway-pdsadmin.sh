#!/bin/bash
# Helper script for managing Bluesky PDS on Railway

# Function to display usage
function show_usage {
  echo "Usage: railway-pdsadmin.sh [command]"
  echo ""
  echo "Commands:"
  echo "  account create            Create a new account"
  echo "  create-invite-code        Generate an invite code"
  echo "  update                    Update the PDS"
  echo "  help                      Show this help message"
  echo ""
}

# Check if a command was provided
if [ $# -eq 0 ]; then
  show_usage
  exit 1
fi

# Process commands
case "$1" in
  "account")
    if [ "$2" = "create" ]; then
      echo "Creating a new account..."
      pdsadmin account create
    else
      echo "Unknown account command: $2"
      show_usage
      exit 1
    fi
    ;;
  "create-invite-code")
    echo "Generating invite code..."
    pdsadmin create-invite-code
    ;;
  "update")
    echo "Updating PDS..."
    pdsadmin update
    ;;
  "help")
    show_usage
    ;;
  *)
    echo "Unknown command: $1"
    show_usage
    exit 1
    ;;
esac 