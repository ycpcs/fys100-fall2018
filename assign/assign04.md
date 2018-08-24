---
layout: default
title: "Assignment 4: Music composition"
---

Due dates:

* Draft of essay due **Friday, Oct 13th** by 11:59 PM
* Final essay and code due **Thursday, Oct 26th** by 11:59 PM

# Learning goals

* Create a music composition using a Processing sketch
* Assess your composition critically
* Reflect on the process of creating your composition
* Write about your composition, expressing the ways in which your composition succeeded, and the ways in which it could be improved

# Getting started

Start Processing.  You should see an empty Processing window.  Copy and paste the following code into the window:

{% highlight java %}
import io.github.daveho.funwithsound.*;

FunWithSound fws = new FunWithSound(this);

// Directory where you keep your soundfonts
String SOUNDFONTS = "C:/SoundFonts";

String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";

class MyComp extends Composer {
  void create() {
    tempo(110, 4);
    major(60);

    // Create instruments
    Instrument drumkit = percussion(TR808);

    // Create rhythms, melodies, and figures
    Rhythm kickr = r(p(0), p(1), p(2), p(3));
    Figure kickf = pf(kickr, 36, drumkit);

    // Schedule figures to be played
    add1(gf(kickf));
    add1(gf(kickf));
  }
}

MyComp c = new MyComp();

void setup() {
  size(600,200);
  textSize(32);
  fill(0);
  text("Click to start playing", 125, 140); 
  c.create();
}

void draw() {
}

void mouseClicked() {
  fws.play(c);
}
{% endhighlight %}

Choose **File &rarr; Save As...**.  Make sure that your sketchbook folder (`H:/My Documents/Processing`) is selected as the folder.)  In the **Selection** text box, enter **MusicComposition**.  Click **OK**.

Congratulations!  You have created a Processing sketch called **MusicComposition**.

# What to do

**Important**: Please create a folder called **Assignment 4** within your shared Google Drive folder (the one you created in [Writing Assignment 0](assign00.html)), and then create/upload your deliverables for this project in the **Assignment 4** folder.

# Tasks and deliverables

## Music composition Processing sketch

Write a Processing sketch to create a music composition.  Your composition should be a continuation of the work you did in [Lab 5](../labs/lab05.html), [Lab 6](../labs/lab06.html), and [Lab 7](../labs/lab07.html).

At a minimum, your composition should include percussion figures, melodic figures, and should have an overall structure.  We would encourage you to consider adding the following optional elements:

* Using a variety of soundfonts and instrument sounds
* Samples (see [Lab 7](../labs/lab07.html))

Please note that we do not want you to treat these features as a laundry list: we expect that for any element you incorporate into the composition, you have a specific artistic motivation for including it.

Submit your sketch by uploading it to your shared Google Drive folder.  Your sketch is a file that has a ".pde" file extension.  You can upload a file to a Google Drive folder by clicking **New**, choosing **File upload**, and then selecting the file you want to upload.

<div class="callout">
<b>Important</b>: In addition to uploading the sketch code, please upload any samples that your composition uses.
</div>

## Reflective essay

Your essay should address the following topics.

*Introduction.*   What were you trying to achieve in creating your composition?  Did you have a specific inspiration?

*Describe your creative process.*  What did you do to create your composition?   How did your composition evolve over time?  What were your experiences using a computer program to create music?  What aspects of the process were satisfying?  What aspects of the process were frustrating?  If you encountered difficulties, what did you do to progress beyond them?

*Discuss the structure and organization of your composition.*  In particular, talk about the different "layers" of organization in your composition: individual rhythms and melodies, longer passages, the overall composition structure, etc.  What mood or emotions were you trying to evoke?

*In what ways did your composition succeed?*  In light of your intentions regarding the structure and organization of the composition, and the effects you were trying to convey, do you think you succeeded?

*In what ways do you think your composition could be improved?*  What aspects of the composition did not succeed in the way you had hoped?

*Conclusions.*  What did you learn from this experience?

Your reflection should be *at least* two pages in length.  (Two pages is a minimuim, and we would expect that it is more likely that three or more pages will be necessary.)  You should strive to be clear and concise.

Please read our [Effective Writing](../outcomes/writing.html) document for more information about our expectations for your writing.

# Grading criteria

The overall project is worth up to 100 points.

The Processing sketch is worth up to 40 points, and the reflection up to 60.

For the sketch:

* A basic composition will earn up to 28 points
* A more complex composition will earn up to 32 points
* Up to 8 points may be earned through the use of optional features, or through use of deliberate and effective repetition and variation throughout the composition

The essay draft is worth up to 12 points.

For the final version of the essay:

* Introduction: up to 6 points
* Discussion of creative process: up to 12 points
* Discussion of ways in which the composition succeeded: up to 12 points
* Discussion of ways in which the composition could be improved: up to 12 points
* Conclusions: up to 6 points

# Submitting

Please create a folder within your [shared Google drive folder](assign00.html) called **Assignment 4**.  (Navigate into your shared Google drive folder, click **New** and then **Folder**, and enter **Assignment 4** as the name of the folder.)

The essay draft and final version should be documents named `EssayDraft` and `EssayFinal` within your **Assignment 4** folder.

Submit your code by uploading it to your shared Google Drive folder.  Your code is a file called `MusicComposition.pde` in a folder called `MusicComposition` within your sketchbook folder.  You can upload a file to a Google Drive folder by clicking **New**, choosing **File upload**, and then selecting the file you want to upload.  Also, please upload any samples your composition uses.
