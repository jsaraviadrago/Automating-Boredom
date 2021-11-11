tell application "Safari"
	activate
	try
		tell window 1 to set current tab to make new tab with properties {URL:"https://www.linkedin.com/feed/"}
	on error
		open location "https://www.linkedin.com/feed/"
	end try
end tell
