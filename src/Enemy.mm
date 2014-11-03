#include "Enemy.h"


Enemy::Enemy()  : GameElement("enemy") {
    
}
Enemy::Enemy(int _x, int _y, int _s) : GameElement("enemy")
{
    xPos = _x;
    yPos = _y;
    size = _s;
}

void Enemy::init(b2World* b2dWorld){
    
    img.loadImage("cymbal.png");
    //img.getTextureReference().setTextureWrap( GL_REPEAT, GL_REPEAT );
    physicsBody = ofPtr<ofxBox2dCircle>(new ofxBox2dCircle);
    physicsBody->setPhysics(0, 1, 0.2);
    ofSetCircleResolution(10);
    physicsBody->setup(b2dWorld, xPos, yPos, size);
    physicsBody->setData(this);
    physicsBody->bodyDef.userData = this;
    numParticles = 300;
    isAlive = true;
    currentNumParticles = 0;
    for (int i=0; i<numParticles; i++) {
        Particle p = Particle();
        p.init(xPos+ofRandom(-size*0.7,size*0.7),yPos+ofRandom(-size*0.7,size*0.7),1,0,ofRandom(-4,-3),ofRandom(5));
        particles.push_back(p);
    }
};

void Enemy::update() {
    if (currentNumParticles<numParticles) {
        currentNumParticles++;
    }
    if (particlesCaged){
        for(int i=0; i<currentNumParticles; i++)
        {
            particles[i].moveCircular(xPos,yPos);
        }
    } else {
        for(int i=0; i<currentNumParticles; i++)
        {
            particles[i].move();
        }
    }
}

void Enemy::draw()
{
    for(int i=0; i<currentNumParticles; i++)
    {
        particles[i].draw();
    }
    //ofSetColor(255, 0, 0);
    ofNoFill();
    if (particlesCaged) {
       physicsBody->draw();
    }
    //img.draw(xPos, yPos,size*2,size*2);
    //img.bind();
    //ofDrawBox(physicsBody.getPosition().x, physicsBody.getPosition().y, size);
}

bool Enemy::checkCollision(ofVec2f pos, float radius) {
    ofVec2f myPos = ofVec2f(xPos,yPos);
    float criticalDist = radius+size+3;
    
    if (pos.distance(myPos)<criticalDist) {
        return true;
    } else {
        return false;
    }
}

void Enemy::destroyPhysicsBody() {
    physicsBody->destroy();
}