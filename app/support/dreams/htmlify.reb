REBOL [
	Title: "HTMLify"
	Date: 20-Oct-2010
	Author: "Hostile Fork"
	Type: 'module
	Exports: [htmlify]
]


space: " "

stringify: func [word [set-word! word! file!] /dashes] [
	either dashes [
		to string! word
	] [
		replace/all to string! word "-" space
	]
]

dream-markup: funct [block [block!]] [
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

htmlify: funct [
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
][
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