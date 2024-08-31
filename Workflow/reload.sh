#!/bin/zsh --no-rcs

readonly bookmarks=$(curl -s "${baseUrl}/api/bookmarks/?limit=${limit}" -H "Authorization: Token ${token}")

case "${bookmarks}" in
	"" | "error code"*)
		echo -n "linkding server not found"
		;;
	*"Invalid token"*)
		echo -n "Invalid API Token"
		;;
	*)
		readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
		readonly favicon_folder="${alfred_workflow_data}/favicons"

		mkdir -p "${alfred_workflow_data}"
		echo -nE "${bookmarks}" > "${bookmarks_file}"

		if [[ "${useFavicons}" -eq 1 ]]; then
		    mkdir -p "${favicon_folder}"
			for url in $(jq -rs '.[].results | map(.favicon_url) | .[]' ${bookmarks_file} | sort | uniq); do
			    filename=$(basename "$url")
				curl -s -o "${favicon_folder}/$filename" "$url" &
				[[ $(jobs | wc -l) -eq 15 ]] && wait
			done
			find "${favicon_folder}" -type f -maxdepth 1 ! -newer "${bookmarks_file}" -delete
		fi

		echo -n "Bookmarks Updated"
		;;
esac
