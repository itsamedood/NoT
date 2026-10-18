#!/bin/bash

echo "Deleting current tModLoader files..."
rm -rf "$PWD/_TMODLOADER"

echo "Downloading latest tModLoader files..."
curl -OLs --create-dirs --output-dir "$PWD/_TMODLOADER" https://github.com/tModLoader/tModLoader/releases/latest/download/tModLoader.zip

echo "Extracting tModLoader.zip..."
unzip -q "$PWD/_TMODLOADER/tModLoader.zip" -d "$PWD/_TMODLOADER"

echo "Cleaning up..."
rm -f "$PWD/_TMODLOADER"/*.{bat,txt,zip}
rm "$PWD/_TMODLOADER"/start-tModLoader{,-FamilyShare}.sh

echo "Done!"
