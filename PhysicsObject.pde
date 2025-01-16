public class PhysicsObject {
  float size;
  float radius = 20;
  float ground = 0;
  float bounciness = 0.15;
  float gravity = 9810;
  
  boolean overwrite = false;

  PVector position;
  PVector velocity;
  PVector acceleration;

  public PhysicsObject(float x, float y, float z) {
    position = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
  }

  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  public void logic() {
    if (!overwrite) {
      acceleration.set(0, 0, 0);
      
      PVector gravityForce = new PVector(0, gravity, 0);
      applyForce(gravityForce);
      //applyForce(new PVector(100, 0, 0));
  
      velocity.add(PVector.mult(acceleration, 0.01667)); // deltaTime = 1/60
  
      position.add(PVector.mult(velocity, 0.01667));
  
      // Ground collision
      if (position.y > ground) {
        if (abs(velocity.y) < (gravity * 0.02)) {
          velocity.y = 0;
          acceleration.set(0, 0, 0);
        } else if (velocity.y > 0) {
          velocity.y = -velocity.y * bounciness;
        }
        position.y = ground;
        
        // friction
        velocity.x = velocity.x * 0.8;
        velocity.z = velocity.z * 0.8;
      }
    }
  }
  

  public float getX() {
    return this.position.x;
  }

  public float getY() {
    return this.position.y;
  }

  public float getZ() {
    return this.position.z;
  }
}
