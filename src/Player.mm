#include "Player.h"

Player::Player() : GameElement("player") {
    
}

Player::Player(int _x, int _y, int _s, b2World* b2dWorld) : GameElement("player")
{
    xPos = _x;
    yPos = _y;
    size = _s;
    
    physicsBody.setPhysics(10, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, size);
}

void Player::init(int x, int y, int s, b2World* b2dWorld){
    xPos = x;
    yPos = y;
    size = s;
    
    physicsBody.setPhysics(10, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, size);

    physicsBody.setData(this);
    physicsBody.bodyDef.userData = this;
    //img.loadImage("lines.png");
    
    //cout << tag << endl;
    int resolution = 15;
    spherePrimitive.set(size, resolution);
    sphereVerticles = spherePrimitive.getMesh().getVertices();
    sphereMesh.setMode(OF_PRIMITIVE_LINES);
    for (int i=0; i<sphereVerticles.size(); i++) {
        ofVec3f newVec(sphereVerticles[i].x+ofRandom(-3,3),sphereVerticles[i].y+ofRandom(-3,3),sphereVerticles[i].z+ofRandom(-3,3));
        sphereMesh.addVertex(newVec);
    }
};

void Player::draw()
{
    ofNoFill();
    ofSetLineWidth(1.4);
    ofPushMatrix();
    ofTranslate(xPos, yPos);
    ofSetColor(255, 255, 255);
    ofRotate(physicsBody.getRotation());
    sphereMesh.draw();
    //ofDrawSphere(0, 0, size);
    //img.draw(-30, -30, size*2.5,size*2.5);
    ofPopMatrix();
}

void Player::update()
{
    xPos = physicsBody.getPosition().x;
    yPos = physicsBody.getPosition().y;
    ofVec2f vel = physicsBody.getVelocity();
    
    //ofLog() << yPos;
    if (yPos<0-size) {
        yPos = ofGetHeight()+size;
        physicsBody.setPosition(xPos, yPos);
        physicsBody.setVelocity(vel);
    } else if (yPos>ofGetHeight()+size) {
        yPos = 0-size;
        physicsBody.setPosition(xPos, yPos);
        physicsBody.setVelocity(vel);
    } else if (xPos<0-size) {
        xPos = ofGetWidth()+size;
        physicsBody.setPosition(xPos, yPos);
        physicsBody.setVelocity(vel);
    } else if (xPos>ofGetWidth()+size) {
        xPos = 0-size;
        physicsBody.setPosition(xPos, yPos);
        physicsBody.setVelocity(vel);
    }
}