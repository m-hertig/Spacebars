//
//  Player.h
//  box2dTest
//
//  Created by Hertig Martin on 29/10/2014.
//
//

#ifndef box2dTest_Player_h
#define box2dTest_Player_h

#include "GameElement.h"

class Player : public GameElement {
public:
    Player();
    Player(int _x, int _y, int _s, b2World* b2dWorld);
    void init(int x, int y, int s, b2World* b2dWorld);
    void draw();
    void update();

    //void init(int _x, int _y, int _s, b2World* b2dWorld);
    int xPos;
    int yPos;
    int size;
    ofImage img;
    ofSpherePrimitive spherePrimitive;
    vector<ofVec3f> sphereVerticles;
    ofMesh sphereMesh;
    ofxBox2dCircle physicsBody;
    
    //string tag="player";
};

#endif
