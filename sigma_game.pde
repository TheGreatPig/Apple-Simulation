float camX,camY,camZ;
float yVelocity;
float camYaw, camPitch;

boolean[] keyIndex = new boolean[6];

PhysicsObject apple1 = new PhysicsObject();
Terrain terrain1;
PShape apple;
PShape tree;
PImage bg;

// Variables for terrain data

int terrainGridScale = 100; // Scale of each grid cell
int terrainWidth = 40000; // Width of the terrain
int terrainHeight = 40000; // Height of the terrain
float maxRenderDistance = 8000; // Maximum render distance from player
float fogDistance = maxRenderDistance * 0.8;
float heightFactor = 5;      // Factor to scale the height of hills
float[][] terrain; // Array to store terrain heights

int movementSpeed = 45;
int planet = 0; // 0 = Earth, 1 = Moon, 2 = Mars


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
  case 'c':
    // planet switch logic
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

void setup()  {
  size(1920, 900, P3D);
  frameRate(60);
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

void draw()  {
  // float fov = PI/3.0;
  // float cameraZ = (height/2.0) / tan(fov/2.0);
  
  // input handling

  if (keyPressed){
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
  if (keyIndex[4] && yVelocity >= 0) {
    yVelocity = -30;
  }
  if (keyIndex[5]) {
    apple1.y = -1000;
  }
}
  
  camYaw = radians(mouseX / 5.3334) - 3.14;
  camPitch = radians(mouseY / 6) - 1.57;

  // Logic
  apple1.logic();
  yVelocity += 1;
  camY -= yVelocity;
  
  if (camY < 200) {
    yVelocity = 0;
    camY = 200;
  }
  
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
  
  
  
  
  //perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);
  
  
  // cam position and rotation
  beginCamera();
  rotateX(-camPitch);  // pitch (up / down)
  rotateY(camYaw);    //  yaw (left / right)
  translate(camX, camY, camZ);
  endCamera();
  
  // apple
  pushMatrix();
  translate(apple1.getX(), apple1.getY(), apple1.getZ());
  scale(10,10,10);
  rotateZ(PI);
  shape(apple);
  popMatrix();
  
  // tree
  pushMatrix();
  translate(0, -100, 0);
  scale(75,100,75);
  rotateZ(PI);
  shape(tree);
  popMatrix();
  
  // orientation lines
  stroke(255);
  line(500,0,0,500,-1000,0);
  line(0,0,0,1000,0,0);
  line(500,0,-500,500,0,500);
  fill(255);
  text("1m", 1000,0,0);
   
  // floor
  //pushMatrix();
  //translate(0,-1,0);
  //box(1000,0.1,1000);
  //popMatrix();

  lights();
  directionalLight(200, 150, 100, -1, -0.5, -1);  
  ambientLight(50, 50, 50);
  
  noStroke();
  float height_offset = terrain1.getHeightAtWorldPosition(0, 0, 0) + 20;
  //println(planet % 3);
  
  for (int y = 0; y < terrain1.rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    
    for (int x = 0; x < terrain1.cols; x++) {
      // Get world coordinates for rendering
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
          baseRed = map(vertex1.y, 0, 200, 30, 150);  // Increase red for a brownish tone at the top
          baseGreen = map(vertex1.y, 0, 200, 80, 100); // Reduce green at the top for more brown
          baseBlue = map(vertex1.y, 0, 200, 40, 50);  // Lower blue for warmer brown hues
          break;

      
        case 1: // Moon
          baseRed = map(vertex1.y, 0, 200, 80, 120);  // Grayish hues
          baseGreen = map(vertex1.y, 0, 200, 80, 120); // Equalized gray-green
          baseBlue = map(vertex1.y, 0, 200, 80, 120);  // Gray dominant
          break;

      
        case 2: // Mars
          baseRed = map(vertex1.y, 0, 200, 150, 250);  // Red-orange tones
          baseGreen = map(vertex1.y, 0, 200, 40, 80);  // Minimal green
          baseBlue = map(vertex1.y, 0, 200, 30, 70);   // Slight blue for shadows
          break;
      }
      
      // Add some randomness to break up the terrain uniformity
      float noiseVariation = noise(vertex1.x * 0.01, vertex1.z * 0.01) * 0;
      
      // Fog and distance fade
      float fogFactor = map(distance, fogDistance, maxRenderDistance, 255, 0);

      // Apply colors with noise variation
      fill(
        constrain(baseRed + noiseVariation, 0, 255), 
        constrain(baseGreen + noiseVariation, 0, 255), 
        constrain(baseBlue + noiseVariation, 0, 255), 
        fogFactor
      );
      vertex(vertex1.x, vertex1.y+height_offset, vertex1.z);
      
      // Repeat for the next vertex
      switch (planet % 3) {
        case 0: // Earth
          baseRed = map(vertex1.y, 0, 200, 30, 150);  // Increase red for a brownish tone at the top
          baseGreen = map(vertex1.y, 0, 200, 80, 100); // Reduce green at the top for more brown
          baseBlue = map(vertex1.y, 0, 200, 40, 50);  // Lower blue for warmer brown hues
          break;

      
        case 1: // Moon
          baseRed = map(vertex1.y, 0, 200, 80, 120);  // Grayish hues
          baseGreen = map(vertex1.y, 0, 200, 80, 120); // Equalized gray-green
          baseBlue = map(vertex1.y, 0, 200, 80, 120);  // Gray dominant
          break;

      
        case 2: // Mars
          baseRed = map(vertex2.y, 0, 200, 150, 250);  // Red-orange tones
          baseGreen = map(vertex2.y, 0, 200, 40, 80);  // Minimal green
          baseBlue = map(vertex2.y, 0, 200, 30, 70);   // Slight blue for shadows
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
  } //<>//
  
  // Text rendering
  hint(DISABLE_DEPTH_TEST);
  camera(); // Reset transformations
  noLights();
  textSize(25);
  fill(255);
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
  
  text("Ortsfaktor: " + nf(apple1.gravity/1000,1,2) + " m/s²", 30, 75);
  text("Geschwindigkeit: " + nf(apple1.speedY/1000,1,3) + " m/s", 30, 100);
  text("Seed: " + str(planet), 30, 125);
  hint(ENABLE_DEPTH_TEST);

}
