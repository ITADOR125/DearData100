Table table;

void setup() {
  size(1500, 1050);
  background(246, 243, 236);
  
  table = loadTable("observations.csv", "header");
  println("Loaded " + table.getRowCount() + " rows!");

  noLoop();
}

void draw() {
  drawHeader();
  drawDataPoints();
  drawLegend();
}

void drawHeader() {
  fill(30);
  textSize(28);
  textAlign(LEFT, TOP);
  text("MOMENTS OF WAITING — 100 OBSERVATIONS", 60, 35);
  
  textSize(14);
  fill(90);
  text("My visualisation of waiting moments throughout a week", 60, 75);
  
  stroke(180);
  strokeWeight(1.5);
  line(60, 100, width - 60, 100);
}

void drawDataPoints() {
  int cols = 10;
  float startX = 85;
  float startY = 165;
  float spacingX = 135;
  float spacingY = 76;

  for (int i = 0; i < table.getRowCount(); i++) {
    TableRow row = table.getRow(i);

    int id = row.getInt("id");
    int duration = row.getInt("perceived_wait_sec");
    int frustration = row.getInt("frustration_level");
    String location = row.getString("location");
    String coping = row.getString("coping_action");
    String reason = row.getString("wait_reason");

    int col = i % cols;
    int r = i / cols;
    float x = startX + (col * spacingX);
    float y = startY + (r * spacingY);

    float lineLen = map(duration, 5, 1500, 12, 42);

    color c = getFrustrationColor(frustration);

    stroke(c);
    strokeWeight(3.5);
    line(x, y, x, y - lineLen);

    float shapeY = y - lineLen;
    fill(c);
    stroke(30);
    strokeWeight(1.5);

    if (location.equals("Home")) {
      ellipse(x, shapeY, 20, 20);
    } else if (location.equals("Uni")) {
      rectMode(CENTER);
      rect(x, shapeY, 18, 18);
    } else if (location.contains("Bus") || location.contains("Train") || location.contains("Station")) {
      triangle(x, shapeY - 10, x - 9, shapeY + 8, x + 9, shapeY + 8);
    } else {
      ellipse(x, shapeY, 14, 14);
    }

    drawWaitReasonSymbol(x, shapeY, reason);

    stroke(30);
    strokeWeight(2);
    if (coping.contains("TikTok") || coping.contains("phone")) {
      fill(30);
      ellipse(x + 12, shapeY - 10, 5, 5);
    } else if (coping.contains("music") || coping.contains("Talked")) {
      noFill();
      ellipse(x, shapeY, 28, 28);
    } else if (coping.contains("screen") || coping.contains("Fidgeted")) {
      line(x - 7, shapeY - 14, x + 7, shapeY - 14);
    }

    fill(90);
    textSize(9.5);
    textAlign(CENTER, TOP);
    text("#" + id, x, y + 5);
  }
}

void drawWaitReasonSymbol(float x, float y, String reason) {
  String r = reason.toLowerCase();
  stroke(30);
  strokeWeight(1.5);
  noFill();

  if (r.contains("game") || r.contains("code") || r.contains("discord") || r.contains("netflix") || r.contains("steam") || r.contains("load") || r.contains("push") || r.contains("update")) {
    line(x - 4, y - 4, x + 4, y + 4);
    line(x + 4, y - 4, x - 4, y + 4);
  } else if (r.contains("bus") || r.contains("train") || r.contains("traffic") || r.contains("uber")) {
    line(x - 5, y - 2, x + 5, y - 2);
    line(x - 5, y + 2, x + 5, y + 2);
  } else if (r.contains("chicken") || r.contains("tea") || r.contains("coffee") || r.contains("food") || r.contains("oven") || r.contains("boil") || r.contains("microwave") || r.contains("pizza") || r.contains("rice") || r.contains("takeaway")) {
    pushMatrix();
    translate(x, y);
    rotate(QUARTER_PI);
    rectMode(CENTER);
    rect(0, 0, 5, 5);
    popMatrix();
  } else {
    fill(30);
    ellipse(x, y, 4, 4);
  }
}

color getFrustrationColor(int level) {
  if (level == 1) return color(60, 160, 210);
  else if (level == 2) return color(80, 170, 110);
  else if (level == 3) return color(240, 180, 40);
  else if (level == 4) return color(240, 110, 40);
  else return color(220, 40, 40);
}

void drawLegend() {
  float ly = height - 60;
  stroke(180);
  strokeWeight(1.5);
  line(60, ly - 35, width - 60, ly - 35);

  fill(30);
  textSize(12);
  textAlign(LEFT, CENTER);
  text("LEGEND KEY:", 60, ly - 10);

  text("Frustration (1-5):", 150, ly - 10);
  for (int f = 1; f <= 5; f++) {
    fill(getFrustrationColor(f));
    stroke(30);
    strokeWeight(1);
    rectMode(CORNER);
    rect(250 + ((f - 1) * 20), ly - 18, 14, 15, 2);
  }

  fill(30);
  text("Location:", 360, ly - 10);
  
  fill(200);
  stroke(30);
  ellipse(420, ly - 10, 12, 12);
  fill(50);
  textSize(10);
  text("Home", 430, ly - 10);

  fill(200);
  rectMode(CENTER);
  rect(470, ly - 10, 11, 11);
  fill(50);
  text("Uni", 478, ly - 10);

  fill(200);
  triangle(505, ly - 16, 499, ly - 5, 511, ly - 5);
  fill(50);
  text("Transit", 516, ly - 10);

  // Line Height / Duration Key
  fill(30);
  textSize(12);
  text("Wait Time:", 565, ly - 10);
  stroke(100);
  strokeWeight(2);
  line(635, ly - 4, 635, ly - 12);
  line(645, ly - 2, 645, ly - 18);
  fill(50);
  textSize(10);
  text("Line Height = Duration", 652, ly - 10);

  fill(30);
  textSize(12);
  text("Waiting For:", 775, ly - 10);

  stroke(30);
  strokeWeight(1.5);
  line(850, ly - 14, 858, ly - 6);
  line(858, ly - 14, 850, ly - 6);
  fill(50);
  textSize(10);
  text("Tech", 863, ly - 10);

  line(895, ly - 12, 905, ly - 12);
  line(895, ly - 8, 905, ly - 8);
  text("Transit", 910, ly - 10);

  pushMatrix();
  translate(955, ly - 10);
  rotate(QUARTER_PI);
  rectMode(CENTER);
  rect(0, 0, 5, 5);
  popMatrix();
  fill(50);
  text("Food", 963, ly - 10);

  fill(30);
  ellipse(998, ly - 10, 5, 5);
  fill(50);
  text("Routine", 1005, ly - 10);

  fill(30);
  textSize(12);
  text("Coping:", 1055, ly - 10);

  fill(30);
  ellipse(1105, ly - 10, 5, 5);
  fill(50);
  textSize(10);
  text("Phone", 1113, ly - 10);

  noFill();
  stroke(30);
  strokeWeight(1.5);
  ellipse(1155, ly - 10, 14, 14);
  fill(50);
  text("Music/Friends", 1165, ly - 10);

  stroke(30);
  strokeWeight(2);
  line(1245, ly - 10, 1259, ly - 10);
  fill(50);
  text("Stared/Fidgeted", 1265, ly - 10);
}