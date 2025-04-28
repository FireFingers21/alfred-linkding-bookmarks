#!/bin/zsh --no-rcs

readonly bookmarks=$(curl -s -w "\n%{http_code}" "${baseUrl}/api/bookmarks/?limit=${limit}" -H "Authorization: Token ${token}")
http_code=$(tail -n 1 <<< "${bookmarks}")

case "${http_code}" in
	200)
		readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
		readonly favicon_folder="${alfred_workflow_data}/favicons"

		mkdir -p "${alfred_workflow_data}"
		readonly oldBookmarks=$(shasum -a 256 ${bookmarks_file} | awk '{print $1}')
		echo -nE "${bookmarks}" > "${bookmarks_file}"
		readonly newBookmarks=$(shasum -a 256 ${bookmarks_file} | awk '{print $1}')

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