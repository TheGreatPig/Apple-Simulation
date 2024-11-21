float camX,camY,camZ;
float yVelocity;
float camYaw, camPitch;
float gravity = 0.2;

boolean[] keyIndex = new boolean[5];

Box box1 = new Box();
PShape apple;

void setup()  {
  size(1920, 800, P3D);
  noStroke();
  fill(204);
  camX = 0;
  camY = 0;
  camZ = 0;
  yVelocity = 0;
  apple = loadShape("apple.obj");
  
  
  
}
// 

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

void draw()  {
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  
  // input handling

  println(camX, box1.getY(), sin(camYaw) * 10, cos(camYaw) * 10);
  if (keyPressed){
    if (keyIndex[0]) { // W
      camZ += 10;
      // camZ += cos(camYaw) * 10; 
    
  }
  if (keyIndex[2]) { // S
      camZ -= 10;
      //camX += sin(camYaw + (PI/2)) * 10; 
      //camZ += cos(camYaw + (PI/2)) * 10;
  }

  if (keyIndex[1]) { // A
      camX += 10;
      //camX += sin(camYaw) * 10; 
      //camZ += cos(camYaw) * 10;
    
  }
  if (keyIndex[3]) { // D
      camX -= 10;
      //camX += sin(camYaw) * 10; 
      //camZ += cos(camYaw) * 10;    
  }
  if (keyIndex[4] && yVelocity >= 0) {
    yVelocity = -30;
  }
  }
  
  camYaw = radians(mouseX / 10.6667);;
  camPitch = radians(mouseY / 10);;

  // Logic
  box1.logic();
  yVelocity += 1;
  camY -= yVelocity;
  
  if (camY < 200) {
    yVelocity = 0;
    camY = 200;
  }
  
  // Rendering
  noCursor();
  lights();
  background(0);
  
  
  camera(camX, camY, 220, // eyeX, eyeY, eyeZ
         camX, camY, camZ, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
  
  
  
  
  //perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);
  
  
//   rotateX(-PI/6);
//   rotateY(PI/3);

  rotateX(-camPitch);  // Rotate for pitch (up and down)
  rotateY(camYaw);    // Rotate for yaw (left and right)
  translate(camX, camY, camZ);  // Move the scene according to the player's position

  
  //rotateY(camPitch);
  translate(camX,camY,camZ);
  

  pushMatrix();
  translate(box1.getX(), box1.getY(), box1.getZ());
  scale(500,500,500);
  shape(apple);
  popMatrix();
  
  

}
