#include "Enemy.h"


Enemy::Enemy()  : GameElement("enemy") {
    
}
Enemy::Enemy(int _x, int _y, int _s) : GameElement("enemy")
{
    xPos = _x;
    yPos = _y;
    size = _s;
}

void Enemy::init(b2World* _b2dWorld){
    
    b2dWorld = _b2dWorld;
    img.loadImage("cymbal.png");
    //img.getTextureReference().setTextureWrap( GL_REPEAT, GL_REPEAT );
    ofSetCircleResolution(17);
    ofPtr<ofxBox2dCircle> circle = ofPtr<ofxBox2dCircle>(new ofxBox2dCircle);
    circle.get()->setPhysics(0, 0.2, 0.5);
    //circle.get()->enableGravity(false);
    circle.get()->setup(b2dWorld, xPos, yPos, size);
    circle.get()->setData(this);
    circle.get()->bodyDef.userData = this;
    physicsBodies.push_back(circle);

    numParticles = 200;
    isAlive = true;
    currentNumParticles = 0;
    for (int i=0; i<numParticles; i++) {
        Particle p = Particle();
        p.init(xPos+ofRandom(size*0.4,size*0.7),yPos+ofRandom(size*0.4,size*0.7),1,0,ofRandom(-4,-3),ofRandom(5));
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
    //ofSetLineWidth(2);
//    for (int i=0; i<physicsBodies.size(); i++) {
//        physicsBodies[i]->draw();
//    }
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
    
    for (int i=0; i<physicsBodies.size(); i++) {
        physicsBodies[i]->body->SetActive(false);
        //b2dWorld->DestroyBody(physicsBodies[i]->body);
        physicsBodies[i]->destroy();
    }
    physicsBodies.clear();
    cout << "ENEMY CLEARED" << endl;
   // delete physicsBody;
    //physicsBody.destroy();
}