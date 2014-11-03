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
    img.loadImage("jeannine2.png");
    physicsBody.setPhysics(0, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, size);
    
    physicsBody.setData(this);
    physicsBody.bodyDef.userData = this;
    ofSetCircleResolution(5);
    
//    int xPoint = 0;
//	int yPoint = 0;
//    
//    ofPtr <ofxBox2dEdge> edge = ofPtr<ofxBox2dEdge>(new ofxBox2dEdge);
//    for (int j=0; j<4; j++) {
//        for (int i=0; i<50; i++) {
//            
//            float x = xPoint;
//            float y = yPoint;
//            edge.get()->addVertex(x, y);
//            edge.get()->create(b2dWorld);
//            xPoint += 10;
//            yPoint += 10;
//        }
//        
//        edges.push_back(edge);
//        xPoint = 200*j;
//        yPoint = 0;
//    }
};


void Goal::draw()
{
    //ofLog() << ofToString(physicsBody.getPosition().x);
    img.draw(physicsBody.getPosition().x-34, physicsBody.getPosition().y-38,size*2.5,size*2.5);
    
    for (int i=0; i<edges.size(); i++) {
		edges[i].get()->draw();
	}
    ofSetLineWidth(2);
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