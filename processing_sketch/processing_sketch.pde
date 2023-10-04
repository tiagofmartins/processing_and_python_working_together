ImagesCarrier ic;
PImage[] testImages = new PImage[9];

void setup() {
  size(999, 222);
  ic = new ImagesCarrier(true);
  generateRandomImages();
}

void draw() {
  background(220);
  pushMatrix();
  for (int i = 0 ; i < testImages.length; i++) {
    image(testImages[i], 5, 5);
    translate(testImages[i].width + 5, 0);
  }
  popMatrix();
}

void mouseReleased() {
  generateRandomImages();
}

void generateRandomImages() {
  if (ic.waitingFitness()) {
    return;
  }
  PGraphics pg = createGraphics(100, 100);
  for (int i = 0 ; i < testImages.length; i++) {
    pg.beginDraw();
    pg.background(255);
    pg.rectMode(CENTER);
    pg.ellipseMode(CENTER);
    pg.noStroke();
    int numShapes = int(random(1, 5));
    for (int s = 0; s < numShapes; s++) {
      pg.fill(0, random(128, 255));
      int shapeW = int(random(0.2, 0.4) * pg.width);
      int shapeH = int(random(0.2, 0.4) * pg.height);
      int shapeX = int(random(shapeW / 2, pg.width - shapeW / 2));
      int shapeY = int(random(shapeH / 2, pg.height - shapeH / 2));
      if (random(1) < 0.5) {
        pg.rect(shapeX, shapeY, shapeW, shapeH);
      } else {
        pg.ellipse(shapeX, shapeY, shapeW, shapeH);
      }
    }
    pg.endDraw();
    testImages[i] = pg.get();
  }
}
