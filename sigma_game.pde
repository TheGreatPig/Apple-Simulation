float camX,camY,camZ;
float yVelocity;
float camYaw, camPitch;

boolean[] keyIndex = new boolean[5];

PhysicsObject apple1 = new PhysicsObject();
PShape apple;
PShape tree;
PImage bg;

// Variables for terrain data
int cols, rows;
int scl = 100; // Scale of each grid cell
int w = 40000; // Width of the terrain
int h = 40000; // Height of the terrain
float maxRenderDistance = 8000; // Maximum render distance from player
float heightFactor = 4;      // Factor to scale the height of hills
float[][] terrain; // Array to store terrain heights

void setupTerrain() {
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];

  // Generate the terrain heights once
  float yoff = 0; // Y offset for Perlin noise
  for (int y = 0; y < rows; y++) {
    float xoff = 0; // X offset for Perlin noise
    for (int x = 0; x < cols; x++) {
      float noiseValue = noise(xoff, yoff); // Get Perlin noise value
      terrain[x][y] = map(noiseValue, 0, 1, -100, 100); // Map to height range
      xoff += 0.05; // Increment X offset
    }
    yoff += 0.05; // Increment Y offset
  }
}



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
  }
}

void setup()  {
  size(1920, 1080, P3D);
  noStroke();
  fill(204);
  camX = 0;
  camY = 0;
  camZ = 0;
  yVelocity = 0;
  apple = loadShape("apple.obj");
  tree = loadShape("baum.obj");
  
  bg = loadImage("star_field.png");
  
  setupTerrain();
  
}

void draw()  {
  // float fov = PI/3.0;
  // float cameraZ = (height/2.0) / tan(fov/2.0);
  
  // input handling

  println(apple1.getY());
  if (keyPressed){
    if (keyIndex[0]) { // W
      camX -= sin(camYaw) * 10;
      camZ += cos(camYaw) * 10; 
    
  }
  if (keyIndex[2]) { // S
      camX -= sin(camYaw + 3.14) * 10;
      camZ += cos(camYaw + 3.14) * 10; 
  }

  if (keyIndex[1]) { // A
      camX -= sin(camYaw - 1.57) * 10;
      camZ += cos(camYaw - 1.57) * 10; 
    
  }
  if (keyIndex[3]) { // D
      camX -= sin(camYaw + 1.57) * 10;
      camZ += cos(camYaw + 1.57) * 10;    
  }
  if (keyIndex[4] && yVelocity >= 0) {
    yVelocity = -30;
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
  background(9, 9, 46);
  
  
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
  scale(20,20,20);
  rotateZ(PI);
  shape(apple);
  popMatrix();
  
  
  pushMatrix();
  translate(0, -120, 0);
  scale(50,50,50);
  rotateZ(PI);
  shape(tree);
  popMatrix();
  
  // orientation lines
  stroke(255);
  line(500,-500,0,500,500,0);
  line(0,0,0,1000,0,0);
  line(500,0,-500,500,0,500);
   
  // floor
  //pushMatrix();
  //translate(0,-1,0);
  //box(1000,0.1,1000);
  //popMatrix();
  
  // Render the precomputed terrain
  noStroke(); // Smooth shading for the terrain

  // Center the terrain
  translate(-cols * scl / 2, 0, -rows * scl / 2);


  float fogDistance = maxRenderDistance * 0.7;

  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      // Calculate the world position of the vertex
      float worldX = x * scl - cols * scl / 2;
      float worldZ = y * scl - rows * scl / 2;
      float distance = dist(worldX, 0, worldZ, -camX, -camY, -camZ);

      // Skip rendering if the vertex is beyond the max render distance
      if (distance > maxRenderDistance) continue;

      // Calculate color based on height
      float height = terrain[x][y] * heightFactor; // Scale height by heightFactor
      float green = map(height, -100 * heightFactor, 100 * heightFactor, 100, 255);
      float brown = map(height, -100 * heightFactor, 100 * heightFactor, 150, 100);
      
      float fogFactor = map(distance, fogDistance, maxRenderDistance, 255, 0);
      fill(brown, green, 50, fogFactor);

      // Render current vertex
      vertex(x * scl, height, y * scl);

      // Render next row vertex
      height = terrain[x][y + 1] * heightFactor;
      green = map(height, -100 * heightFactor, 100 * heightFactor, 100, 255);
      brown = map(height, -100 * heightFactor, 100 * heightFactor, 150, 100);
      fill(brown, green, 50, fogFactor);
      vertex(x * scl, height, (y + 1) * scl);
    }
    endShape();
  }
  

}
