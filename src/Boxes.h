//
//  Boxes.h
//  box2dTest
//
//  Created by Hertig Martin on 29/10/2014.
//
//

#ifndef box2dTest_Boxes_h
#define box2dTest_Boxes_h

#include "ofxRP2A03.h"
#include "GameElement.h"

class Boxes : public GameElement {
public:
    Boxes();
    Boxes(b2World* b2dWorld);
    void init(b2World* b2dWorld, int _maxBoxes, int _maxBoxLength);
    void draw();
    void update();
    void add(ofVec2f vec, int length);
    void clear();

    //void init(int _x, int _y, int _s, b2World* b2dWorld);
    vector <ofPtr<ofxBox2dRect> >	boxes;
    vector<int> boxLengths;
    b2World* b2dWorld;
    int maxBoxes;
    int maxBoxLength;
    
    
};

#endif
