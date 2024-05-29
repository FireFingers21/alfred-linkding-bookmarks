#!/bin/zsh --no-rcs

readonly bookmarks=$(curl -s "${baseUrl}/api/bookmarks/?limit=${limit}" -H "Authorization: Token ${token}")

case "${bookmarks}" in
	"")
		echo -n "linkding server not found"
		;;
	*"Invalid token"*)
		echo -n "Invalid API Token"
		;;
	*)
		readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
		readonly last_updated_file="${alfred_workflow_data}/lastUpdated.txt"

		mkdir -p "${alfred_workflow_data}"
		echo -nE "${bookmarks}" > "${bookmarks_file}"
		echo -n "lastUpdated='$(date +"%A, %B %d %Y at %I:%M%p")'" > "${last_updated_file}"
		echo -n "Bookmarks Updated"
		;;
esac