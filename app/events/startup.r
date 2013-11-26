REBOL [
	Title: "Startup Event"
	Date: 25-Nov-2013
	Author: "Christopher Ross-Gill"
	Type: 'event
]

require %text/wordify.r

listify: func [list [block!]][
	remove rejoin collect [
		foreach item list [
			keep rejoin [", " form item]
		]
	]
]
