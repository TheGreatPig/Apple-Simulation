public class PhysicsObject {
    float size;
    float speedY = 0;
    float gravity = 0.2;
    float radius = 20;
    float ground = -50;
    float bounciness = 0.5;
    
    float x = 500;
    float y = -1000;
    float z = 0;
    
    public void logic() {

        speedY += gravity;
        

        if (y > ground) {
            speedY = -(speedY*bounciness);
        }
        y = min(y, ground);
        y += speedY;

    }
    
    
    
    public float getX() {
        return this.x;
    }
    public float getY() {
        return this.y;
    }
    public float getZ() {
        return this.z;
    }
    
    
}
   
