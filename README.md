chomper
=======

Random transients from a given path of mp3 path


I've always been a fan of the little patterns you get changing stations on the
radio. After getting the Akufen album My Way, I realized I wasn't the only one.

I quickly threw the tool together and started cranking out transient cuts. After
a decade, I figured I'd let others do the same.

It's ugly, but it gets the job done wonderfully.

Requires:

aubio (http://aubio.org)
lame (http://lame.sourceforge.net)


Syntax is simple:

chomper.pl 20 /path/to/mp3s

First argument is the number of files to grab.
Second is the path to the mp3s you want it to crawl recursively.
Optional third argument is the path to the destination. Default is "smpl"


Usage is simple too:

Run the utility.
Get some coffee.
Open up your favorite sampler.
Dump the contents of the 'smpl' path (or whatever you named it) into your sampler.
Enjoy!
