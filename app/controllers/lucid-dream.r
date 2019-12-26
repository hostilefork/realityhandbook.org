Rebol [
	Title: "Lucid Dreams Controller"
	Date: 25-Nov-2013
	Type: 'controller
	Author: "Christopher Ross-Gill"
	Template: %templates/realityhandbook.rsp
]

route () to dream [
	get [
		id: "about"
		dream: dreams/get id
	]
]

route (id: string! [1 3 ident]) to dream [
	verify [
		dream: dreams/get id [
			reject 404 "Unable to Locate Dream"
		]
	]

	get []
]