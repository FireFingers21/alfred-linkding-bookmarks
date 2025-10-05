#!/bin/zsh --no-rcs

readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
readonly favicon_folder="${alfred_workflow_data}/favicons"

# Auto Update
[[ -f "${bookmarks_file}" ]] && [[ "$(date -r "${bookmarks_file}" +%s)" -lt "$(date -v -"${autoUpdate}"H +%s)" && "${autoUpdate}" -ne 0 ]] && reload=$(./reload.sh)

# Favicon Check
[[ "${useFavicons}" -eq 1 ]] && [[ -f "${bookmarks_file}" ]] && [[ ! -d "${favicon_folder}" ]] && reload=$(./reload.sh)

# Load Bookmarks
jq -cs \
   --arg baseUrl "$baseUrl" \
   --arg useDesc "$useDesc" \
   --arg useNotes "$useNotes" \
   --arg useURL "$useURL" \
   --arg useTag "$useTag" \
   --arg showAllTags "$showAllTags" \
   --arg useQL "$useQL" \
   --arg useFavicons "$useFavicons" \
   --arg favicon_folder "$favicon_folder" \
'{
	"items": (if (length != 0) and (.[].results | length > 0) then
		.[].results | map((if .tag_names | contains("Exclude-Alfred" | split("")) then empty else {
			"uid": .id,
			"title": .title,
			"subtitle": "\(.tag_names | if .[0] then (if $showAllTags == "1" then "["+join(", ")+"] " else "["+.[0]+"] " end) else "" end)\(.url)",
			"arg": .url,
			"match": [
                .title,
                (if $useDesc == "1" then .description else empty end),
                (if $useNotes == "1" then .notes else empty end),
                (if $useURL == "1" then .url else empty end),
                (if $useTag == "1" then (.tag_names[] | "#" + .) else empty end)
            ] | map(select(.)) | join(" "),
			"quicklookurl": "\(if $useQL == "1" then .url else "" end)",
			"text": { "largetype": "[\(.tag_names | join(", "))]\n\n\(.url)" },
			"icon": {
				"path": (if ($useFavicons == "1" and .favicon_url) then "\($favicon_folder)/\(.favicon_url | split("/") | .[-1])" else "" end)
			},
			"mods": {
				"cmd": {
					"subtitle": "⌘↩ Open in secondary browser",
					"variables": { "bSecondary": true }
				},
				"alt": {
					"subtitle": "⌥↩ Edit in linkding",
					"arg": "\($baseUrl)/bookmarks/\(.id)/edit"
				},
				"alt+shift": {
					"subtitle": "⇧⌥↩ View in linkding",
					"arg": "\($baseUrl)/bookmarks?details=\(.id)"
				},
				"ctrl": {
					"subtitle": "⌃↩ Delete from linkding",
					"arg": "",
					"variables": {
						"bId": .id,
						"bTitle": .title,
						"bUrl": .url,
						"bIcon": (if ($useFavicons == "1" and .favicon_url) then "\($favicon_folder)/\(.favicon_url | split("/") | .[-1])" else "" end)
					}
				},
				"shift": {
					"subtitle": .description
				}
			}
		}end))
	elif length == 0 then
		[{
			"title": "No Bookmarks Found",
			"subtitle": "Press ↩ to load bookmarks",
			"arg": "reload"
		}]
	else
		[{
			"title": "Search Bookmarks...",
			"subtitle": "You have no bookmarks",
			"valid": "false"
		}]
	end)
}' "${bookmarks_file}"