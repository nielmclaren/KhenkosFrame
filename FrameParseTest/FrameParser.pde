import gab.opencv.*;
import processing.core.PApplet;

class FrameParser {
  private PApplet _applet;

  public int minCannyValue;
  public int maxCannyValue;
  public int threshold;
  public int minLineLength;
  public int maxLineGap;

  FrameParser(PApplet applet) {
    _applet = applet;

    minCannyValue = 100;
    maxCannyValue = 300;
    
    threshold = 120;
    minLineLength = 100;
    maxLineGap = 33;
  }

  Frame parse(PImage sourceImage) {
    OpenCV opencv = getOpenCV(sourceImage);
    ArrayList<Line> lines = getLines(opencv);
    return new Frame(sourceImage, opencv, lines);
  }

  private OpenCV getOpenCV(PImage sourceImage) {
    OpenCV opencv = new OpenCV(_applet, sourceImage);
    opencv.findCannyEdges(minCannyValue, maxCannyValue);
    return opencv;
  }

  private ArrayList<Line> getLines(OpenCV opencv) {
    // Find lines with Hough line detection
    // Arguments are: threshold, minLengthLength, maxLineGap
    return opencv.findLines(threshold, minLineLength, maxLineGap);
  }
}