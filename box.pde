public class Box {
    float size;
    float speedY = 0;
    float gravity = 0.2;
    float radius = 20;
    float ground = -1000;
    
    float x = 50;
    float y = -1000;
    float z = 50;
    
    public void logic() {

        speedY += gravity;
        y += speedY;

        if (y > ground) {
            y = ground - radius;
            speedY = 0;
        }

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
   
