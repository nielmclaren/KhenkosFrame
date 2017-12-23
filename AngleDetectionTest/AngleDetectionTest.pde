
import java.util.List;

float radius;

List<Line> lines;
List<Float> angles;
PVector lineStart;

void setup() {
  size(800, 800);

  radius = 150;

  reset();
}

void reset() {
  lines = new ArrayList<Line>();
  angles = new ArrayList<Float>();
  lineStart = null;
}

void draw() {
  background(0);

  drawLineInput();
  drawAngleOutput();
  drawNormalizedAngleOutput();
  drawLineDrawing();
}

void drawLineInput() {
  pushMatrix();
  translate(width * 1/4, height * 1/4);

  noFill();
  stroke(128);
  ellipseMode(RADIUS);
  ellipse(0, 0, radius, radius);

  for (Line line : lines) {
    line(line.start.x, line.start.y, line.end.x, line.end.y);
  }

  popMatrix();
}

void drawAngleOutput() {
  pushMatrix();
  translate(width * 3/4, height * 1/4);

  noFill();
  stroke(128);
  ellipseMode(RADIUS);
  ellipse(0, 0, radius, radius);

  for (float angle : angles) {
    line(0, 0, radius * cos(angle), radius * sin(angle));
  }

  popMatrix();
}

void drawNormalizedAngleOutput() {
  pushMatrix();
  translate(width * 1/4, height * 3/4);

  noFill();
  stroke(128);
  ellipseMode(RADIUS);
  ellipse(0, 0, radius, radius);

  for (float angle : angles) {
    angle = (2 * angle) % (2 * PI);
    line(0, 0, radius * cos(angle), radius * sin(angle));
  }

  popMatrix();
}

void drawLineDrawing() {
  if (lineStart != null) {
    stroke(255);
    line(lineStart.x, lineStart.y, mouseX, mouseY);
  }
}

void mousePressed() {
  if (mouseX < width/2 && mouseY < height/2) {
    lineStart = new PVector(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (mouseX < width/2 && mouseY < height/2) {
    PVector lineEnd = new PVector(mouseX, mouseY);
    if (lineEnd.dist(lineStart) > 5) {
      Line line = new Line(toWorldSpace(lineStart), toWorldSpace(lineEnd));
      lines.add(line);
      angles.add(getAngleFromLine(line));
    }
  }
  lineStart = null;
}

PVector toWorldSpace(PVector v) {
  PVector result = v.copy();
  result.x -= width/4;
  result.y -= height/4;
  return result;
}

float getAngleFromLine(Line line) {
  PVector delta = PVector.sub(line.end, line.start);
  float angle = atan2(delta.y, delta.x);
  return angle;
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
  }
}