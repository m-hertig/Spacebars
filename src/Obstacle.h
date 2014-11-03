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
    Obstacle(int x, int y, int s);
    void init(b2World* b2dWorld);
    void draw();
    int xPos;
    int yPos;
    int size;
    ofxBox2dRect physicsBody;
};

#endif
