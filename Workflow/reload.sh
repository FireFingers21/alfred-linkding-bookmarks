#!/bin/zsh --no-rcs

readonly bookmarks=$(curl -s --compressed -w "\n%{http_code}" "${baseUrl}/api/bookmarks/?limit=${limit}" -H "Authorization: Token ${token}")
readonly http_code="${bookmarks##*$'\n'}"

case "${http_code}" in
	200)
		readonly bookmarks_file="${alfred_workflow_data}/bookmarks.json"
		readonly favicon_folder="${alfred_workflow_data}/favicons"

		mkdir -p "${alfred_workflow_data}"
		readonly oldFavicons=($(jq -rs '.[].results | map(.favicon_url) | unique | .[]' ${bookmarks_file}))
		echo -nE "${bookmarks%$'\n'*}" > "${bookmarks_file}"
		readonly newFavicons=($(jq -rs '.[].results | map(.favicon_url) | unique | .[]' ${bookmarks_file}))

		if [[ "${useFavicons}" -eq 1 && ("${oldFavicons}" != "${newFavicons}" || ! -d "${favicon_folder}") ]]; then
		    mkdir -p "${favicon_folder}"
			curl -s --compressed --parallel --output-dir "${favicon_folder}" --remote-name-all -L "${newFavicons[@]}"
			find "${favicon_folder}" -type f -maxdepth 1 ! -newer "${bookmarks_file}" -delete
		elif [[ "${useFavicons}" -eq 0 && -d "${favicon_folder}" ]]; then
            rm -r "${favicon_folder}"
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