ImagesCarrier ic;
PImage[] images = new PImage[9];
float[] fitness = new float[images.length];

void setup() {
  size(999, 222);
  ic = new ImagesCarrier(true);
  generateRandomImages();
}

void draw() {
  // Get new fitness values if they exist
  float[] fitnessTemp = ic.getResponse();
  if (fitnessTemp != null) {
    fitness = fitnessTemp;
  }
  
  background(220);
  
  // Display images
  for (int i = 0; i < images.length; i++) {
    image(images[i], 5 + i * (images[0].width + 5), 5);
  }
  
  // Display fitness values
  if (fitness != null) {
    fill(0);
    for (int i = 0; i < images.length; i++) {
      text(fitness[i] + "", 5 + i * (images[0].width + 5), images[0].height + 20);
    }
  }
  
  // Display message
  if (ic.waitingFitness()) {
    fill(0);
    text("Waiting fitness...", 10, height - 10);
  }
}

void mouseReleased() {
  generateRandomImages();
}

void generateRandomImages() {
  if (ic.waitingFitness()) {
    return;
  }
  PGraphics pg = createGraphics(100, 100);
  for (int i = 0; i < images.length; i++) {
    pg.beginDraw();
    pg.background(255);
    pg.rectMode(CENTER);
    pg.ellipseMode(CENTER);
    pg.noFill();
    pg.stroke(0);
    float shapeThickness = pg.height * 0.075;
    pg.strokeWeight(shapeThickness);
    int numShapes = int(random(1, 5));
    for (int s = 0; s < numShapes; s++) {
      int shapeD = int(random(0.2, 0.4) * pg.height);
      int shapeX = int(random(shapeD / 2 + shapeThickness, pg.width - shapeD / 2 - shapeThickness));
      int shapeY = int(random(shapeD / 2 + shapeThickness, pg.height - shapeD / 2 - shapeThickness));
      if (random(1) < 0.5) {
        pg.square(shapeX, shapeY, shapeD);
      } else {
        pg.circle(shapeX, shapeY, shapeD);
      }
    }
    pg.endDraw();
    images[i] = pg.get();
  }
  
  fitness = null;
  ic.send(images);
}
