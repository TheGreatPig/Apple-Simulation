class Terrain {
  int tWidth, tHeight;
  int cols, rows;      // Number of columns and rows in the terrain grid
  float scl;           // Scale factor for grid spacing
  float[][] heights;   // 2D array to store terrain heights

  // Constructor to initialize terrain properties
  Terrain(int tWidth, int tHeight, int scl) {
    this.tWidth = tWidth;
    this.tHeight = tHeight;
    this.scl = scl;
    this.cols = tWidth / scl;
    this.rows = tHeight / scl;
    
    this.heights = new float[cols][rows];
  }

  // Method to generate the terrain
  void generateTerrain(int lod, float falloff, float heightFactor, int seed) {
      noiseSeed(seed);
      noiseDetail(lod, falloff);
      float yoff = 0; // Y offset for Perlin noise
      for (int y = 0; y < rows; y++) {
        float xoff = 0; // X offset for Perlin noise
        for (int x = 0; x < cols; x++) {
          float noiseValue = noise(xoff, yoff); // Get Perlin noise value
          heights[x][y] = map(noiseValue, 0, 1, -100 * heightFactor, 100 * heightFactor); // Map to height range
          xoff += 0.05; // Increment X offset
        }
        yoff += 0.05; // Increment Y offset
      }
  }

  // Get terrain height at grid coordinates
  float getHeight(int x, int y) {
    if (x >= 0 && x < cols && y >= 0 && y < rows) {
      return heights[x][y];
    }
    return 0; // Default to 0 if out of bounds
  }

  // Convert grid coordinates to world coordinates
  PVector gridToWorld(int gridX, int gridY) {
    float worldX = gridX * scl - cols * scl / 2;
    float worldZ = gridY * scl - rows * scl / 2;
    float worldY = getHeight(gridX, gridY); // Terrain height at this grid position
    return new PVector(worldX, worldY, worldZ);
  }

  float getHeightAtWorldPosition(float x, float y, float z) {
  // Offset to center of terrain grid
  float halfWidth = cols * scl / 2;
  float halfHeight = rows * scl / 2;

  // Calculate grid coordinates
  float gridX = (x + halfWidth) / scl;
  float gridZ = (z + halfHeight) / scl;

  // Check if point is within terrain bounds
  if (gridX >= 0 && gridX < cols && gridZ >= 0 && gridZ < rows) {
    int x1 = floor(gridX);
    int z1 = floor(gridZ);

    // Print debug information
    //println("World Coordinates: (x: " + x + ", y: " + y + ", z: " + z + ")");
    //println("Grid Coordinates: (gridX: " + gridX + ", gridZ: " + gridZ + ")");
    //println("Grid Indices: (x1: " + x1 + ", z1: " + z1 + ")");
    
    // Ensure we're within array bounds
    x1 = constrain(x1, 0, cols - 1);
    z1 = constrain(z1, 0, rows - 1);

    float foundHeight = heights[x1][z1];
    
    println("Terrain Height at (" + x1 + ", " + z1 + "): " + -foundHeight);
    
    return -foundHeight;
  }

  println("Position outside terrain bounds");
  return 0;
}
}
