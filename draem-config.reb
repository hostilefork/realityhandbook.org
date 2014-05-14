Rebol []

draem/set-config object compose [
	site-url: http://realityhandbook.org/
	site-name: "Reality Handbook"
	site-title: {realityhandbook.org - Official Homepage of a Skilled Lucid Dreamer}
	site-tagline: {Extraordinary Lucid Dream Reports}
	site-author: {&AElig;}

	rss-tag: {realityhandbook.org}

	site-prologue: [
		[html {<div style="text-align: right;"><p><img src="http://realityhandbook.org/media/feed-icon-14x14.png" alt="Feed Icon" /> <a href="http://realityhandbook.org/feed/">Atom 1.0 Feed</a> available &nbsp; <i>(<a href="http://en.wikipedia.org/wiki/RSS">what's this?</a>)</i></p></div>}]
	]

	site-intro: [
		{realityhandbook.org documents the literally hundreds of lucid dreams
		of a scientifically-minded individual--unwittingly cast into the role
		of amateur interviewer and experimenter. To learn more, please
		read [http://realityhandbook.org/about/](http://realityhandbook.org/about/)}
		
		divider

		[html {<p>In addition to the master list below, you can browse the entries
		by <a href="{% url 'draems.views.tag_list' %}">tag</a>.  Two early 
		experimental features I've added are browsing by 
		<a href="{% url 'draems.views.character_list' %}">character</a> or with
		a <a href="{% url 'draems.views.timeline' %}">timeline</a>.  I
		appreciate your feedback or suggestions, so do not hesitate to
		<a href="http://realityhandbook.org/contact/">contact me</a>!</p>}]
	]

	google-analytics: [
		property: "realityhandbook.org"
		tracking-id: "UA-47676109-1"
	]

	site-footer: [
		[note {Currently I am experimenting with using Disqus for comments,
		however it is configured that you don't have to log in or tie it to an
		account.  Simply check the "I'd rather post as a guest" button
		after clicking in the spot to type in a name.}]

		[html {
	<div id="disqus_thread"></div>
	    <script type="text/javascript">
	        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
	        var disqus_shortname = 'realityhandbook'; // required: replace example with your forum shortname

	        /* * * DON'T EDIT BELOW THIS LINE * * */
	        (function() {
	            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
	            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
	            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
	        })();
	    </script>
	    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
	    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
    
	<img src="/media/1020ae0304.png" alt="It will be already always was." />
}]
	]

	; This is made long to work around the page width issue where we set a
	; maximum-width but no minimum-width.  In order to make sure we are
	; taking advantage of a natural device width a relatively long string
	; here that will break is a fairly natural fit.
	site-epilogue: [
		[html {<div style="text-align: center;"><p>
		copy write %C:/0304-1020 {Met^^(00C6)ducation}</p>
		<p>The accounts written here are as true as I can manage.  While the
		words are my own, they are not independent creative works of fiction
		&mdash;in any intentional way.  Thus I do not consider the material to
		be protected by anything, other than that you'd have to be
		crazy to want to try and use it for genuine purposes (much less
		disingenuous ones!)  But who's to say?</p></div>}
		]
	]

	javascript: [
		http://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js
		
		{
/* http://stackoverflow.com/questions/1402698/binding-arrow-keys-in-js-jquery */
$(document).keydown(function(e) {
	switch(e.which) {
		case 37: // left (up is 38) 
			anchors = $("#prev > a");
			if (anchors.length > 0) {
				window.location.href = anchors.eq(0).attr('href');
			}
		break;

	case 39: // right (down is 40)
			anchors = $("#next > a");
			if (anchors.length > 0) {
				window.location.href = anchors.eq(0).attr('href');
			}
		break;

	default: return; // exit this handler for other keys
	}

	e.preventDefault(); // prevent the default action (scroll / move caret)
});
		}
	]

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

