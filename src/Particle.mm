//
//  Particle.mm
//  Exercice
//
//

#include "Particle.h"

Particle::Particle(){};

void Particle::draw(){

    ofSetColor(255,255,255);

    ofFill();
    //ofCircle(posx,posy,r);
    ofRect(pos.x,pos.y,r,r);
};


void Particle::move(){
        
    if(pos.y>ofGetHeight()+r || pos.y < 0-r || pos.x>ofGetWidth()+r || pos.x < 0-r) {
            pos.x=ofRandom(ofGetWidth());
            pos.y=ofGetHeight();
    }
        pos.x+=vel.x;
        pos.y+=vel.y;

};

void Particle::moveCircular(float pivotX,float pivotY) {
    angle += 0.0001;
    pos.rotate(angle, ofVec2f(pivotX,pivotY));
    //oldpos = pos;
    //pos += vel;
    age++;
}


void Particle::init(float _posx, float _posy, int _r, float _velX, float _velY, float _angle){
    pos.x = _posx;
    pos.y = _posy;
    r = _r;
    vel.x = _velX;
    vel.y = _velY;
    angle = _angle;
    age = 0;
};