#include "Obstacle.h"


Obstacle::Obstacle() : GameElement("obstacle") {
    
}
Obstacle::Obstacle(int _x, int _y, int _s) : GameElement("obstacle")
{
    xPos = _x;
    yPos = _y;
    size = _s;
}

void Obstacle::init(b2World* b2dWorld){

    physicsBody.setPhysics(0, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, size, size);
    
    physicsBody.setData(this);
    physicsBody.bodyDef.userData = this;
};

void Obstacle::draw()
{
    ofSetColor(255, 255, 255);
    physicsBody.draw();
    //ofDrawSphere(xPos, yPos, size);
}
