float camX, camY, camZ; //<>//
float yVelocity;
float camYaw, camPitch;

boolean[] keyIndex = new boolean[6];

PhysicsObject apple1 = new PhysicsObject(500, -1000, 0);
Terrain terrain1;
PShape apple;
PShape tree;
PImage bg;

// terrain data
int terrainGridScale = 300;
int terrainWidth = 20000;
int terrainHeight = 20000;
float maxRenderDistance = 12000;
float fogDistance = maxRenderDistance * 0.8;
float heightFactor = 8;
float[][] terrain;

int movementSpeed = 45;
int planet = 0; // 0 = Earth, 1 = Moon, 2 = Mars


// graph
int graph = 0;
ArrayList<Float> graphHistory = new ArrayList<>();
int graphWidth = 400;
int graphHeight = 200;
int maxHistory = 150;
int graphFactor;
int graphOffset = 50;

boolean pickupState = false;

void keyPressed() {
  switch (key) {
  case 'w':
    keyIndex[0] = true;
    break;
  case 'a':
    keyIndex[1] = true;
    break;
  case 's':
    keyIndex[2] = true;
    break;
  case 'd':
    keyIndex[3] = true;
    break;
  case ' ':
    keyIndex[4] = true;
    break;
  case 'f':
    keyIndex[5] = true;
    break;
  }
}

void keyReleased() {
  switch (key) {
  case 'w':
    keyIndex[0] = false;
    break;
  case 'a':
    keyIndex[1] = false;
    break;
  case 's':
    keyIndex[2] = false;
    break;
  case 'd':
    keyIndex[3] = false;
    break;
  case ' ':
    keyIndex[4] = false;
    break;
  case 'f':
    keyIndex[5] = false;
    break;
  case 'x':
    // graph cycle
    graph += 1;
    graphHistory.clear();
    break;
  case 'e':
    pickupState = !pickupState;
    if (!pickupState) {
      apple1.velocity.x = sin(camYaw) * 5000;
      apple1.velocity.z = -cos(camYaw) * 5000;
      apple1.velocity.y = sin(camPitch) * 5000;
    }
    break;
  case 'c':
    // planet cycle
    planet += 1;

    switch (planet % 3) {
    case 0: // Earth
      terrain1.generateTerrain(3, 0.5, 4, planet);
      apple1.gravity = 9810;
      break;
    case 1: // Moon
      terrain1.generateTerrain(3, 0.5, 5, planet);
      apple1.gravity = 1620;
      break;
    case 2: // Mars
      terrain1.generateTerrain(3, 0.5, 5, planet);
      apple1.gravity = 3690;
      break;
  
    }
  }
}

void setup() {
  size(1920, 900, P3D);
  noStroke();
  fill(204);
  camX = 0;
  camY = 0;
  camZ = 0;
  yVelocity = 0;
  apple = loadShape("apple.obj");
  tree = loadShape("baum.obj");


  terrain1 = new Terrain(terrainWidth, terrainHeight, terrainGridScale);
  terrain1.generateTerrain(3, 0.5, heightFactor, planet);
}

void draw() {
  if (!pickupState) {
    apple1.overwrite = false;
  }
  if (keyPressed) {
    if (keyIndex[0]) { // W
      camX -= sin(camYaw) * movementSpeed;
      camZ += cos(camYaw) * movementSpeed;
    }
    if (keyIndex[2]) { // S
      camX -= sin(camYaw + 3.14) * movementSpeed;
      camZ += cos(camYaw + 3.14) * movementSpeed;
    }

    if (keyIndex[1]) { // A
      camX -= sin(camYaw - 1.57) * movementSpeed;
      camZ += cos(camYaw - 1.57) * movementSpeed;
    }
    if (keyIndex[3]) { // D
      camX -= sin(camYaw + 1.57) * movementSpeed;
      camZ += cos(camYaw + 1.57) * movementSpeed;
    }
    if (keyIndex[4] && yVelocity >= 0) { // Jump
      yVelocity = -30;
    }
    if (keyIndex[5]) { // reset apple
      apple1.position.x = 500;
      apple1.position.y = -1000;
      apple1.position.z = 0;
      apple1.velocity.y = 0;
      apple1.acceleration.y = 0;
      apple1.overwrite = true;
    }
  }

  camYaw = radians(mouseX / 5.3334) - 3.14;
  camPitch = radians(mouseY / 6) - 1.57;

  // --------------------------------------------------------------------------------------
  // Logic
  println(camPitch);
  if (pickupState) {
    apple1.overwrite = true;
    apple1.position.x = -camX+100;
    apple1.position.y = -camY;
    apple1.position.z = -camZ;
  }

  apple1.logic();
  yVelocity += 1;
  camY -= yVelocity;

  if (camY < 200) {
    yVelocity = 0;
    camY = 200;
  }
  
  // --------------------------------------------------------------------------------------
  // Rendering

  noCursor();
  lights();

  //background color
  switch (planet % 3) {
  case 0: // Earth
    background(135, 206, 235);
    break;
  case 1: // Moon
    background(10, 10, 10);
    break;
  case 2: // Mars
    background(179, 173, 159);
    break;
  }
  camera(0, 0, 220, // eyeX, eyeY, eyeZ
    0, 0, 0, // centerX, centerY, centerZ
    0.0, 1.0, 0.0); // upX, upY, upZ

  perspective(PI/3.0, float(width)/float(height), (height/2.0) / tan(PI/3.0/2.0)/10.0, (height/2.0) / tan(PI/3.0/2.0)*100.0);

  // cam position and rotation
  beginCamera();
  rotateX(-camPitch);  // pitch (up / down)
  rotateY(camYaw);    //  yaw (left / right)
  translate(camX, camY, camZ);
  endCamera();

  // apple
  pushMatrix();
  translate(apple1.getX(), apple1.getY(), apple1.getZ());
  scale(10, 10, 10);
  rotateZ(PI);
  shape(apple);
  popMatrix();

  // tree
  pushMatrix();
  translate(0, -100, 0);
  scale(200, 500, 200);
  rotateZ(PI);
  shape(tree);
  popMatrix();

  // orientation lines
  stroke(255);
  line(500, 0, 0, 500, -1000, 0);
  line(-500, 0, 0, 1500, 0, 0);
  line(500, 0, -1000, 500, 0, 1000);
  fill(255);

  lights();
  //directionalLight(200, 150, 100, -1, -0.5, -1);
  ambientLight(50, 50, 50);

  // --------------------------------------------------------------------------------------
  // Random Terrain
  
  noStroke();
  float height_offset = terrain1.getHeightAtWorldPosition(0, 0, 0) + 20;

  for (int y = 0; y < terrain1.rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);

    for (int x = 0; x < terrain1.cols; x++) {
      PVector vertex1 = terrain1.gridToWorld(x, y);
      PVector vertex2 = terrain1.gridToWorld(x, y + 1);

      float distance = dist(vertex1.x, 0, vertex1.z, -camX, camY, -camZ);
      if (distance > maxRenderDistance) continue;

      float baseRed = 0;
      float baseGreen = 0;
      float baseBlue = 0;

      // terrain coloration
      switch (planet % 3) {
      case 0: // Earth
        baseRed = map(vertex1.y, 0, 200, 30, 150);
        baseGreen = map(vertex1.y, 0, 200, 80, 100);
        baseBlue = map(vertex1.y, 0, 200, 40, 50);
        break;


      case 1: // Moon
        baseRed = map(vertex1.y, 0, 200, 80, 120);
        baseGreen = map(vertex1.y, 0, 200, 80, 120);
        baseBlue = map(vertex1.y, 0, 200, 80, 120);
        break;


      case 2: // Mars
        baseRed = map(vertex1.y, 0, 200, 150, 250);
        baseGreen = map(vertex1.y, 0, 200, 40, 80);
        baseBlue = map(vertex1.y, 0, 200, 30, 70);
        break;
      }

      float noiseVariation = noise(vertex1.x * 0.01, vertex1.z * 0.01) * 0;
      float fogFactor = map(distance, fogDistance, maxRenderDistance, 255, 0);

      fill(
        constrain(baseRed + noiseVariation, 0, 255),
        constrain(baseGreen + noiseVariation, 0, 255),
        constrain(baseBlue + noiseVariation, 0, 255),
        fogFactor
        );
      vertex(vertex1.x, vertex1.y+height_offset, vertex1.z);

      //  vertex #2
      switch (planet % 3) {
      case 0: // Earth
        baseRed = map(vertex1.y, 0, 200, 30, 150);
        baseGreen = map(vertex1.y, 0, 200, 80, 100);
        baseBlue = map(vertex1.y, 0, 200, 40, 50);
        break;


      case 1: // Moon
        baseRed = map(vertex1.y, 0, 200, 80, 120);
        baseGreen = map(vertex1.y, 0, 200, 80, 120);
        baseBlue = map(vertex1.y, 0, 200, 80, 120);
        break;


      case 2: // Mars
        baseRed = map(vertex2.y, 0, 200, 150, 250);
        baseGreen = map(vertex2.y, 0, 200, 40, 80);
        baseBlue = map(vertex2.y, 0, 200, 30, 70);
        break;
      }

      noiseVariation = noise(vertex2.x * 0.01, vertex2.z * 0.01) * 0;

      fill(
        constrain(baseRed + noiseVariation, 0, 255),
        constrain(baseGreen + noiseVariation, 0, 255),
        constrain(baseBlue + noiseVariation, 0, 255),
        fogFactor
        );
      vertex(vertex2.x, vertex2.y+height_offset, vertex2.z);
    }
    endShape();
  }

  // --------------------------------------------------------------------------------------
  // UI rendering

  hint(DISABLE_DEPTH_TEST);

  noLights();
  textSize(35);
  fill(255);
  textAlign(CENTER);
  text("1m", 500, -1000, 0);
  text("1m", 1500, 0, 0);

  camera();
  
  // graph
  
  switch (graph % 3) {
  case 0:
    graphHistory.add(apple1.position.y);
    graphFactor = -8;
    break;
  case 1:
    graphHistory.add(apple1.velocity.y);
    graphFactor = 2;
    break;
  case 2:
    graphHistory.add(apple1.acceleration.y);
    graphFactor = 1;
    break;
  }
  
  if (graphHistory.size() > maxHistory) {
    graphHistory.remove(0);
  }

  int x = width - graphWidth - 20;
  int y = 40;

  noStroke();
  fill(0, 150);
  rect(x, y, graphWidth, graphHeight);

  stroke(255, 0, 0);
  noFill();

  beginShape();
  for (int i = 0; i < graphHistory.size(); i++) {
    float vx = map(i, 0, maxHistory - 1, x, x + graphWidth);
    float vy = map(graphHistory.get(i), -(10000 / graphFactor), 10000 / graphFactor, y + graphHeight, y) + graphOffset;
    vertex(vx, vy);
  }
  endShape();
  
  // text
  fill(255);
  textSize(25);
  textAlign(LEFT);

  switch (planet % 3) {
  case 0: // Earth
    text("Planet: Erde", 30, 50);
    break;
  case 1: // Moon
    text("Planet: Mond", 30, 50);
    break;
  case 2: // Mars
    text("Planet: Mars", 30, 50);
    break;
  }

  text("Ortsfaktor: " + nf(apple1.gravity/1000, 1, 2) + " m/s²", 30, 75);
  text("Geschwindigkeit: " + nf(apple1.velocity.y/1000, 1, 3) + " m/s", 30, 100);
  text("Seed: " + str(planet), 30, 125);
  text("FPS: " + int(frameRate), 30, 150);
  
  switch (graph % 3) {
  case 0:
    text("Weg-Zeit-Diagramm", width - graphWidth - 20, 30);
    break;
  case 1:
    text("Geschwindigkeit-Zeit-Diagramm", width - graphWidth - 20, 30);
    break;
  case 2:
    text("Beschleunigungs-Zeit-Diagramm", width - graphWidth - 20, 30);
    break;
  }
  

  hint(ENABLE_DEPTH_TEST);
}
