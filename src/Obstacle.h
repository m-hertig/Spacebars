//
//  Obstacle.h
//  box2dTest
//
//  Created by Hertig Martin on 29/10/2014.
//
//


#ifndef box2dTest_Obstacle_h
#define box2dTest_Obstacle_h


#include "GameElement.h"

class Obstacle : public GameElement  {
public:
    Obstacle();
    Obstacle(int _x, int _y, int _s);
    Obstacle(int _x, int _y, int _w,int _h,int _ang);
    void init(b2World* b2dWorld);
    void destroyPhysicsBody();
    void draw();
    int xPos;
    int yPos;
    int w,h,ang;
    bool addForce;
    int xPosStart, xPosEnd, yPosStart, yPosEnd;
    int size;
    ofxBox2dRect physicsBody;
	//vector <ofPtr<ofxBox2dEdge> >       edges;
};

#endif
