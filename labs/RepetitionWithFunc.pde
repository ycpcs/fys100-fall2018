void setup() {
  size(800, 600);
  background(211);
  noLoop();
}

void draw() {
  stroke(0);
  strokeWeight(5);

  drawSmiley(180, 180);
  drawSmiley(620, 180);
  drawSmiley(400, 420);
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
