---
layout: default
title: "Assignment 3: Visual Art"
---

Due dates:

* Outline of essay due **Friday, Sept 15th** by 11:59 PM
* Draft of essay due **Thursday, Sept 21st** by 11:59 PM
* Final essay and code due **Thursday, Oct 5th** by 11:59 PM

# Learning goals

* Create a visual art composition using a Processing sketch
* Assess your composition critically
* Reflect on the process of creating your composition
* Write about your composition, expressing the ways in which your composition succeeded, and the ways in which it could be improved

# Getting started

Start Processing.  You should see an empty Processing window.  Copy and paste the following code into the window:

{% highlight java %}
void setup() {
  size(800, 600);
  background(255);
  noLoop();
}

void draw() {
  fill(255);
  stroke(0);
  strokeWeight(1);
  
  // TODO: add drawing operations
}
{% endhighlight %}

Choose **File &rarr; Save As...**.  Make sure that your sketchbook folder (`H:\My Documents\Processing`) is selected as the folder.)  In the **Selection** text box, enter **VisualArtProject**.  Click **OK**.

Congratulations!  You have created a Processing sketch called **VisualArtProject**.

# Tasks and deliverables

## Visual art Processing sketch

Write a Processing sketch to create a visual art composition.  Your composition should build upon the work you did in [Lab 1](../labs/lab01.html), [Lab 2](../labs/lab02.html), [Lab 3](../labs/lab03.html), and [Lab 4](../labs/lab04.html).

Your composition may use any theme, but we respectfully ask you to avoid any image or theme that might be offensive.

We encourage you to use the following optional features in your composition:

* Repeated elements (see [Lab 2](../labs/lab02.html))
* Animated elements (see [Lab 3](../labs/lab03.html))
* Generative elements such as fractals (see [Lab 4](../labs/lab04.html))

Be creative!  There is no right or wrong way to create art.  The important thing is to experiment.  Come up with ideas, try them out, see if they work, and repeat.

**Extremely important**: The goal of this assignment is to create a work of visual art.  Your primary concerns are coming up with a concept, using Processing to realize the concept, and then reflecting critically on your creation.  Be prepared to explain your creative process.

## Reflective essay

Your essay should address the following topics.

*Introduction.*  How did you come up with the theme? What were you trying to achieve in creating your composition?

*Describe your creative process.*  What did you do to create your composition?   How did your composition evolve over time?  What were your experiences using a computer program to create visual art?  What aspects of the process were satisfying?  What aspects of the process were frustrating?

*In what ways did your composition succeed?*  What do you think worked out well in your composition?  How closely did the end product correspond to your original concept?

*In what ways do you think your composition could be improved?*  What aspects of the composition did not succeed in the way you had hoped?

*Conclusions.*  What did you learn from this experience?

The first version of the essay will be an outline, saved in a document called `EssayOutline`.  Please read our comments on [how to make an outline](../outcomes/outline.html).

The second version of the essay will be a draft, saved in a document called `EssayDraft`.  Make sure the draft follows the structure of the outline, and that you take into account any feedback we give you on the outline.

The final version of the essay should be saved in a document called `EssayFinal`.  Make sure you take into account any feedback we give you on the draft.

Your essay should be *at least* two pages in length.  (Two pages is a minimum, and I would expect that it is more likely that three or more pages will be necessary.)  You should strive to be clear and concise.

*Proofread your reflection carefully*.  We will make comments on the draft (so you can use the feedback for your final version), but it is your responsibility to check your work carefully for spelling and grammar errors.

Please read our [Effective Writing](../outcomes/writing.html) document for more information about our expectations for your writing.

# Grading criteria

The overall project is worth 100 points.

The program is worth up to 40 points, and the essay outline, draft, and final version are worth up to 60 points.

For the program:

* A basic composition (with a small number of visual elements, but with at least one repeated element implemented using a function) will earn up to 28 points
* A more complex composition (with a larger number of visual elements, and also with at least one repeated element implemented using a function) will earn up to 32 points
* Up to 8 points may be earned through the use of optional features (repeated elements using a loop, generative elements, and/or animated elements)

The outline is worth up to 4 points.

The draft is worth up to 8 points.

For the final version of the essay:

* Introduction: up to 6 points
* Discussion of creative process: up to 12 points
* Discussion of ways in which the composition succeeded: up to 12 points
* Discussion of ways in which the composition could be improved: up to 12 points
* Conclusions: up to 6 points

To earn a higher grade for the essay, you should express yourself clearly and concisely, and your writing should offer some deep insights into the creative process.

# Submitting

Please create a folder within your [shared Google drive folder](assign00.html) called **Assignment 3**.  (Navigate into your shared Google drive folder, click **New** and then **Folder**, and enter **Assignment 3** as the name of the folder.)

The essay outline, draft, and final version should be documents named `EssayOutline`, `EssayDraft`, and `EssayFinal` within your **Assignment 3** folder.

Submit your code by uploading it to your shared Google Drive folder.  Your code is a file called `VisualArtProject.pde` in a folder called `VisualArtProject` within your sketchbook folder.  You can upload a file to a Google Drive folder by clicking **New**, choosing **File upload**, and then selecting the file you want to upload.
