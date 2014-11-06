//
//  Goal.h
//  box2dTest
//
//  Created by Hertig Martin on 29/10/2014.
//
//

#ifndef box2dTest_Goal_h
#define box2dTest_Goal_h

#include "Player.h"

#include "GameElement.h"

class Goal : public GameElement {
public:
    Goal();
    Goal(int x, int y, int s);
    void init(b2World* b2dWorld);
    void draw();
    void animate();
    bool checkPlayerCollision(Player &player);
    int xPos;
    int yPos;
    int size;
    ofImage img;
    b2World* b2dWorld;
    ofxBox2dCircle physicsBody;
};

#endif
