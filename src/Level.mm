#include "Level.h"


Level::Level(){
    numEnemies = 0;
    numObstacles = 0;
};
void Level::init(b2World* _b2dWorld){
    b2dWorld = _b2dWorld;
    goal.init(b2dWorld);
    
    for (int i=0; i<numEnemies;i++) {
        enemies[i]->init(b2dWorld);
    }
    for (int i=0; i<numObstacles;i++) {
        obstacles[i]->init(b2dWorld);
    }
};

void Level::setEnemies(vector<ofVec2f> vec, int _s){
    numEnemies = vec.size();
    enemies = new Enemy*[numEnemies];
    for (int i=0; i<vec.size(); i++) {
        enemies[i] = new Enemy(vec[i].x,vec[i].y,_s);
    }
};

void Level::setObstacles(vector<ofVec2f> vec, int _s){
    numObstacles = vec.size();
    obstacles = new Obstacle*[numObstacles];
    for (int i=0; i<vec.size(); i++) {
        obstacles[i] = new Obstacle(vec[i].x,vec[i].y,_s);
    }

};

void Level::setGoal(ofVec2f vec){
    //goal.init(vec.x, vec.y, 30, b2dWorld);
    goal = *new Goal(vec.x, vec.y, 30);
    
};

void Level::destroy() {
    goal.physicsBody.destroy();
    for (int i=0; i<numObstacles; i++) {
        obstacles[i]->physicsBody.destroy();
    }
    for (int i=0; i<numEnemies; i++) {
        enemies[i]->physicsBody->destroy();
    }
    
}

