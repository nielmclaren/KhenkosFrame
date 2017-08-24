import controlP5.*;

FrameParser frameParser;

int sourceImageIndex;
int numSourceImages;
Frame frame;

OpenCV opencv;
ArrayList<Line> lines;

ControlP5 cp5;

FileNamer fileNamer;

void setup() {
  size(800, 800);
  
  frameParser = new FrameParser(this);
  
  sourceImageIndex = 0;
  numSourceImages = 100;
  updateFrame();
  
  cp5 = new ControlP5(this);
  setupInputs();
  
  fileNamer = new FileNamer("output/frame", "png");
}

void setupInputs() {
  float currY = 10;
  cp5.addSlider("minCannyValue")
     .setPosition(10, currY)
     .setValue(frameParser.minCannyValue)
     .setRange(0, 512);
  currY += 15;
  
  cp5.addSlider("maxCannyValue")
     .setPosition(10, currY)
     .setValue(frameParser.maxCannyValue)
     .setRange(0, 512);
  currY += 15;
  
  cp5.addSlider("threshold")
     .setPosition(10, currY)
     .setValue(frameParser.threshold)
     .setRange(0, 512);
  currY += 15;
  
  cp5.addSlider("minLineLength")
     .setPosition(10, currY)
     .setValue(frameParser.minLineLength)
     .setRange(1, 512);
  currY += 15;
  
  cp5.addSlider("maxLineGap")
     .setPosition(10, currY)
     .setValue(frameParser.maxLineGap)
     .setRange(1, 512);
  currY += 15;
}

PImage loadSourceImage(int index) {
  String filename = String.format("frame%04d.bmp", index + 1);
  return loadImage(filename);
}

void draw() {
  background(32);
  image(frame.sourceImage, 0, 0);
  
  image(frame.opencv.getOutput(), frame.sourceImage.width, 0);
  strokeWeight(3);
  
  for (Line line : frame.lines) {
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
  updateFrame();
}

void nextSourceImage() {sourceImageIndex++;
  if (sourceImageIndex >= numSourceImages) {
    sourceImageIndex = 0;
  }
  updateFrame();
}

void updateFrame() {
  frame = frameParser.parse(loadSourceImage(sourceImageIndex));
  println("Source image: " + sourceImageIndex);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(cp5.getController("minCannyValue"))) {
    frameParser.minCannyValue = floor(theEvent.getValue());
  } else if (theEvent.isFrom(cp5.getController("maxCannyValue"))) {
    frameParser.maxCannyValue = floor(theEvent.getValue());
  } else if (theEvent.isFrom(cp5.getController("threshold"))) {
    frameParser.threshold = floor(theEvent.getValue());
  } else if (theEvent.isFrom(cp5.getController("minLineLength"))) {
    frameParser.minLineLength = floor(theEvent.getValue());
  } else if (theEvent.isFrom(cp5.getController("maxLineGap"))) {
    frameParser.maxLineGap = floor(theEvent.getValue());
  }

  println("minCannyValue: " + frameParser.minCannyValue);
  println("maxCannyValue: " + frameParser.maxCannyValue);
  println("threshold: " + frameParser.threshold);
  println("minLineLength: " + frameParser.minLineLength);
  println("maxLineGap: " + frameParser.maxLineGap);
  updateFrame();
}

void keyReleased() {
  switch (key) {
    case 'j':
      prevSourceImage();
      break;
    case 'k':
      nextSourceImage();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}