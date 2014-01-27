Rebol []

draem/set-config object compose [
	site-url: http://realityhandbook.org/
	site-name: "Reality Handbook"
	site-title: {realityhandbook.org - Official Homepage of a Skilled Lucid Dreamer}
	site-tagline: {Extraordinary Lucid Dream Reports}

	site-intro: {
		<p>realityhandbook.org documents the literally hundreds of lucid dreams of a scientifically-minded individual—unwittingly cast into the role of amateur interviewer and experimenter. To learn more, please read <a href="http://realityhandbook.org/about/">http://realityhandbook.org/about/</a>
		<hr />
		<p>In addition to the master list below, you can browse the entries by <a href="{% url draems.views.tag_list %}">tag</a>.  Two early experimental features I've added are browsing by <a href="{% url draems.views.character_list %}">character</a> or with a <a href="{% url draems.views.timeline %}">timeline</a>.  I appreciate your feedback or suggestions, so do not hesitate to <a href="http://realityhandbook.org/contact/">contact me</a>!</p>
	}

	site-footer: {
	<div style="text-align: center;"><p>Please subscribe to the <img src="/media/feed-icon-14x14.png" alt="Feed Icon" /> <a href="http://realityhandbook.org/feed/">Atom 1.0 Feed</a> or use <img src="/media/feedburner-icon-14x14.png" alt="Feedburner Icon" /> <a href="http://feeds.feedburner.com/realityhandbook">Feedburner</a> to receive updates as they are posted!!</p></div>
	<img src="/media/1020ae0304.png" alt="It will be already always was." />
	}

	valid-categories: [
		;-- "real" categories; pages are indexed
		essay
		lucid-dream
		non-lucid-dream
		open-letter
		misc
		hypnosis
		guest-dream
	]

	site-toplevel-slugs: [
		%about
		%contact
	]

	;-- Optional header-checking hook
	check-header: function [header [object!]] [
		if find [lucid-dream non-lucid-dream] header/tags [ 
			unless any [
				find header/tags 'neutral
				find header/tags 'positive
				find header/tags 'negative
			] [
				probe header/tags
				throw make error! "Dreams must be tagged neutral, positive, or negative"
			]
		]

		unless find site-toplevel-slugs header/slug [
			if 1 <> length? intersect valid-categories header/tags [
				print "Tags must contain one of the categories!"
			]
		]
	]

	file-from-header: function [header [object!]] [
		either find site-toplevel-slugs header/slug [
			header/slug
		] [
			category: intersect valid-categories header/tags
			assert [1 == length? category] 
			to file! rejoin [
				stringify/dashes first category
				{/}
				header/slug
			]
		]
	]

	;-- Required url-from-header hook
	url-from-header: function [header [object!]] [
		rejoin [site-url (file-from-header header) %/]
	]

	entries-dir: (rejoin [system/options/path %entries/])
	templates-dir: (rejoin [system/options/path %templates/])

	file-for-template: function [header [object!]] [
		rejoin [templates-dir (file-from-header header) ".html"]
	]
]

