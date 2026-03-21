# RPGMaker VX Ace JSON Converter - RV2JSON

A Ruby-based application that converts RPG Maker VX Ace .rvdata2 files into JSON and back.
It can dump game data and scripts to human-readable JSON and Ruby files, and update rvdata2 files from those JSON/script dumps.

# Requirements
- Ruby (3.4+ recommended)
- Standard libraries: `json`, `zlib`, `fileutils` (all included with MRI Ruby)

# Features
- **Dump data to JSON:** Convert core game data (actors, items, maps, etc.) into JSON files.
- **Dump scripts:** Extract scripts from `Scripts.rvdata2` into plain `.rb` files.
- **Update data from JSON:** Read edited JSON and write updated `.rvdata2` files.
- **Update scripts from dumped files:** Re-encode and write `Scripts.rvdata2` when script files are present.
- **Backups:** When updating in-place, original `.rvdata2` files are backed up before being overwritten.

# Default Directories
- **Data folder:** data
- **JSON folder:** ace_json

# Usage
Run the converter script directly with Ruby:

### Dump JSON and scripts (create):
```bash
# With defaults (data in `data`, JSON in `ace_json`):
ruby RV2JSON.rb -c

# With custom directories:
ruby RV2JSON.rb -c -d data_input -j json_output
```

### Update rvdata2 files from JSON and scripts (update):
```bash
# In-place update with defaults (backups created in `data/backups`):
ruby RV2JSON.rb -u

# With custom input and output directories:
ruby RV2JSON.rb -u -d data_input -j json_input -o data_output
```

Alternatively, all commands can be run with the RV2JSON executable, e.g.:
```bash
RV2JSON.exe -c -d Data -j ace_json
```

# Command-line Options
- **-c, --create:** Convert `.rvdata2` files to JSON and extract scripts.
- **-u, --update:** Update data from JSON and the extracted scripts.
- **-dDIR, --data-dir DIR:** Path to the data directory (default: `data`).
- **-jDIR, --json-dir DIR:** Path to the JSON directory (default: `ace_json`).
- **-oDIR, --out-dir DIR:** Path to the output directory (default: same as data dir).
- **-s, --skip-backup:** When updating in-place, skip creating backups of original files.
- **-v, --verbose:** Print additional information.
- **-h, --help:** Show help and exit.
