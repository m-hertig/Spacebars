//
//  Particle.h
//  Exercice
//
//
//

#ifndef Exercice_Particle_h
#define Exercice_Particle_h
#include"ofMain.h"

class Particle {
    
public:
    Particle();
    void init(float _posx, float _posy, int _r,float _velX, float _velY, float _angle);
    void draw();
    void move();
    void moveCircular(float pivotX, float pivotY);
    
    int r;
    ofVec2f pos,vel,acc,oldpos;
    float angle;
    int age;
    
    int ID;

};

#endif
