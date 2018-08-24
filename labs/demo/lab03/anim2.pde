// Variables to control where the smiley face appears
int x, y;
int dx, dy;
float theta;

void setup() {
  size(800, 600);
  
  // Provide initial values for the animation variables.
  x = 400;
  y = 300;
  dx = 1;
  dy = 1;
  theta = 0;
  
  // Note that we didn't use noLoop().
  // This means that the draw function will be called
  // repeatedly to draw frames of the animation.
}

void draw() {
  // Start each frame of the animation by redrawing the background.
  // This ensures that nothing in the previous frame of animation
  // will still be visible.
  background(211);

  // TODO: change the animation variables!
  x = x - 1;

  stroke(0);
  strokeWeight(5);

  drawSmiley(x, y);
}

// Draw a smiley face centered at (smileyX, smileyY)
void drawSmiley(int smileyX, int smileyY) {
  fill(255);
  ellipse(smileyX, smileyY, 300, 300);
  fill(0);
  ellipse(smileyX-40, smileyY-30, 20, 40);
  ellipse(smileyX+40, smileyY-30, 20, 40);
  arc(smileyX, smileyY+60, 120, 40, 0, PI);
}
