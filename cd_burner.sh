#!/bin/bash

# Prompt the user for the path to the directory containing the audio files
echo "Please enter the path to the directory containing the audio files:"
read AUDIO_PATH

# Validate the input directory path
if [[ ! -d "$AUDIO_PATH" ]]; then
  echo "The provided path does not exist or is not a directory. Please check the path and try again."
  exit 1
fi

# Function to burn audio CD and close it
burn_audio_cd() {
  local drive_id=$1
  local audio_path=$2

  echo "Attempting to burn on drive $drive_id with path $audio_path"

  # Ensure we're acting on a valid drive ID
  if [[ $drive_id =~ ^[0-9]+$ ]]; then
    echo "Starting to burn audio CD on drive $drive_id..."

    # Debugging: Echo the command to be executed
    echo "drutil burn -drive $drive_id -audio \"${audio_path}\""

    # Execute the command (Uncomment below line when ready to test)
    # drutil burn -drive $drive_id -audio "${audio_path}"

    echo "Burning process initiated for drive $drive_id."
  else
    echo "Skipping invalid drive ID: $drive_id"
  fi
}

# Get list of drive IDs, filtering out non-numeric IDs
drive_ids=($(drutil list | awk '$1 ~ /^[0-9]+$/ {print $1}'))

# Burn audio CD on each drive in parallel and wait for all to finish
for drive_id in "${drive_ids[@]}"; do
  burn_audio_cd $drive_id "$AUDIO_PATH" &
done

wait # Wait for all background jobs to finish
echo "All burning processes are initiated. Please check each drive for completion status."
