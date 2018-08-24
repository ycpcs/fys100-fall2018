---
layout: default
title: "Lab 7: Sample playback"
---

# Learning goals

* Learn how to incorporate sample playback into a composition

# What to do

Your task is to experiment with sample playback.

You will need one or more 44.1 KHz WAV audio clips (mono or stereo).

The steps are:

* Use the `samplePlayer` method to create a sample player instrument
* Create rhythms, melodies, and figures for your sample player instrument, and use them in your composition

I would suggest starting out with a single sample (played in its entirety), and then find places to add other samples (possibly using partial samples.)

See the *Example* section below for ideas.

## Example

Samples &mdash; prerecorded audio clips taken from other sources &mdash; are a standard element of many genres of electronic music.

To incorporate samples into your composition, you just need to use a sample player instrument, created using the `samplePlayer` method.  Then, add samples to the sample player instrument.  Each sample is associated with a note number.  Unlike melodic instruments, where the note number indicates pitch, and percussion instruments, where the note number selects a percussion sound, notes for sample player instruments simply indicate what sample to play.

Let's start with a very simple percussion and bass composition.  Here is some code (to put in the sketch's `create` method) to create some simple drum and bass parts:

{% highlight java %}
// Set up a percussion instruments for building a rhythm pattern
Instrument drumkit = percussion(FLUID);

// Nice synth bass sound
Instrument bass = instr(VDW, 4);
v(bass,0.6); // make the bass a bit quieter

Rhythm dr = r(p(0,127), p(1.5,101), p(2,127), p(4,127), p(5.5,101), p(6,127));
Melody dm = m(an(36), an(36), an(39), an(36), an(36), an(39));
Figure df = f(dr, dm, drumkit);

Rhythm hr = r(
  p(.5,101), p(1,101), p(1.5,101), p(2,101), s(2.5,1.5,101),
  s(6,.5,101), s(6.5,1,101), s(7,.5,101)
);
Melody hm = m(
  an(42), an(42), an(42), an(42), an(46),
  an(44), an(46), an(44)
);
Figure hf = f(hr, hm, drumkit);

Rhythm bassr = r(
  s(0,0.5,106), s(2,0.5,110), s(2.5,0.5,106), s(3,0.5,110),
  s(4,0.5,118), s(6,0.5,110), s(6.5,0.5,106), s(7,0.5,110));
Melody bassm = m(
  an(40), an(40), an(50), an(40), an(40), an(40), an(50), an(40));
Figure bassf = f(bassr, bassm, bass);

add1(gf(df,hf));
add1(gf(df,hf));
add1(gf(df,hf,bassf));
add1(gf(df,hf,bassf));
add1(gf(df,hf,bassf));
add1(gf(df,hf,bassf));
{% endhighlight %}

Here's how it sounds:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/228416171&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Now, we need a sample.  I used a brief clip from a [1950s instructional film](https://www.youtube.com/watch?v=ofgiyoKsIEA).  Here's the clip:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/228416624&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

You can download this clip from the following link:

> [knowtherules.wav](https://drive.google.com/a/ycp.edu/file/d/0Bz83qbgNYuDXMlZPZnZsX0tjMVk/view?usp=sharing)

Note that you will need to be logged into your YCP account to access this download.

I saved this clip in a folder called `Samples` in the same place as my `SoundFonts` folder.  My sketch defines a `SAMPLE_DIR` variable that serves the same purpose as the `SOUNDFONT_DIR` variable, to locate files (in this case samples) needed to play the composition:

{% highlight java %}
final String SAMPLE_DIR = "H:/Samples";
{% endhighlight %}

You should create your own sample folder &mdash; for example, on your `H:` drive, as shown above &mdash; and define a `SAMPLE_DIR` variable similar to the one shown above.

Once you have one or more sample files stored in your sample folder, you can create a sample player instrument.  Here is the one I will use:

{% highlight java %}
// Sample player
Instrument sp = samplePlayer();
sp.addSample(0, SAMPLE_DIR + "/youtube/knowtherules.wav", .4); // the entire sample
sp.addSample(1, SAMPLE_DIR + "/youtube/knowtherules.wav", 1494, 2654, .4); // "know the rules"
sp.addSample(2, SAMPLE_DIR + "/youtube/knowtherules.wav", 778, 1399, .4); // "one of us"
sp.addSample(3, SAMPLE_DIR + "/youtube/knowtherules.wav", 1822, 2457, .4); // "the rules"
sp.addSample(4, SAMPLE_DIR + "/youtube/knowtherules.wav", 1494, 1850, .4); // "know"
sp.addSample(5, SAMPLE_DIR + "/youtube/knowtherules.wav", 89, 810, .4); // "it's up to each"
{% endhighlight %}

Here is what is going on:

* Note 0 plays the entire sample, using .4 as the "gain" (volume)
* Notes 1&ndash;5 play parts of the overall sample, indicated by a range of milliseconds (start and end), again using .4 gain

So, my sample player defines a total of 6 "notes".

Let's start out by adding a very simple figure to play the entire sample:

{% highlight java %}
// figure to play the entire sample: it's about 2 measures long
Rhythm sampr = r(p(0));
Melody sampm = m(an(0));
Figure sampf = f(sampr, sampm, sp);
{% endhighlight %}

Let's play this along with the drum figures (but not the bass figure):

{% highlight java %}
add1(gf(df,hf,sampf));
add1(gf(df,hf));
add1(gf(df,hf,sampf));
add1(gf(df,hf));
{% endhighlight %}

Here's how it sounds:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/228417950&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Playing an entire sample is fun, but we can have even more fun if we play only parts of the samples.  One possibility is to play part of a sample repeatedly, creating a "stuttering" effect.  Another possibility is to mix up the sample by playing parts of it in a different order.  Here are a few figures that demonstrate both techniques:

{% highlight java %}
// "stutter" figure with just "know the rules" repeated several times
Rhythm samp2r = r(p(0),p(1),p(2),p(3),p(4));
Melody samp2m = m(an(1),an(1),an(1),an(1),an(1));
Figure samp2f = f(samp2r, samp2m, sp);

// faster "stutter" figure
Rhythm samp3r = r(p(0),p(.5),p(1),p(1.5),p(2),p(2.5),p(3),p(3.5), p(4));
Melody samp3m = m(an(1),an(1),an(1),an(1),an(1),an(1),an(1),an(1),an(1));
Figure samp3f = f(samp3r, samp3m, sp);

// mismash of various parts of the sample, re-arranged
Rhythm samp4r = r(p(0),p(1.5), p(2.5),p(4),p(5.5), p(6.5));
Melody samp4m = m(an(3),an(4), an(5),an(3),an(4), an(5));
Figure samp4f = f(samp4r, samp4m, sp);
{% endhighlight %}

Recall that the sample player "notes" 1&ndash;5 indicate parts of the overall sample.

Let's play these new figures:

{% highlight java %}
add1(gf(df,hf,samp2f));
add1(gf(df,hf,samp2f));
add1(gf(df,hf,samp2f));
add1(gf(df,hf,samp2f));
add1(gf(df,hf,bassf,samp3f));
add1(gf(df,hf,bassf,samp3f));
add1(gf(df,hf,bassf,samp3f));
add1(gf(df,hf,bassf,samp3f));
add1(gf(df,hf,bassf,samp4f));
add1(gf(df,hf,bassf,samp4f));
add1(gf(df,hf,bassf,samp4f));
add1(gf(df,hf,bassf,samp4f));
{% endhighlight %}

Putting it all together, here is the overall composition:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/228419116&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Here is the complete code for the sketch:

> [SamplePlayback.pde](https://github.com/ycpcs/fys100-fall2016/blob/gh-pages/labs/demo/lab07/SamplePlayback.pde)
