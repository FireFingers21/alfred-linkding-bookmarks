# <img src='Workflow/icon.png' width='45' align='center' alt='icon'> linkding Bookmarks

Search linkding bookmarks in Alfred

## Setup

Set the Base URL and API Token of your [linkding](https://github.com/sissbruecker/linkding) installation in the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/). You can find the API Token from your linkding Settings → Integrations → Rest API.

**Note**: This workflow requires [jq](https://jqlang.github.io/jq/) to function.

## Usage

Search for your [linkding](https://github.com/sissbruecker/linkding) bookmarks using the `bm` keyword.

![Searching for linkding bookmarks](Workflow/images/about/keyword.png)

Type to refine your search. Bookmarks are always filtered by title, while filtering by description, URL, and tags is configurable from the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/).

![Narrowing search for linkding bookmarks](Workflow/images/about/tagFilter.png)

* <kbd>↩</kbd> Open bookmark in primary browser
* <kbd>⌘</kbd><kbd>↩</kbd> Open bookmark in secondary browser
* <kbd>⌘</kbd><kbd>C</kbd> Copy bookmark URL
* <kbd>⌥</kbd><kbd>↩</kbd> Edit bookmark in linkding
* <kbd>⌃</kbd><kbd>↩</kbd> Delete bookmark from linkding

Append `::` to the configured [Keyword](https://www.alfredapp.com/help/workflows/inputs/keyword) to access other actions, including manually reloading the bookmark cache. You can also change the default browser settings from here without using the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/).

![Other actions](Workflow/images/about/inlineSettings.png)

Enable bookmark auto-updates from the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/). Bookmarks will reload upon [Workflow Trigger](https://www.alfredapp.com/help/workflows/triggers/). See a timestamp of the last successful reload from the other actions as shown in the image above.

Configure the [Hotkey](https://www.alfredapp.com/help/workflows/triggers/hotkey/) as a shortcut to search for your bookmarks. Use the [Universal Action](https://www.alfredapp.com/help/features/universal-actions/) to bookmark URLs from Alfred’s [Clipboard History](https://www.alfredapp.com/help/features/clipboard/) or selected text.

Bookmarks with the tag `Exclude-Alfred` will be hidden from search. This tag is case sensitive.