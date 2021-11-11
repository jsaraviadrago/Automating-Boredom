tell application "Mail"
	set newMessage to (a reference to (make new outgoing message))
	tell newMessage
		make new to recipient at beginning of to recipients ¬
			with properties {address:"email_addres", name:"name"}
		make new to recipient at beginning of to recipients ¬
			with properties {address:"email_addres", name:"name"}
		set the sender to "Home <sender mail>"
		set the subject to "text"
		set the content to "Content

		"
		send
	end tell
end tell