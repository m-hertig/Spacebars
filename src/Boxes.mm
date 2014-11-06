#include "Boxes.h"

Boxes::Boxes() : GameElement("box"){
    
}

void Boxes::init(b2World* _b2dWorld, int _maxBoxes, int _maxBoxLength){

    b2dWorld = _b2dWorld;
    maxBoxes = _maxBoxes;
    maxBoxLength = _maxBoxLength;
};

void Boxes::draw()
{
    for(int i=0; i<boxes.size(); i++) {
		ofFill();
		ofSetHexColor(0xffffff);
        
        ofVec2f pos = boxes[i].get()->getPosition();
        int length = boxLengths[i];
        float x = pos.x;
        float y = pos.y;
        
        //boxes[i].get()->draw();
        ofDrawBox(x, y, 0,6,6,length);
        ofNoFill();
        ofSetLineWidth(2);
        //barsTexture.getTextureReference().bind();
        ofSetHexColor(0xffffff);
        ofSetLineWidth(1);
	}
}

void Boxes::update()
{
    for(int i=0; i<boxes.size(); i++) {
        ofVec2f pos = boxes[i].get()->getPosition();
        float xPos = pos.x;
        float yPos = pos.y;
        if (yPos < -maxBoxLength) {
            yPos = ofGetHeight()+maxBoxLength;
            boxes[i].get()->setPosition(xPos, yPos);
            
        } else {
            //yPos = yPos-2;
            boxes[i].get()->setVelocity(0, -3);
            //ofLog() << boxes[i].get()->getVelocity();
        }
    }
}

void Boxes::add(ofVec2f vec,int length) {
    if (boxes.size() > maxBoxes) {
        //ofxBox2dRect* boxToErase = boxes.front().get();
        //delete boxToErase;
        boxes.front().get()->destroy();
        boxes.erase(boxes.begin());
        boxLengths.erase(boxLengths.begin());
    }
    
    if (boxes.size() > 0) {
        ofVec2f lastBoxPos = boxes[boxes.size()-1].get()->getPosition();
        if (lastBoxPos.distance(vec)<10)   {
            return;
        }
    }
    ofPtr<ofxBox2dRect> rect = ofPtr<ofxBox2dRect>(new ofxBox2dRect);
    rect.get()->setPhysics(1000, 0.2, 0.5);
    rect.get()->setup(b2dWorld, vec.x, vec.y, 10, 10);
    //rect.get()->enableGravity(false);
    rect.get()->setVelocity(0, -5);
//    rect.get()->setData(this);
//    rect.get()->bodyDef.userData = this;
    boxes.push_back(rect);
    boxLengths.push_back(length);
    //boxes.back().get()->bodyDef = b2_staticBody;

}

void Boxes::clear() {
    boxes.clear();
    boxLengths.clear();
}