REBOL [
	Title: "Dreams Model"
	Date: 25-Nov-2013
	Author: "Christopher Ross-Gill"
	Root: wrt://space/dreams/
]

dream!: context [
	header: body: none

	title: does [
		title: any [
			header/title
			unwordify any [header/slug "lucid-dream"]
		]
	]

	characters: has [character][
		characters: unique collect [
			foreach line body [
				if block? line [
					foreach part line [
						if set-word? part [keep form part]
					]
				]
			]
		]
	]

	tags: does [
		tags: unique collect [
			foreach tag any [header/tags []][
				keep form tag
			]
		]
	]

	render: has [part][
		require %dreams/htmlify.reb
		htmlify body
	]
]

errors: []

load-dream: use [script script? load-header][
	script: make system/standard/script [Type: Category: Slug: Tags: Old: none]

	script?: use [space id mark type][
		space: charset " ^-"
		id: [
			any space mark: 
			any ["[" mark: (mark: back mark) any space]
			copy type "realityhandbook"
			any space
			"[" to end
		]

		func [source [string! binary!] /language][
			if all [
				parse/all source [
					some [
						id break |
						(mark: none)
						thru newline opt #"^M"
					]
				]
				mark
			][either language [type][mark]]
		]
	]

	load-header: func [[catch] source [string! binary!] /local header][
		source: to string! source
		unless header: script? source [make error! "Source does not contain header."]
		header: find next header "["
		unless header: attempt [load/next header][make error! "Header is incomplete."]
		back insert load join "REBOL [] " header/2 construct/with header/1 script
	]

	load-dream: func [dream [url!]][
		if verify [
			exists? dream [
				append errors ["Dream Not Found"]
			]

			dream: try-else [load-header read dream][
				append errors form-error reason
			][]
		][
			make dream! [
				header: take dream
				body: dream
			]
		]
	]
]

get: func [dream [string!]][
	clear errors
	load-dream join header/root/:dream %.reb
]