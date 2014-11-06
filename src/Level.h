//
//  Level.h
//  box2dTest
//
//  Created by Hertig Martin on 17/10/2014.
//
//

#ifndef box2dTest_Level_h
#define box2dTest_Level_h
#include "ofMain.h"
#include "Enemy.h"
#include "Goal.h"
#include "Obstacle.h"

class Level  {
public:
    Level();
    void init(b2World* _b2dWorld);
    void setEnemies(vector<ofVec2f>,int _s);
    void setObstacles(vector<ofVec2f>,int _s);
    void setObstacle(int x, int y, int w, int h, int ang);
    void setGoal(ofVec2f);
    void destroy();

    int numEnemies;
    b2World* b2dWorld;
    Goal goal;
    vector<Obstacle> obstacles;
    Enemy** enemies; // an array of pointers
    //Obstacle** obstacles; // also an array of pointers
    
};

#endif
