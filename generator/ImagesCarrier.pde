import java.nio.file.Path;
import java.nio.file.Paths;

class ImagesCarrier {

  private File dirOutputImages;
  private File fileWithImagesPaths;
  private File fileWithImagesFitness;

  private boolean keepImages;
  private boolean waitingFitness = false;

  ImagesCarrier(boolean keepImages) {
    this.keepImages = keepImages;
    
    // Set folder where images will be saved to be evaluated by Python
    String dirParent = new File(sketchPath()).getParent();
    this.dirOutputImages = Paths.get(dirParent, "images", "run_" + System.nanoTime()).toFile();
    if (this.dirOutputImages.exists()) {
      throw new RuntimeException("Output images directory already exists.");
    }

    // Set paths of proxy files that will be used to communicate with Python
    this.fileWithImagesPaths = Paths.get(dirParent, "images_paths.txt").toFile();
    this.fileWithImagesFitness = Paths.get(dirParent, "images_fitness.txt").toFile();
    
    // Delete files at start and shutdown 
    cleanFiles();
    Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
      public void run() {
        cleanFiles();
      }
    }
    ));
  }

  void send(ArrayList<PImage> images) {
    PImage[] imagesArray = new PImage[images.size()];
    imagesArray = images.toArray(imagesArray);
    this.send(imagesArray);
  }

  void send(PImage[] images) {
    Path dirCurrSetOutputImages = Paths.get(this.dirOutputImages.getPath(), "batch_" + System.nanoTime());

    String[] imagesPaths = new String[images.length];
    for (int i = 0; i < images.length; i++) {
      imagesPaths[i] = dirCurrSetOutputImages.resolve(nf(i + 1, 8) + ".png").toString();
      images[i].save(imagesPaths[i]);
    }
    saveStrings(this.fileWithImagesPaths.getPath(), imagesPaths);

    this.waitingFitness = true;
  }

  float[] getResponse() {
    // Return null if response file does not exist
    if (this.fileWithImagesFitness.exists() == false) {
      return null;
    }

    // Load fitness values from file
    String[] lines = loadStrings(this.fileWithImagesFitness.getPath());
    float[] fitnessValues = new float[lines.length];
    for (int i = 0; i < lines.length; i++) {
      fitnessValues[i] = Float.parseFloat(lines[i]);
    }

    // Delete files
    this.cleanFiles();
    
    this.waitingFitness = false;

    // Return retrieved fitness values
    return fitnessValues;
  }

  float[] getResponse(boolean wait) {
    while (true) {
      float[] response = this.getResponse();
      if (wait == false || response != null) {
        return response;
      } else {
        delay(10);
      }
    }
  }

  boolean waitingFitness() {
    return this.waitingFitness;
  }

  void cleanFiles() {
    if (this.fileWithImagesPaths.exists()) {
      this.fileWithImagesPaths.delete();
    }
    if (this.fileWithImagesFitness.exists()) {
      this.fileWithImagesFitness.delete();
    }
    if (keepImages == false) {
      deleteRecursively(this.dirOutputImages);
    }
  }
}

void deleteRecursively(File f) {
  if (f.isDirectory()) {
    for (File f2 : f.listFiles()) {
      deleteRecursively(f2);
    }
  }
  f.delete();
}
