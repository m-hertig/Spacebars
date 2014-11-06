#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxBox2d.h"
#include "ofxRP2A03.h"
#include "Level.h"
#include "Player.h"
#include "Enemy.h"
#include "Boxes.h"
#include "Obstacle.h"
#include "Goal.h"
#include "Particle.h"

#define NLEVELS 6
#define NPARTICLES 400

class ofApp : public ofxiOSApp {
	
public:
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    void touchAction(int x, int y);
    void playerUpdate();
    void boxesUpdate();
    void drawBoxes();
    void createEnemies();
    void createObstacles();
    void contactStart(ofxBox2dContactArgs &e);
	void contactEnd(ofxBox2dContactArgs &e);
    void createLevels();
    void initLevel();
    void displayNextBtn();
    
    ofTexture texFlimmer;
    int texW;
    int texH;
    int playerSize;
    int maxBoxes;
    int ballSize;
    int enemiesDestroyed;
    bool isGoal;
    bool isDead;
    bool subtractBoxLength;
    bool nextBtnDisplayed;
    bool gameFinished;
    int currentLevel;
    int boxesUsed;
    int boxLength;
    int maxBoxLength;
    int currentNumParticles;
    int nextBtnX,nextBtnY,nextBtnW,nextBtnH;
    ofImage bgImage;
    ofTrueTypeFont font;
    ofImage barsTexture;
    //ofxBox2dRect enemy;
    ofxBox2dCircle goalBody;
    ofVec2f goalPos;
    ofxBox2d  box2d;	//	the box2d world
    vector <ofSoundPlayer> collisionSounds;
    vector <ofSoundPlayer> loopSounds;
    int collisionSoundsIndex;
    int loopSoundsIndex;
    vector    <ofPtr<ofxBox2dCircle> >	circles;
    vector<Particle> particles;
    
    Level levels[NLEVELS];
    Boxes boxes;
    float levelFinishedTime;
    float playerDiedTime;
    float timeToNextLevel;
    float lastTonePlayedTime;
    
    unsigned char* flimmerPixels;
    void audioOut(float* output, int buffer_size, int n_channels);
    
    Player player;
    
private:
    
    static const int kPolyphonyVoices = 4;
    static const int kPresetTable[kPolyphonyVoices][6];
    static const int kKeyRange = 48;
    static const int kAudioSampleRate = 44100;
    static const int kAudioBufferSize = 1024;
    
    ofxRP2A03* tone_;
    
};


