#!/bin/zsh --no-rcs

readonly bookmarks=$(curl -s --compressed -w "\n%{http_code}" "${baseUrl}/api/bookmarks/?limit=${limit}" -H "Authorization: Token ${token}")
readonly http_code="${bookmarks##*$'\n'}"

case "${http_code}" in
	200)
		readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
		readonly favicon_folder="${alfred_workflow_data}/favicons"

		mkdir -p "${alfred_workflow_data}"
		readonly oldBookmarks=$(< ${bookmarks_file} | md5)
		echo -nE "${bookmarks%$'\n'*}" > "${bookmarks_file}"
		readonly newBookmarks=$(< ${bookmarks_file} | md5)

		if [[ "${useFavicons}" -eq 1 && "${oldBookmarks}" != "${newBookmarks}" ]]; then
		    mkdir -p "${favicon_folder}"
			for url in $(jq -rs '.[].results | map(.favicon_url) | .[]' ${bookmarks_file} | sort | uniq); do
			    filename=$(basename "$url")
				curl -s -o "${favicon_folder}/$filename" "$url" &
				[[ $(jobs | wc -l) -eq 15 ]] && wait
			done
			find "${favicon_folder}" -type f -maxdepth 1 ! -newer "${bookmarks_file}" -delete
		fi

		printf "Bookmarks Updated"
		;;
	401)
		printf "Invalid API Token"
		;;
	*)
		printf "linkding server not found"
		;;
esac