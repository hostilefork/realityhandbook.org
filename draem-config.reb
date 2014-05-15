Rebol []

draem/set-config object compose [
	site-url: http://realityhandbook.org/
	site-name: "Reality Handbook"
	site-title: {realityhandbook.org - Official Homepage of a Skilled Lucid Dreamer}
	site-tagline: {Extraordinary Lucid Dream Reports}
	site-author: {&AElig;}

	rss-tag: {realityhandbook.org}

	site-prologue-html: {<div style="margin-right: 8px; text-align: right;"><p><img src="http://realityhandbook.org/media/feed-icon-14x14.png" alt="Feed Icon" /> <a href="http://realityhandbook.org/feed/">RSS 1.0 XML Feed </a> available</p></div>}

	site-intro: [

		{This site is mostly about my dreaming life. I consistently become aware that I'm dreaming while still asleep, having nearly the full presence of mind I have while awake. I write down some of the conversations and experiments that I perform in this state--and there are literally [hundreds of these logs](http://realityhandbook.org/tag/lucid-dream/) here!}

		[note {Since that's a daunting amount of material, I've [excerpted some example experiences](http://realityhandbook.org/about/#examples) you might want to look at. If you wish, you can instead jump straight to the [complete list of entries](#entries), or [browse by a growing selection of tags](http://realityhandbook.org/tag/). There are also [open letters](http://realityhandbook.org/tag/open-letter/), [essays](http://realityhandbook.org/tag/essay/), and other writing stored on this site.}]

		[heading {"Wow...really?"}]

		{Yes, really! In scientific parlance, what I do is called [lucid dreaming](http://en.wikipedia.org/wiki/Lucid_dreaming). Enough people have done it "on command" in laboratories that it has been proven to be possible. If you are interested in the peer-reviewed experiments where sleeping people have demonstrated this ability to scientists, you should read up on the very interesting work of [Dr. Stephen LaBerge](http://en.wikipedia.org/wiki/Stephen_LaBerge) at Stanford University.}

		{Let me be abundantly clear: I don't do drugs, and this is not a joke project for a sci-fi writer. I am a software developer and a devout supporter of critical thinking. My documentation here is for science, and the accounts are here to be studied as data. (Since we can't yet video-record the dreamworld the reports are naturally going to be a bit fuzzy. I've tried to be as accurate as possible while adopting a readable script-like format.)}

		[heading {"So why are you noteworthy?"}]

		{Given that I just pointed out that lucid dreaming is a 'known' phenomenon, you might ask what the big deal is. Here are the points as I see it:}

		[list

		    {My emphasis is not on bending the dream-world to my will. Instead I try to interview the characters I meet, and carefully filter preconceptions which might influence what I "hear". The things they "say" aren't always nice--but are far more surprising, original, and coherent than most lucid dreamers report.}

		    {I'm often able to accurately relate facts while asleep; this includes the current date, recent news events, or where my body is sleeping. When I find an Internet terminal I'll deliberately try searches on myself or other topics, while fully aware that it is the "dream-Internet".}

		    {I did not intentionally pursue lucid dreaming, nor do I use any machines to try to induce them. They involuntarily happen several times a night, and can last for several minutes or longer. I document them when they are particularly interesting and my schedule permits it.}

		    {There are absolutely no "self-help" books or "psychic services" that I have to sell. To keep things on the up-and-up I'm never going to advertise on this site either.}

		]

		{I am eager to engage any sleep-research lab that wants to study me. I believe that atypical individuals can serve as linchpins in the understanding of our minds and our reality (such as [Daniel Tammet](http://realityhandbook.org/open-letter/daniel-tammet/)). I also hold some hope that search engines and archiving will give us tools that history did not have in understanding if these dreams are actually a form of communication through an as-yet-unknown mechanism.}

		{Please do not hestitate to [contact me](http://realityhandbook.org/contact/), unless you are a scary interdimensional dream monster.  In which case, hesitate.  :-)}

		[heading {Master List of Entries} %entries]
	]

	google-analytics: [
		property: "realityhandbook.org"
		tracking-id: "UA-47676109-1"
	]

	site-footer: [
		{Currently I am experimenting with using Disqus for comments, however it is configured that you don't have to log in or tie it to an account.  Simply check the "I'd rather post as a guest" button after clicking in the spot to type in a name.}

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
}]
	]

	site-trailer-html: {<div style="text-align: right;"><span>
		copy write %C:/0304-1020 {Met^^(00C6)ducation}</span></div>}

	; This is made long to work around the page width issue where we set a
	; maximum-width but no minimum-width.  In order to make sure we are
	; taking advantage of a natural device width a relatively long string
	; here that will break is a fairly natural fit.
	site-epilogue-html: {
		<div style="text-align: center;"><p>
		The accounts written here are as true as I can manage.  While the
		words are my own, they are not independent creative works of fiction
		&mdash;in any intentional way.  Thus I do not consider the material to
		be protected by anything, other than that you'd have to be
		crazy to want to try and use it for genuine purposes (much less
		disingenuous ones!)  But who's to say?</p></div>}

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

