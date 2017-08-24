
class Frame {
  PImage sourceImage;
  OpenCV opencv;
  ArrayList<Line> lines;

  Frame(PImage sourceImageArg, OpenCV opencvArg, ArrayList<Line> linesArg) {
    sourceImage = sourceImageArg;
    opencv = opencvArg;
    lines = linesArg;
  }
}