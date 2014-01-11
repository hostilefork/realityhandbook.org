Rebol [
	Title: "Make RealityHandbook"
	Description: {
		This is the script for building the static template files behind
		the website realityhandbook.org.  It requires that you have
		a subdirectory called "draem" containing the Draem builder:

			https://github.com/hostilefork/draem
		
		See the Draem documentation (and/or source) for config options.
	}

	Author: "realityhandbook"
	Home: https://github.com/hostilefork/realityhandbook
	License: 'bsd

	Date: 20-Oct-2010
	Version: 0.3.0.4

	; Header conventions: http://www.rebol.org/one-click-submission-help.r
	File: %make-realityhandbook.reb
	Type: 'tool
	Level: 'intermediate

	Usage: {
		Requires Rebol 3.  From the command line, run:

			$ rebol make-realityhandbook.reb

		Generated static pages will be found in the templates directory.
	}
]

do %draem/draem.reb

draem/set-config object compose [
	site-url: http://realityhandbook.org/
	site-name: "Reality Handbook"

	valid-categories: [
		;-- "artificial" categories, don't participate in indexing
		;-- (need a better way to do this!)
		about
		contact

		;-- "real" categories; pages are indexed
		essay
		lucid-dream
		non-lucid-dream
		open-letter
		misc
		hypnosis
		guest-dream
	]

	;-- Optional header-checking hook
	check-header: function [header [object!]] [
		if find [lucid-dream non-lucid-dream] header/category [ 
			unless any [
				find header/tags 'neutral
				find header/tags 'positive
				find header/tags 'negative
			] [
				probe header/tags
				throw make error! "Dreams must be tagged neutral, positive, or negative"
			]
		]
	]

	;-- Required url-from-header hook
	url-from-header: function [header [object!]] [
		rejoin [
			site-url stringify/dashes header/category {/}
			either find [about contact] header/category [
				{}
			] [
				header/slug
			]
		]
	]

	entries-dir: (rejoin [system/options/path %entries/])
	templates-dir: (rejoin [system/options/path %templates/])
]

draem/make-site
