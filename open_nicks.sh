#!/bin/bash

chmod +x "$PWD/_TMODLOADER/start-tModLoaderServer.sh" # Server script.
chmod +x "$PWD/update_tml.sh" # Updates everything in _TMODLOADER.
chmod +x "$PWD/backup_world.sh" # Copies World files to Backup.

password="$(cat "$PWD/password.txt")"

messages=(
  # Deli related.
  "Can I get 5 pounds of honey maple turkey sliced thin?"
  "I want the veggie salad with oil vinegar mixed in."
  "Gimme liverwurst with cajun turkey on wheat bread."
  "Can you cut my sub into 4ths?"
  "Can I get the works on the side?"

  # Meat related.
  "What species is your chicken?" # Yes a customer actually asked me this...
  "Are your beef back ribs pork?"
  "Whole new york strip, quarter inch."
  "I want a whole salmon, skinned, and cut please."
  "Can you cut it just a little less than quarter inch please?"
)

declare -a motd_choices

# Command-line arguments.
while getopts "hMm:" flag; do
  case ${flag} in
  h)
    echo "Usage: $0 [-h(elp) | -M(anual) | -m(ods list)] <rand_msg_interval (in seconds, 3600=1hr)>"
    exit 0
    ;;
  M)
    manual=true
    ;;
  m)
    modslist=true
    ;;
  r)
    rmi=true # More work to be done here.
    ;;
  *)
    echo "Bad option. Use -h for help."
    exit 1
    ;;
  esac
done

if [[ "$manual" == "true" ]]; then
 "$PWD/_TMODLOADER/start-tModLoaderServer.sh" \
    -nosteam \
    -config "$PWD/_CONFIG.txt"

  exit 0
fi

# Setup dynamic pipe in memory for inputs.
rm -f /tmp/tmod_pipe
mkfifo /tmp/tmod_pipe

# Background daemon for inputs & messages every hour.
(
  # Inputs (sleep to help not go too fast).
  if [[ "$modslist" == "true" ]]; then
    (
      sleep 60; echo "m"
    ) > /tmp/tmod_pipe
  else
    (
      sleep 60; echo "1"
      sleep 1; echo "3"
      sleep 1; echo "7777"
      sleep 1; echo "y"
      sleep 1; echo "$password"
    ) > /tmp/tmod_pipe
  fi
) &

logfile="$PWD/Logs/server_$(date +%Y-%m-%d_%H-%M).log"

# Read inputs and pipe them into the process, and log it all in real time.
cat /tmp/tmod_pipe - | "$PWD/_TMODLOADER/start-tModLoaderServer.sh" \
  -nosteam \
  -config "$PWD/_CONFIG.txt" 2>&1 | tee "$logfile"

# Clean up pipe in memory.
rm -f /tmp/tmod_pipe
"$PWD/backup_world.sh"
