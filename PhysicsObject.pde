public class PhysicsObject {
    float size;
    float speedY = 0;
    float gravity = 9810;
    float radius = 20;
    float ground = 0;
    float bounciness = 0.15;
    
    float x = 500;
    float y = -1000;
    float z = 0;
    
    public void logic() {
        speedY += gravity * 0.01667;
        if (y > ground) {
            if (abs(speedY) < (gravity*0.02)){ 
                speedY = 0;
            }
            if (speedY > 0) {
                speedY = -(speedY * bounciness);
            } 
            
        }
    
        y += speedY * 0.01667;
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
