#!/bin/zsh --no-rcs

# Get lastest cache timestamp
readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
readonly lastUpdated=$(date -r "${bookmarks_file}" +"%A, %B %d %Y at %I:%M%p" || printf "Never")

cat << EOB
{"items": [
	{
		"title": "Reload Bookmarks",
		"subtitle": "Last Updated: ${lastUpdated}",
		"variables": { "pref_id": "reload" }
	},
	{
		"title": "Open linkding",
		"variables": { "pref_id": "open" },
		"mods": {
			"cmd": {
				"subtitle": "⌘↩ Open in secondary browser",
				"variables": { "bSecondary": true, "pref_id": "open" }
			}
		}
	},
	{
		"title": "Configure Workflow...",
		"subtitle": "Open the configuration window for ${alfred_workflow_name}",
		"variables": { "pref_id": "configure" }
	},
]}
EOB