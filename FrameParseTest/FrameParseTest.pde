import controlP5.*;
import gab.opencv.*;

int threshold;
int minLineLength;
int maxLineGap;

int sourceImageIndex;
int numSourceImages;
PImage sourceImage;

OpenCV opencv;
ArrayList<Line> lines;

ControlP5 cp5;

void setup() {
  size(800, 800);
  
  threshold = 100;
  minLineLength = 30;
  maxLineGap = 20;
  
  sourceImageIndex = 0;
  numSourceImages = 100;
  updateSourceImageOpenCV();
  
  cp5 = new ControlP5(this);
  
  float currY = 10;
  cp5.addSlider("threshold")
     .setPosition(10, currY)
     .setRange(0, 255);
  currY += 15;
  
  cp5.addSlider("minLineLength")
     .setPosition(10, currY)
     .setRange(1, 500);
  currY += 15;
  
  cp5.addSlider("maxLineGap")
     .setPosition(10, currY)
     .setRange(1, 100);
  currY += 15;
}

PImage loadSourceImage(int index) {
  String filename = String.format("frame%04d.bmp", index + 1);
  return loadImage(filename);
}

void draw() {
  background(32);
  image(sourceImage, 0, 0);
  
  image(opencv.getOutput(), sourceImage.width, 0);
  strokeWeight(3);
  
  for (Line line : lines) {
    if (line.angle >= radians(0) && line.angle < radians(1)) {
      stroke(0, 255, 0);
    } else if (line.angle > radians(89) && line.angle < radians(91)) {
      stroke(255, 0, 0);
    } else {
      stroke(0, 0, 255);
    }
    line(line.start.x, line.start.y, line.end.x, line.end.y);
  }
}

void prevSourceImage() {
  sourceImageIndex--;
  if (sourceImageIndex < 0) {
    sourceImageIndex = numSourceImages - 1;
  }
  updateSourceImageOpenCV();
}

void nextSourceImage() {sourceImageIndex++;
  if (sourceImageIndex >= numSourceImages) {
    sourceImageIndex = 0;
  }
  updateSourceImageOpenCV();
}

void updateSourceImageOpenCV() {
  sourceImage = loadSourceImage(sourceImageIndex);
  updateOpenCV();
}

void updateOpenCV() {
  opencv = new OpenCV(this, sourceImage);
  opencv.findCannyEdges(20, 75);

  // Find lines with Hough line detection
  // Arguments are: threshold, minLengthLength, maxLineGap
  lines = opencv.findLines(threshold, minLineLength, maxLineGap);
  
  println("Source image: " + sourceImageIndex);
}

void controlEvent(ControlEvent theEvent) {
  updateOpenCV();
}

void keyReleased() {
  switch (key) {
    case 'j':
      prevSourceImage();
      break;
    case 'k':
      nextSourceImage();
      break;
  }
}