#!/bin/zsh --no-rcs

# Get lastest cache timestamp
readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
readonly favicons_file="${alfred_workflow_data}/favicons"

readonly lastUpdated=$(date -r "${bookmarks_file}" +"%A, %B %d %Y at %I:%M%p" || printf "Never")

cat << EOB
{"items": [
	{
		"title": "Reload Bookmarks",
		"subtitle": "Last Update: ${lastUpdated}",
		"variables": { "pref_id": "reload" }
	},
	{
		"title": "New Bookmark",
		"variables": { "pref_id": "new" },
		"mods": {
			"cmd": {
				"subtitle": "Open in secondary browser",
				"variables": {
					"bSecondary": true,
					"pref_id": "new"
				}
			}
		}
	},
	{
		"title": "Open linkding",
		"variables": { "pref_id": "open" },
		"mods": {
			"cmd": {
				"subtitle": "Open in secondary browser",
				"variables": {
					"bSecondary": true,
					"pref_id": "open"
				}
			}
		}
	},
	{
		"title": "Browser Settings",
		"subtitle": "Select the default browsers for ${alfred_workflow_name}",
		"variables": { "pref_id": "browser" }
	},
]}
EOB