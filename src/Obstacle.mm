#include "Obstacle.h"


Obstacle::Obstacle() : GameElement("obstacle") {
    
}
Obstacle::Obstacle(int _x, int _y, int _s) : GameElement("obstacle")
{
    xPos = _x;
    yPos = _y;
    size = _s;
    w = _s;
    h = _s;
    ang = 0;
}

Obstacle::Obstacle(int _x, int _y, int _w,int _h,int _ang) : GameElement("obstacle")
{
    xPos = _x;
    yPos = _y;
    w = _w;
    h = _h;
    ang = _ang;
}

void Obstacle::init(b2World* b2dWorld){

    physicsBody.setPhysics(0, 1, 0.2);
    physicsBody.setup(b2dWorld, xPos, yPos, w, h);
    physicsBody.setRotation(ang);
    if (true) {
        physicsBody.addRepulsionForce(100, 100, 100);
    }
    physicsBody.setData(this);
    physicsBody.bodyDef.userData = this;
    cout << "INIT OBSTACLE" << endl;
    
//    int xPoint = 0;
//	int yPoint = 0;
//    ofPtr <ofxBox2dEdge> edge = ofPtr<ofxBox2dEdge>(new ofxBox2dEdge);
//        for (int i=0; i<52; i++) {
//            
//            float x = xPoint;
//            float y = yPoint;
//            edge.get()->addVertex(x, y);
//            edge.get()->create(b2dWorld);
//            xPoint += ofGetWidth()/50;
//            yPoint += ofGetHeight()/50;
//        }
//        edges.push_back(edge);
};

void Obstacle::destroyPhysicsBody() {
    physicsBody.body->SetActive(false);
    physicsBody.destroy();
}

void Obstacle::draw()
{
//    for (int i=0; i<edges.size(); i++) {
//        ofSetLineWidth(4);
//		edges[i].get()->draw();
//	}
    ofFill();
    ofSetLineWidth(2);
    ofSetColor(255, 255, 255);
    ofPushMatrix();
    ofTranslate(xPos, yPos);
    ofRotate(ang);
    ofDrawBox(0, 0, 0,w,h,00);
    ofPopMatrix();
    //physicsBody.draw();
    //ofDrawSphere(xPos, yPos, size);
}
