#include "Goal.h"


Goal::Goal()  : GameElement("goal") {
//    xPos = ofRandom(ofGetWidth());
//    yPos = ofRandom(ofGetHeight());
//    size = 20;
}
Goal::Goal(int _x, int _y, int _s)  : GameElement("goal")
{
    xPos = _x;
    yPos = _y;
    size = _s;
}

void Goal::init(b2World* _b2dWorld){
    
    b2dWorld = _b2dWorld;
    physicsBody.setPhysics(0, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, size);
    
    physicsBody.setData(this);
    physicsBody.bodyDef.userData = this;
    ofSetCircleResolution(5);    
};


void Goal::draw()
{
    //ofLog() << ofToString(physicsBody.getPosition().x);
    //img.draw(physicsBody.getPosition().x-34, physicsBody.getPosition().y-38,size*2.5,size*2.5);
    
    ofNoFill();
    //physicsBody.draw();
}

void Goal::animate() {
    //physicsBody.destroy();
    //physicsBody = ofxBox2dCircle();
//    physicsBody.setPhysics(10, 1, 0.2);
//    physicsBody.addForce(ofVec2f(10, 10), 10);
//    physicsBody.setup(b2dWorld, xPos, yPos, size);
    //physicsBody.setData(this);
    //physicsBody.bodyDef.userData = this;
    cout <<"ANIMATE!";
}

bool Goal::checkPlayerCollision(Player &player) {
    
    return false;
}