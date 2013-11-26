rebol [
	Title: "Make Django Templates"
	Description: {

	Currently the way the realityhandbook website works is that there is
	no database, just a bunch of templates... one generated for each
	article, and then for each tag + category + character.  These 
	templates participate in Django's inheritance model... so each one
	adds its content to a baseline template without repeating the
	boilerplate.

	}

	Home: http://realityhandbook.org/
	License: 'mit

	Date: 20-Oct-2010
	Version: 3.0.4

	; Header conventions: http://www.rebol.org/one-click-submission-help.r
	File: %make-templates.reb
	Type: 'dialect
	Level: 'intermediate
]

do %common.reb

django-block: func [name [string!] stuff [block!] /inline] [
	result: compose [
		(rejoin ["{% block" space name space "%}"])
		(reduce stuff)
		(rejoin ["{% endblock" space name space "%}"])
	]
	if inline [
		result: reduce [rejoin result]
	]
	append result {}
]

django-path: func [stuff [block!] ] [
	django-block "path" compose [
		{<li>
			<a href="http://realityhandbook.org" title="Home">Home</a>
		</li>}
		(stuff)
		{}
	]
]

django-extends: func [template [file!]] [
	compose [
		(rejoin ["{% extends" space {"} to string! template {"} space "%}"])
		{}
	]	
]

open-anchor: func [url [url!]] [
	rejoin [{<} {a} space {href} {=} {"} to string! url {"} {>}]
]

close-anchor: {</a>}

link-to-category: func [category [word!] /count num] [
	rejoin [
		open-anchor rejoin [
			http://realityhandbook.org/category/
			stringify/dashes category 
			{/}
		]
		stringify category
		close-anchor
		space {:} space num {<br />}
	]

]

link-to-tag: func [tag [word!] /count num] [
	rejoin [
		open-anchor rejoin [
			http://realityhandbook.org/tag/ stringify/dashes tag {/}
		]
		stringify tag
		close-anchor
		space {:} space num {<br />}
	]
]

link-to-character: func [character [word!] /count num] [
	rejoin [
		open-anchor rejoin [
			http://realityhandbook.org/character/ stringify/dashes character {/}
		]
		stringify character
		close-anchor
		space {:} space num {<br />}
	]
]



dream-markup: function [block [block!]] [
	unless all [
		 1 == length? block
		 string? first block
	] [
		throw make error! "Currently we don't mark up anything but single strings"
	]
	str: copy first block
	replace/all str {--} {&mdash;}
	return str
]

htmlify: function [
	{	This recursive function is what produces the readable HTML for
		an entry from its structure.  It's tricky but seems to work well
		enough for now.  If I move away from storing entries as Rebol
		and migrate instead to a database I'll have to write something
		similar in django.  For now it's looking like a Rebol script is
		a better idea.
	}
	e [block!]
	/nested
	/nestfirst
	/nestlast
] [
	either block? first e [
		result: copy {}
		subpos: head e
		while [not tail? subpos] [
			if (not none? nested) and (head? subpos) [
				append result htmlify/nestfirst first subpos
				subpos: next subpos
				continue
			]
			
			if (not none? nested) and (subpos == back tail e) [
				append result htmlify/nestlast first subpos
				subpos: next subpos
				continue
			]
			
			append result htmlify first subpos
			subpos: next subpos
		]
	] [
		switch/default first e [
			picture [
				result: rejoin [
					either nestfirst [{}] [{<p>}]
					{<center><a href="http://s159.photobucket.com/albums/t125/realityhandbook/}
					second e
					{">}
					
					{<img src="http://i159.photobucket.com/albums/t125/realityhandbook/}
					{th_}
					second e
					{" />}
					{</a></center>}
					either nestlast [{}] [rejoin [{</p>} lf]]
				]
			]
			divider [
				result: "<hr>"
			]
			quote [
				result: rejoin [
					either nestfirst [{<blockquote>}] [{<blockquote><p>}]
					either string? second e [
						second e
					] [
						htmlify/nested second e
					]
					either nestlast [{</blockquote>}] [rejoin [{</p></blockquote>} lf]]
				]
				if not string? second e [probe e print result ]
			]
			note [
				result: rejoin [
					either nestfirst [{}] [{<p>}]
					{<i>(Note:} space
					either string? second e [
						second e
					] [
						htmlify/nested second e
					]
					{)</i>}
					either nestlast [{}] [rejoin [{</p>} lf]]
				]
				if not string? second e [probe e print result]
			]
		] [
			case [
				string? first e [
					result: rejoin [
						either nestfirst [{}] [{<p>}]
						dream-markup e
						either nestlast [{}] [rejoin [{</p>} lf]]
					]
				]
				set-word? first e [
					;; Dialogue

					result: rejoin [
						either nestfirst [{}] [{<p>}]
						{<b>} stringify first+ e {</b>} ":" space 
						either paren? first e [
							rejoin ["(" first+ e ")" space]
						] [
							{}
						]
						{"} dream-markup e {"}
						either nestlast [{}] [rejoin [{</p>} lf]]
					]
				]
				true [
					print head e
					throw make error! "Entry lines should start with a keyword, a string (if exposition), or a set-word (if dialogue)" 
				]
			]
		]
	]
	return result
]

write-entry: function [
	entry [object!]

	earlier-entry [none! object!]

	later-entry [none! object!]

	html-file [file!]
] [

	print [{write-entry} html-file]
	
	content-html: htmlify entry/content
	
	html: compose [
		(django-extends %entry.html)
		
		(django-block/inline "keywords" [
			comma-separated head insert copy entry/header/tags entry/header/category
		])
		
		(django-block/inline "description" [
			comma-separated reduce [
				{Author: A.E. 1020}
				rejoin [{Category:} space stringify entry/header/category]
				rejoin [{Title:} space entry/header/title]
				rejoin [{date:} space entry/header/date/date]
				rejoin [{Length:} space length? (split content-html space) space "words"]
			]
		])
		
		(django-block/inline "title" [
			rejoin [entry/header/category space ":" space entry/header/title]
		])
		
		(django-block/inline "header" [
			entry/header/title
		])
		
		(django-path [
			rejoin [
				{<li>}
					{<a href="http://realityhandbook.org/category/}
					stringify/dashes entry/header/category {/">} 
					stringify entry/header/category 
					{</a>}
				{</li>}
				{<li><span>}
					entry/header/title
				{</span></li>}
			]
		])
		
		(django-block "date" [
			entry/header/date
		])

		(django-block "tags" [
			either empty? entry/header/tags [
				"(none)"
			] [
				comma-separated/callback entry/header/tags function [tag] [
					rejoin [ 
						{<a href="http://realityhandbook.org/tag/}
						stringify/dashes tag
						{/">} stringify tag {</a>}
					]
				]
			]
		])

		(django-block "characters" [
			either empty? select indexes/slug-to-characters entry/header/slug [
				"(none)"
			] [
				 comma-separated/callback select indexes/slug-to-characters entry/header/slug function [character] [
					rejoin [ 
						{<a href="http://realityhandbook.org/character/}
						stringify/dashes character
						{/">} stringify character {</a>}
					]
				]
			]
		])

		(django-block "content" [
			content-html
		])
		
		(either later-entry [django-block {nexttitle} [
			later-entry/header/title
		]] [])
		
		(either earlier-entry [django-block {prevtitle} [
			earlier-entry/header/title
		]] [])
		
		(either later-entry [django-block {nexturl} [
			url-for-entry later-entry
		]] [])
		
		(either earlier-entry [django-block {prevurl} [
			url-for-entry earlier-entry
		]] [])
	]
	
	write/lines html-file html
]

make-templates: function [
	{ Generates the django templates from the entries and indexes }

	entries [block!]
	indexes [object!]
	templates-dir [file!]
] [

	unless exists? templates-dir [
		make-dir templates-dir
	]

	;; WRITE OUT THE INDIVIDUAL ENTRIES, MAKE USE OF SORTING INFORMATION
	;; OMIT ABOUT AND CONTACT CATEGORIES FROM MAIN INDEX AND USE SPECIAL URL
	;; ALSO WRITE OUT A MAIN PAGE IN REVERSE CHRONOLOGICAL ORDER

	print "MAIN OUTPUT LOOP"

	index-html: compose [
		(django-extends %homepage.html)
			
		"{% block entries %}"
	]

	iter: entries
	while [not tail? iter] [
		entry: first iter
		earlier-entry: first next iter ;-- maybe none
		later-entry: first back iter ;-- maybe none

		either fake-category entry/header/category [
			write-entry entry none none rejoin [templates-dir stringify/dashes entry/header/category %.html]
		] [
			directory: rejoin [
				templates-dir stringify/dashes entry/header/category {/}
			]
			unless exists? directory [
				make-dir directory
			]
			
			write-entry entry earlier-entry later-entry rejoin [directory entry/header/slug %.html]
			append index-html link-to-entry entry
		]

		iter: next iter
	]

	append index-html "{% endblock entries %}"
	write/lines rejoin [templates-dir %index.html] index-html



	;; GENERATE THE TAG LIST AND A PAGE FOR EACH TAG

	print "TAG OUTPUT"
	tag-list-html: compose [
		(django-extends %taglist.html)

		(django-block/inline "title" [
			{All Tags}
		])
		
		(django-block/inline "header" [
			{All Tags for Realityhandbook.org}
		])

		(django-path [
			{<li><span> Tag List </span></li>}
		])
		
		"{% block tags %}"
	]

	foreach [tag entries] indexes/tag-to-entries [
		directory: to file! rejoin [templates-dir %tags/]
		if (not exists? directory) [
			make-dir directory
		]
		append tag-list-html link-to-tag/count tag length? entries
		
		tag-html: compose [
			(django-extends %tag.html)

			(django-block/inline "title" [
				rejoin [{tag:} space stringify tag]
			])

			(django-block/inline "header" [
				stringify tag
			])
		
			(django-path [
				{<li><a href="http://realityhandbook.org/tag/" title="Tag List">Tag</a></li>}
				rejoin [{<li><span>} stringify tag {</span></li>}]
			])
			
			"{% block entries %}"
		]
		
		foreach entry entries [
			unless fake-category entry/header/category [
				append tag-html link-to-entry entry
			]
		]
		
		append tag-html "{% endblock entries %}"
		write/lines rejoin [directory stringify/dashes tag ".html"] tag-html
	]

	append tag-list-html "{% endblock tags %}"
	write/lines rejoin [templates-dir %tags.html] tag-list-html


	;; GENERATE THE CHARACTER LIST AND A PAGE FOR EACH CHARACTER

	print "CHARACTER OUTPUT"
	character-list-html: compose [
		(django-extends %characterlist.html)

		(django-block/inline "title" [
			{Character List}
		])

		(django-block/inline "header" [
			{Character List}
		])

		(django-path [
			{<li><span> Character List </span></li>}
		])

		"{% block characters %}"
	]

	foreach [character entries] indexes/character-to-entries [
		directory: to file! rejoin [templates-dir %characters/]
		unless exists? directory [
			make-dir directory
		]
		append character-list-html link-to-character/count character length? entries
		
		character-html: compose [
			(django-extends %character.html)

			(django-block/inline "title" [
				rejoin [{character:} space stringify character]
			])
			
			(django-block/inline "header" [
				stringify character
			])
			
			(django-path [
				{<li><a href="http://realityhandbook.org/character/" title="Character List">Character</a></li>}
				rejoin [{<li><span>} stringify character {</span></li>}]
			])
			
			"{% block entries %}"
		]
		
		foreach entry entries [
			unless fake-category entry/header/category [
				append character-html link-to-entry entry
			]
		]
		
		append character-html "{% endblock entries %}"
		write/lines rejoin [directory stringify/dashes character ".html"] character-html
	]

	append character-list-html "{% endblock characters %}"
	write/lines rejoin [templates-dir %characters.html] character-list-html



	;; WRITE OUT CATEGORY PAGES

	print "CATEGORY OUTPUT"
	category-list-html: compose [
		(django-extends %categorylist.html)

		(django-block/inline "title" [
			{All Categories for Realityhandbook.org}
		])
		
		(django-block/inline "header" [
			{Category List}
		])

		(django-path [
			{<li><span>Category List</span></li>}
		])
		
		"{% block categories %}"
	]

	foreach [category entries] indexes/category-to-entries [
		if fake-category category [
			continue
		]

		directory: to file! rejoin [templates-dir %categories/]
		unless exists? directory [
			make-dir directory
		]
		append category-list-html link-to-category/count category length? entries
		
		category-html: compose [
			(django-extends %category.html)
			
			(django-block/inline "title" [
				rejoin [{category:} space stringify category]
			])
			
			(django-block/inline "header" [
				stringify category
			])
			
			(django-path [
				{<li><a href="http://realityhandbook.org/category/" title="Category">Category</a></li>}
				rejoin [{<li><span>} stringify category {</span></li>}]
			])

			"{% block entries %}"
		]
		
		foreach entry entries [
			append category-html link-to-entry entry
		]
		
		append category-html "{% endblock entries %}"
		write/lines rejoin [directory stringify/dashes category ".html"] category-html
	]

	append category-list-html "{% endblock categories %}"
	write/lines rejoin [templates-dir %categories.html] category-list-html
]