
//
//  Enemy.h
//  box2dTest
//
//  Created by Hertig Martin on 29/10/2014.
//
//


#ifndef box2dTest_Enemy_h
#define box2dTest_Enemy_h

#include "Player.h"
#include "Particle.h"
#include "GameElement.h"


class Enemy : public GameElement {
    public:
    Enemy();
    Enemy(int x, int y, int s);
    void init(b2World* b2dWorld);
    void draw();
    void update();
    bool checkCollision(ofVec2f pos, float radius);
    bool isAlive;
    void destroyPhysicsBody();
    int xPos;
    int yPos;
    int size;
    int numParticles;
    int currentNumParticles;
    bool particlesCaged = true;
    ofTexture tex;
    ofPtr<ofxBox2dCircle> physicsBody;
    ofImage img;
    
    vector<Particle> particles;
};

#endif
