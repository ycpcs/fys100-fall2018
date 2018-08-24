---
layout: default
title: "Lab 6: Melodies"
---

# Learning goals

* Learn about pitches, frequencies, and scales
* Add melodic parts to a composition

# What to do

The goal for today is to start to add melodic parts to the composition you started in [Lab 5](lab05.html).

## Pitches and scales

Here is a tiny bit of music theory.

### Octaves

A note's pitch is determined by its frequency.  The higher the frequency, the higher the pitch.

An interesting auditory phenomenon occurs when you multiply a note's frequency by 2: you get a higher note that sounds "the same" as the first note, only higher:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/227054905&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Frequencies that differ by a factor of 2 are one *octave* apart.

So, what about notes within an octave?  Western music uses a 12 tone scale, meaning that there are 12 distinct pitches in each octave.  The difference between two notes is called a *semitone* or a *half step*.  So, what is the relationship between the notes within an octave?

The basic idea is that we want the notes within the scale to be separated by more or less the same difference in pitch.  Because the next higher octave involves doubling the frequency, moving to the next note involves "one-twelfth doubling" of the frequency.  The idea is that there is a factor, which, if multiplied by a note frequency, gives us the frequency of the next note, *and*, if we multiply a note frequency by the factor 12 times, we effectively double the frequency, giving us the same note at the next higher octave.

This "note multiplier", which we'll call *f*, can be computed as

> *f* = 2<sup>1/12</sup>

In other words, 2 raised to the power 1/12.  This factor is approximately 1.059.  Multiplying any note frequency by *f* gives us the frequency of the next higher note, and dividing by *f* gives us the frequency of the next lower note.  This scheme is known as [equal temperament](https://en.wikipedia.org/wiki/Equal_temperament), and in modern times is used nearly universally for instrument tuning.

Note that because equal temperament only tells us how to move between notes, we need to have one note's frequency to be specified as a constant.  The most common standard is that A4 (the note "A" in the fourth audible octave) is defined as exactly 440 Hz.  All other note frequencies are defined relative to this reference point.

### Scales

If you've ever sat down at a piano or keyboard and played random keys, you've probably noticed that it doesn't sound very good.  This is because most western music uses notes selected from a *scale*.  Typically, a scale includes exactly 7 notes (and variations in lower and higher octaves).  Scales are defined by specifying a pattern of how many semitones there are between notes, starting at the root note of the scale.  The important thing to realize about scales is that the number of semitones to reach the next note is not always 1!

A major scale uses the following pattern of semitones:

> 2, 2, 1, 2, 2, 2, 1

Here is a C major scale:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/227058130&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

A natural minor scale uses the following pattern of semitones:

> 2, 1, 2, 2, 1, 2, 2

Note how in each case, the sum of the semitone increments is 12, which makes sense, because the progression specifies how to reach the scale's root note in the next higher octave.

Here is a C minor scale:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/227058460&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Notice how the major scale sounds "happy", and the minor scale sounds "sad".

### What this means to you

You will probably want to pick a scale to use in your composition, and use notes selected from that scale.  In particular, C major and A minor are good choices, because the notes in those scales correspond exactly to the white keys on the piano keyboard.

## Example: Thieves Like Us

[Lab 5](lab05.html) included a small fragment of [New Order](https://en.wikipedia.org/wiki/New_Order_(band))'s [Thieves Like Us](https://www.youtube.com/watch?v=VVQfJ5xCpuY) as an example of percussion and bass.

Here is the code we started from:

> [Thieves.pde](https://github.com/ycpcs/fys100-fall2016/blob/gh-pages/labs/demo/lab05/Thieves.pde)

We'll continue this composition by adding melodic instruments and figures.  Thieves Like Us is a good example of 1980s dance music: 4/4 time signature, lots of syncopation in the rhythm parts, moderate tempo, repetition of simple melodic figures with a good bit of variation as the piece progresses.

Here is a link to the enhanced version:

> [Thieves2.pde](https://github.com/ycpcs/fys100-fall2016/blob/gh-pages/labs/demo/lab06/Thieves2.pde)

Let's analyze what we added.

### Synth \#1

Our original version had a break of 4 measures with just bass drum and snare.  This is actually supposed to be 8 measures, and it includes an iconic synth lead.

We'll start by creating an instrument, using patch 91 ("Pad 3 (polysynth)") in the `FLUID` soundfont:

{% highlight java %}
Instrument pad = instr(FLUID, 91); // Pad 3 (polysynth)
v(pad, 0.8); // make this a bit quieter
{% endhighlight %}

Synth "pads" generally have a "full" sound, and may sound like multiple instruments.

We define the following rhythm, melodies, and figures:

{% highlight java %}
Rhythm pad1r = r(s(0, 5), s(5, 1), s(6, .5), s(6.5, 1));
Melody pad1m = m(0,-2,3,2);
Figure pad1f = f(pad1r, pad1m, pad);

Melody pad2m = m(1, -1, 0, 1);
Figure pad2f = f(pad1r, pad2m, pad);

Melody pad3m = m(0, -2, 0, 3);
Figure pad3f = f(pad1r, pad3m, pad);
{% endhighlight %}

Notice that there is a single rhythm which is played using three distinct melodies to create three distinct figures.

We incorporate these figures into the break as follows:

{% highlight java %}
// The famous synth pad line
add1(gf(kick3f, pad1f));
add1(gf(kick3f, snaref));
add1(gf(kick3f, pad2f));
add1(gf(kick3f, snaref));
add1(gf(kick3f, pad3f));
add1(gf(kick3f, snaref));
add1(gf(kick3f, pad2f));
add1(gf(kick3f, snaref));
{% endhighlight %}

### Synth \#2

The second synth part is sort of a staccato background part that comes in behind the pad part.  I used `FLUID` with the Harpsichord patch (7):

{% highlight java %}
Instrument synth = instr(FLUID, 7); // Harpsichord, with some audio effects (delay+reverb)
v(synth, 0.15); // this should be fairly quiet
addfx(synth, new AddDelay(100, 1, .7));
addfx(synth, new AddDelay(100, 1, .6));
addfx(synth, new AddReverb());
{% endhighlight %}

Note that a few audio effects are added to the instrument, specifically delay (echo) and reverb.

Here are the rhythms, melodies, and figures:

{% highlight java %}
Rhythm synth1r = r(
  s(0, .25),
  s(.5, .25), s(.75, .25), s(1, .25),
  s(1.5, .25), s(1.75, .25), s(2, .25), s(2.25, .25), s(2.75, .25),
  s(3.5, .25), s(3.75, .5)
);
Melody synth1m = m(
  1,
  1, 1, 1,
  1, 1, 1, 2, 1,
  1, 1
);
Figure synth1f = f(synth1r, synth1m, synth);

Rhythm synth2r = r(
  s(0, .25),
  s(.5, .25), s(.75, .25), s(1, .25),
  s(1.5, .25), s(1.75, .25), s(2, .25), s(2.25, .25), s(3.5, .25), s(3.75, .25)
);
Melody synth2m = m(
  1,
  1, 1, 1,
  1, 1, 1, 2
);
Melody synth3m = m(
  1,
  1, 1, 1,
  1, 1, 1, 2, 2, 2
);
Figure synth2f = f(synth2r, synth2m, synth);
Figure synth3f = f(synth2r, synth3m, synth);
{% endhighlight %}

These are played in pairs: `synth1f` is followed by either `synth2f` or `synth3f`.  These figures are played along with the existing kick drum, snare, and hihat parts:

{% highlight java %}
// Add in the hihats, bass, and staccatto "texture" synth part
add1(gf(kickf, snare2f, hihatf, bassf, pad1f, synth1f));
add1(gf(kick2f, snare3f, hihatf, bass2f, synth2f));
add1(gf(kickf, snare2f, hihatf, bassf, pad2f, synth1f));
add1(gf(kick2f, snare3f, hihatf, bass2f, synth3f));
add1(gf(kickf, snare2f, hihatf, bassf, pad3f, synth1f));
add1(gf(kick2f, snare3f, hihatf, bass2f, synth2f));
add1(gf(kickf, snare2f, hihatf, bassf, pad2f, synth1f));
add1(gf(kick2f, snare3f, hihatf, bass2f, synth3f));
{% endhighlight %}

### Fifths lead and guitar!

After the synth parts, there are 8 measures where a "fifths" lead alternates with distorted guitar chords.

Instruments:

{% highlight java %}
Instrument fifths = instr(FLUID, 87); // Lead 7 (fifths)
v(fifths, 0.5); // make this quieter

Instrument guitar = instr(FLUID, 30); // overdriven guitar
v(guitar, 0.4);
{% endhighlight %}

Rhythms, melodies, and figures:

{% highlight java %}
Rhythm fifthsr = r(
  s(0, .5), s(.5, 1), s(1.5, 1), s(2.5, 1),
  s(4.0, .5), s(4.5, 1), s(5.5, 1), s(6.5, 1)
);
Melody fifthsm = m(3, 7, 8, 9, 3, 9, 8, 7);
Figure fifthsf = f(fifthsr, fifthsm, fifths);

Rhythm guitar1r = r(s(-.5,.5), s(0, .8), s(1, .8));
Melody guitar1m = m(n(-11, -14), n(-10, -13), n(-10, -13));
Figure guitar1f = f(guitar1r, guitar1m, guitar);

Rhythm guitar2r = r(s(-.5,.5), s(0, .5), s(.5, .5), s(1, .5));
Melody guitar2m = m(n(-10, -13), n(-10, -13), n(-11, -14), n(-10, -13));
Figure guitar2f = f(guitar2r, guitar2m, guitar);
{% endhighlight %}

Note that the start beat in the guitar rhythms is negative &mdash; the guitar figures start early (just at the end of the previous measure.)

These figures are played with the original kick drum patterns, a new snare pattern, and the original bass pattern:

{% highlight java %}
// Fifths lead
add1(gf(kickf, snare2f, hihatf, bassf, fifthsf));
add1(gf(kick2f, snare3f, hihatf, bass2f));

// Guitar
add1(gf(kickf, snare2f, hihatf, guitar1f));
add1(gf(kickf, snare2f, hihatf, guitar2f));

// Fifths lead
add1(gf(kickf, snare2f, hihatf, bassf, fifthsf));
add1(gf(kick2f, snare3f, hihatf, bass2f));

// Guitar
add1(gf(kickf, snare2f, hihatf, guitar1f));
add1(gf(kickf, snare2f, hihatf, guitar2f));
{% endhighlight %}

### Putting it all together

It sounds like this:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/285136250&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

# Your turn

Add some melodic parts to the composition you started in [Lab 5](lab05.html).

Suggestion: once you have rhythm and bass parts you are satisified with, try adding a synth pad to your composition.
