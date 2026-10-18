#!/bin/bash

# Backup the world, just in case. You're welcome Taylor.
NOW=$(date "+%Y-%m-%d_%H:%M")
TO="$PWD/Backups/$NOW"
rm -rf "$PWD/Backups"
mkdir -p "$TO" && find "$PWD/Worlds" -maxdepth 1 -type f -exec cp {} "$TO" \;
