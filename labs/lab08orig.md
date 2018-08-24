---
layout: default
title: "Lab 8: Synthesis, Effects"
---

# Learning goals

* Experiment with synthesis using raw waveforms
* Experiment with audio effects

# What to do

Today you will experiment with

1. Synthesis using raw waveforms such as sine, square, and sawtooth waves
2. Audio effects such as reverb, delay, flanger, and pan

You should read the "What sound is" and "Electronic waveforms" sections.  Then follow the steps in the "Getting started" and "Experiments" sections.  Finally, the "Your turn" section describes how you can apply some of these techniques to the composition you are working on as part of [Assignment 4](assign/assign04.html).

## What sound is

<div class="callout"><b>Important</b>: Before you try playing any of the sound samples below, adjust the system volume control on the computer you are using so that it is on a low setting.</div>

Sound is caused by rapid vibrations, or *oscillations*, in physical objects.  These oscillations cause rapid changes in air pressure over time.

Sounds can be characterized by the *rate* at which the changes in air pressure occur.  For example, let's say that a vibration causes air pressure to increase and decrease at a rate of 440 changes per second: in other words, 440 times per second, the air pressure increases and then decreases.  We would describe this sound as having a *frequency* of 440 Hertz, abbreviated 440 Hz.

Sounds with lower frequencies sound "low", and sounds with higher frequencies sound "high".  The lowest frequency that we can hear is about 20 Hz, while the highest frequency we can hear is about 20,000 Hz.

The most fundamental kind of oscillation is the *sine wave*:

> ![Sine wave](../img/lab08/sinewave.png)

The diagram above is a plot of air pressure over time, where the x-axis is time, and the y-axis is pressure relative to the average air pressure.  Points above the x-axis represent air pressure higher than the current average, and points below the x-axis represent air pressure lower than the current average.

Sine waves tend to occur naturally due to the way physical objects vibrate.  A pure sine wave represents a single clear tone.  For example, here is a sample of a 440 Hz sine wave:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/225567736&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

A sound consisting of a single sine wave tends to sound very artificial because sounds arising from the vibration of physical objects tend to have *overtones*, which are vibrations occuring at a multiple of the sound's base frequency.  For example, when an instrument string vibrates, the length of the string will determine the base frequency, but overtones will occur which are twice the base frequency, three times the base frequency, four times the base frequency, etc.

Here is a sample of a 440 Hz sine wave, along with some overtones:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/225569272&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Note that in the audio sample above, the relative volume of the overtone frequencies has been lowered relative to the volume of the base frequency.

It turns out that *any* sound imaginable can be created by combining sine waves.  All of the sounds that you hear are combinations of sine waves with varying frequencies and volumes.

## Electronic waveforms

Electronic instruments, such as synthesizers and computers with sound output hardware, are not limited to creating pure sine waves.  In fact, it tends to be easier for digital devices to generate "artificial" sound waveforms.  Here are some examples of commonly-used electronic waveforms.

A square wave is characterized by abrupt transitions between low to high pressure:

> ![Square wave](../img/lab08/squarewave.png) 

Here is a sample of a 440 Hz square wave:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/225567893&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

A square wave has a more complex sound than a sine wave of the same frequency.  The shape of the waveform results in [higher frequency overtones at odd multiples of the base frequency](http://www.embedded.com/print/4015870).

Another common electronic waveform is the sawtooth wave, characterized by a linear rise and an abrupt fall in pressure during each oscillation:

> ![Sawtooth wave](../img/lab08/sawtoothwave.png)

Here is a sample of a 440 Hz sawtooth wave:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/225567809&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

Again, the sawtooth wave has a more complex sound than a sine wave of the same frequency.

A triangle wave is like a sawtooth wave, except rather than having an abrupt fall, the fall is linear:

> ![Triangle wave](../img/lab08/trianglewave.png)

Here is a sample of a 440 Hz triangle wave:

> <iframe width="600" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/225567949&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe>

The sound of a triangle wave is similar to a square wave.

## Getting started

Start Processing.

Copy the code from the following sketch into an empty sketch:

> [Synthesis.pde](https://github.com/ycpcs/fys100-fall2016/blob/gh-pages/labs/demo/lab08/Synthesis.pde)

## Experiments

Run the sketch.

If you click the mouse somewhere in the window, you should hear a metronome pattern.

While the rhythm pattern is playing, you can use the following keyboard keys to play notes:

> ![Keyboard keys to play notes](https://raw.githubusercontent.com/wiki/daveho/FunWithSound/img/p5keys.png)

Note that you can only play notes from one octave: the current octave is highlighted in green in the picture of the piano keyboard you see in the window.  You can use the up and down arrow keys to move the current octave higher or lower.

Now you can try some experiments!  If you scroll down to the bottom of the Processing code, you will see a method called `registerCustomInstruments`.  This method configures FunWithSound to play notes using the basic waveforms described earlier.  You will see comments labeled "Custom instrument 0", "Custom instrument 1", "Custom instrument 2", etc.  Some of the experiments will involve changing these instrument definitions to produce different sounds.  Also, note how there are comments such as

{% highlight java %}
// <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
{% endhighlight %}

on some lines of code.  These comments highlight changes you can make to change the note sounds.

Note: if you change the code, you will need to restart the sketch in order for your changes to take effect.

### Experiment 1: Basic synth sounds

Find the section of `registerCustomInstruments` that defines custom instrument 0.  Note how the code uses `Buffer.SINE`.  This causes notes to be played as a sine wave.  Try changing this as described in the comment to use square, sawtooth, and triangle waves.  Which waveform is your favorite?

### Experiment 2: Using a note envelope

One thing that you will notice about custom instrument 0 is that the note sounds turn on and off very abruptly.  Rapid changes in volume tend to produce a clicking or popping sound.  These pops can be avoided by playing the notes with an *envelope*.  When a note envelope is used, notes start playing with a rise in volume over a specified *attack time*, and stop playing with a lowering of volume over a specified *release time*.

Towards the top of the program, change the line

{% highlight java %}
Instrument synth = custom(0); // <-- change this to select among the custom instruments
{% endhighlight %}

to

{% highlight java %}
Instrument synth = custom(1); // <-- change this to select among the custom instruments
{% endhighlight %}

Try restarting the program and playing some notes.  Note how the notes sound more natural.

In the section of `registerCustomInstruments` that defines custom instrument 1, you can adjust the attack time and release time parameters to change the note envelope.  These times are specified in milliseconds: for example, 100 milliseconds is one tenth of one second.

### Experiment 3: Portamento

*Portamento* describes the effect of "gliding" from note to note by changing the sound frequency somewhat gradually.  Using custom instrument 1, try changing the glide time parameter to a value other than 0.  The glide time is specified in milliseconds.  Suggestion: try values such as 40, 80, 100, and 200.

### Experiment 4: Overtones

Most "natural" sounds consist of multiple simultaneous frequencies.  You can change custom instrument 2 to define multiple frequencies to sound each time a note is played.  Look for the following lines:

{% highlight java %}
new double[]{ 1.0, 1.5, 2.0 }, // <-- try changing the multiples, adding new multiples
new double[]{ 1.0, 0.5, 0.25 } // <-- try changing the gains (volumes)
{% endhighlight %}

The numbers in the first line define multiples of the base note frequency.  The values 1.0, 1.5, and 2.0 correspond to the base note frequency, one and a half times the note frequency, and twice the note frequency.

The numbers in the first line define the "gains" of each frequency multiple.  1.0 means full volume, while 0.0 means complete silence.

By combining frequencies at different volumes, you can change the note sound considerably.  Try other combinations of frequency multiples and gains.  For example, try the multiples .5, 1.0, and 2.0.  Try "random" multiples, for example, 1.0, 1.89, and 2.354.  Note that you can have more than three multiples and gains, but you should always have the same number of multiples and gains.

Make sure that you try different waveforms (including square, saw, and triangle).

### Experiment 5: Effects

Another way to change the sound of a synthesized instrument is to add *effects*.  Here are some effects you can try.

*Reverb* is an effect that simulates sound bouncing around inside a large space.  To use reverb, remove the `//` comment marker from the following, towards the top of the program where the instrument is defined:

{% highlight java %}
//addfx(synth, new AddReverb()); // <-- uncomment this line to add reverb
{% endhighlight %}

After removing the comment marker, it should look like this:

{% highlight java %}
addfx(synth, new AddReverb()); // <-- uncomment this line to add reverb
{% endhighlight %}

Try playing some notes with the reverb effect.

FunWithSound allows multiple effects to be added to the same instrument.  Here are some other effects you can try, individually, or in combination:

{% highlight java %}
// Flanger effect
addfx(synth, new AddFlanger());

// Delay effect: creates a clear "echo" of the played sound
addfx(synth, new AddDelay(400.0, 1.0, 0.6)); // 400ms delay, delayed echo at 60% volume

// Chained delays: create multiple echoes
addfx(synth, new AddDelay(400.0, 1.0, 0.6));
addfx(synth, new AddDelay(800.0, 1.0, 0.5));
addfx(synth, new AddDelay(1200.0, 1.0, 0.4));

// Autopan effect: pan the sound between left and right channels
addfx(synth, new AddAutoPan(.5, -.8, .8)); // .5 Hz (one full pan every 2 seconds), 80% stereo separation

// Ping pong stereo delays: create echoes that alternate between
// left and right channels
DataBead ppdParams = Defaults.pingPongStereoDelayDefaults();
ppdParams.put(ParamNames.NUM_DELAYS, 4); // number of delays
ppdParams.put(ParamNames.DELAY_MS, 250); // number of milliseconds between delays
addfx(synth, new AddPingPongStereoDelays(ppdParams));
{% endhighlight %}

# Your turn

You can use custom synthesis instruments and/or audio effects in your sketch for [Assignment 4](../assign/assign04.html).  Here's how.

First, find the line of code at the top of your sketch reading:

{% highlight java %}
import io.github.daveho.funwithsound.*;
{% endhighlight %}

Add the following two lines just below it:

{% highlight java %}
import net.beadsproject.beads.core.*;
import net.beadsproject.beads.data.*;
{% endhighlight %}

Next, find the line of code reading:

{% highlight java %}
FunWithSound fws = new FunWithSound(this);
{% endhighlight %}

Change it to the following:

{% highlight java %}
FunWithSound fws = new FunWithSound(this) {
  protected Player createPlayer() {
    Player player = super.createPlayer();
    registerCustomInstruments(player);
    return player;
  }
};
{% endhighlight %}

Finally, add the following function to the end of your sketch (warning, there's quite a bit of code):

{% highlight java %}
void registerCustomInstruments(Player player) {
  // The code below defines the characteristics of the custom instruments.
  // Comments indicate where you can make changes.
  
  CustomInstrumentFactory factory = new CustomInstrumentFactoryImpl(
    // Custom instrument 0: plays simple wave forms with a single frequency,
    // using a simple on/off envelope
    0, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 0.0f);
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withOnOffNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0 },
          new double[]{ 1.0 }
          );
        return new RealizedInstrument(u, ac);
      }
    },
    
    // Custom instrument 1: simple waveforms with a single frequency,
    // but with an attack/sustain/release envelope
    1, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 0.0); // <-- try increasing this for portamento
        params.put(ParamNames.ATTACK_TIME_MS, 10.0); // <-- change the attack time
        params.put(ParamNames.RELEASE_TIME_MS, 80.0); // <-- change the release time
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withASRNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0 },
          new double[]{ 1.0 }
          );
        return new RealizedInstrument(u, ac);
      }
    },
    
    // Custom instrument 2: simple wave forms with multiple frequencies,
    // with attack/sustain/release envelope
    2, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 40.0);
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withASRNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0, 1.5, 2.0 }, // <-- try changing the multiples, adding new multiples
          new double[]{ 1.0, 0.5, 0.25 } // <-- try changing the gains (volumes)
          );
        return new RealizedInstrument(u, ac);
      }
    }
    
    );
  player.setCustomInstrumentFactory(factory);
}
{% endhighlight %}

Once you've made these changes, you can define custom instruments exactly as described above in the "Experiments" section.

Try adding a custom synthesizer and some effects to your composition.
