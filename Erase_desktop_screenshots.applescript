try
	tell application "Finder"
		
		delete (every item of folder (path to desktop folder) whose name begins with "Screen Shot")
		delete (every item of folder (path to downloads folder) whose name ends with ".png")
		
	end tell
	
on error
	
	display dialog ("Error. Couldn't Move the File") buttons {"OK"}
	
end try