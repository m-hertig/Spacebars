#include "ofApp.h"
#include <Box2d.h>


//--------------------------------------------------------------
void ofApp::setup(){
    
    /*
    int x = 200;
    
    int * arrTest;
    arrTest = new int[x];
    
    for (int i = 0; i < 20; i++)
    {
        arrTest[i] = i;
        std::cout << i << std::endl;
    }*/
    
    box2d.init();
	box2d.setGravity(0, 2);
	//box2d.createBounds();
    //box2d.createGround();
	box2d.setFPS(30.0);
	//box2d.registerGrabbing();
    
    ofEnableSmoothing();
    
    for (int i=0; i<NPARTICLES; i++) {
        Particle p = Particle();
        p.init(ofRandom(ofGetWidth()),ofGetHeight(),1,0,ofRandom(-5,-3),ofRandom(90));
        particles.push_back(p);
        //particles[i].init(ofRandom(ofGetWidth()),ofGetHeight()+10,1,0,ofRandom(-5,5),1);
    }
    currentNumParticles = 0;
    currentLevel = 0;
    playerSize = 25;
    font.loadFont("fonts/Sudbury_Basin_3D.ttf", 18);
    
    createLevels();

    bgImage.loadImage("dots.png");
    for (int i=0; i<4; i++) {
        ofSoundPlayer pianoSound = ofSoundPlayer();
        string path = "sounds/sfx/"+ofToString(i+1)+".mp3";
        cout << path << endl;
        pianoSound.loadSound(path);
        pianoSounds.push_back(pianoSound);
    }
    pianoSoundsIndex = 0;
    
    //barsTexture.loadImage("texnew.jpg");
    //barsTexture.getTextureReference().setTextureWrap( GL_REPEAT, GL_REPEAT );
    
    ofSoundStreamSetup(2, 0, this, kAudioSampleRate, kAudioBufferSize, 4);
    tone_ = new ofxRP2A03();
    
    maxBoxes = 50;
    maxBoxLength = 23;
    boxLength = maxBoxLength;
    subtractBoxLength = true;
    
    initLevel();
    
//    goalPos = ofVec2f(100,100);
//    goalBody.setPhysics(0,0.5,0.5);
//    goalBody.setup(box2d.getWorld(), goalPos, 30);
//    goalBody.enableGravity(false);
    
    box2d.enableEvents();
    
    // register the listener so that we get the events
	ofAddListener(box2d.contactStartEvents, this, &ofApp::contactStart);
	ofAddListener(box2d.contactEndEvents, this, &ofApp::contactEnd);
    
    //enemy.setPhysics(0,1,1);
    //enemy.setup(box2d.getWorld(), 300,400,10,100);
    //enemy.isFixed();
    isGoal = false;
    isDead = false;
    levelFinishedTime = 0;
    lastTonePlayedTime = 0;
    boxesUsed = 0;
    texW = 200;
    texH = 200;
    
    texFlimmer.allocate(texW,texH,GL_LUMINANCE);
    
    flimmerPixels = new unsigned char [texW*texH];
    
	// gray pixels, set them randomly 0 or 255
	for (int i = 0; i < texW*texH; i++){
        // random 0 or 1
        int a=rand()%2;
		flimmerPixels[i] = (unsigned char)(a * 255);
	}
}

//--------------------------------------------------------------
void ofApp::update(){
    
    //    for (int i = 0; i < texW; i++){
    //		for (int j = 0; j < texH; j++){
    //            // random 0 or 1
    //            int a=rand()%2;
    //			flimmerPixels[j*texW+i] = (unsigned char)(a * 255);
    //		}
    //	}
    //    texFlimmer.loadData(flimmerPixels, texW,texH, GL_LUMINANCE);
    //
    
    if (currentNumParticles<NPARTICLES) {
        currentNumParticles++;
    }
    for(int i=0; i<currentNumParticles; i++)
    {
        particles[i].move();
    }
    
	box2d.update();
    boxes.update();
    player.update();
    
    for (int i=0; i<levels[currentLevel].numEnemies; i++) {
        levels[currentLevel].enemies[i]->update();
    }
    
    //isGoal = levels[currentLevel].goal.checkPlayerCollision(player);
    if (isGoal) {
        if((ofGetElapsedTimef()-levelFinishedTime)>3) {
            // Go to next Level
            if (currentLevel<NLEVELS-1) {
                levels[currentLevel].destroy();
                player.physicsBody.destroy();
                currentLevel++;
                initLevel();
            } else {
                ofSetHexColor(0xffffff);
                font.drawString("GAME FINISHED!!", ofGetWidth()/2, ofGetHeight()/2);
            }
            isGoal = false;
//            boxesUsed = 0;
//            float goalX = ofRandom(100,ofGetWidth()-100);
//            float goalY = ofRandom(100, ofGetHeight()-100);
//            goalPos = ofVec2f(goalX,goalY);
//            goalBody.setPosition(goalPos);
//            goalBody.enableGravity(false);
        }
    }
    
//    for (int i=0; i<levels[currentLevel].numEnemies ; i++) {
//        bool hasCollision = levels[currentLevel].enemies[i]->checkPlayerCollision(player);
//        if (hasCollision) {
//            isDead = true;
//            playerDiedTime = ofGetElapsedTimef();
//        }
//    }
   
    if (isDead == true && abs(ofGetElapsedTimef()-playerDiedTime)>3 && isGoal== false) {
        isDead = false;
        levels[currentLevel].destroy();
        player.physicsBody.destroy();
        initLevel();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofBackgroundHex(0x000000);
    //bgImage.draw(0, 0);
    ofDrawBitmapString("Level "+ofToString(currentLevel+1),20,20);
    //enemy.draw();
    //ofDrawBox(enemy.getPosition().x,enemy.getPosition().y,0,enemy.getWidth(),enemy.getHeight(),10);
    
    for(int i=0; i<currentNumParticles; i++)
    {
        particles[i].draw();
    }
    
    //goalBody.draw();
    boxes.draw();
    player.draw();
    levels[currentLevel].goal.draw();
    
    for (int i=0; i<levels[currentLevel].numEnemies; i++) {
        levels[currentLevel].enemies[i]->draw();
    }
    
    for (int i=0; i<levels[currentLevel].numObstacles; i++) {
        levels[currentLevel].obstacles[i]->draw();
    }
    
    if (isGoal) {
        ofSetHexColor(0xffffff);
        font.drawString("GOAL !!", ofGetWidth()/2-40, ofGetHeight()/2);
    }
    
    if (isDead) {
        ofSetHexColor(0xffffff);
        font.drawString("DEAD !!", ofGetWidth()/2, ofGetHeight()/2);
    }
}

// Preset Program Table:
//   {"WaveForm", "PitchEnvType", "PitchEnvRate",
//    "PitchEnvDepth", "VolumeEnvType, "VolumeEnvRate"}
const int ofApp::kPresetTable[kPolyphonyVoices][6] = {
    {0, 2, 25, 100, 1, 25},
    {3, 0, 50, 100, 0, 50},
    {1, 0, 25, 100, 2, 25},
    {2, 0, 50,   0, 0, 50}
};


//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    boxes.clear();
    boxLength = maxBoxLength;
    touchAction(touch.x, touch.y);
    //ofLog() << "touch";
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchAction(touch.x, touch.y);
    if (boxLength == 0) {
        subtractBoxLength = false;
    } else if (boxLength == maxBoxLength) {
        subtractBoxLength = true;
    }
    if (subtractBoxLength) {
        boxLength = boxLength-1;
    } else {
        boxLength = boxLength+1;
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    //    for (int i=0; i<boxes.size(); i++) {
    //        boxes[i].get()->destroy();
    //    }
    //boxes.clear();
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}

void ofApp::contactStart(ofxBox2dContactArgs &e) {
    // its a goal only if two circles collide
    if (e.b->GetBody()->GetUserData() != nil   && e.a->GetBody()->GetUserData() != nil )
    {
        
        string userDataA = ((GameElement *)e.a->GetBody()->GetUserData())->tag;
        string userDataB = ((GameElement *)e.b->GetBody()->GetUserData())->tag;
        cout << userDataA+" "+userDataB << endl;
//        if ((userDataA == "player" && userDataB == "goal") || (userDataA == "goal" && userDataB == "player"))
//        {
//            cout << "GOAL" << endl;
//            isGoal = true;
//            levelFinishedTime = ofGetElapsedTimef();
//            levels[currentLevel].goal.animate();
////        } else if ((userDataA == "player" && userDataB == "enemy") || (userDataA == "enemy" && userDataB == "player"))
////        {
//////            cout << "DEAD" << endl;
//////            isDead= true;
//////            playerDiedTime = ofGetElapsedTimef();
//        }
        if ((userDataA == "enemy" || userDataB == "enemy" ) &&
                    (userDataA == "player" || userDataB == "player"))
        {
            for (int i=0; i<levels[currentLevel].numEnemies; i++) {
                bool isColliding = levels[currentLevel].enemies[i]->checkCollision(player.physicsBody.getPosition(),player.physicsBody.getRadius());
                if (isColliding && levels[currentLevel].enemies[i]->isAlive){
                    levels[currentLevel].enemies[i]->particlesCaged = false;
                    levels[currentLevel].enemies[i]->destroyPhysicsBody();
                    cout << "enemy destroyed";
                    enemiesDestroyed++;
                }
            }
            if (enemiesDestroyed>=levels[currentLevel].numEnemies) {
                isGoal = true;
                levelFinishedTime = ofGetElapsedTimef();
            }
            pianoSounds[pianoSoundsIndex].play();
            if (pianoSoundsIndex<pianoSounds.size()-1) {
                pianoSoundsIndex++;
            } else {
                pianoSoundsIndex = 0;
            }
        }
    }
    
    //int userData = e.a->GetUserData();
}

void ofApp::contactEnd(ofxBox2dContactArgs &e) {
    //ofLog() << "ContactEnd";
	if(e.a != NULL && e.b != NULL) {
        
	}
}

void ofApp::initLevel() {
    enemiesDestroyed = 0;
    levels[currentLevel].init(box2d.getWorld());
    boxes.clear();
    boxes.init(box2d.getWorld(), maxBoxes, maxBoxLength*10);
    player.init(ofGetWidth()/2, ofGetHeight()/2, playerSize, box2d.getWorld());
}


void ofApp::touchAction(int x, int y) {
//    for (int i=0; i<pianoSounds.size(); i++) {
//        pianoSounds[i].stop();
//    }
//    pianoSounds[abs(boxLength)].play();
    ofVec2f vec = ofVec2f(x,y);
    boxes.add(vec,boxLength*10);
}

void ofApp::audioOut(float *output, int buffer_size, int n_channels) {
    // clear buffer
    for (int i = 0; i < buffer_size; ++i) {
        output[i * n_channels] = 0;
        output[i * n_channels + 1] = 0;
    }
    
    tone_->audioOut(output, buffer_size, n_channels);
}

void ofApp::createLevels() {
    vector<ofVec2f> enemies;
    vector<ofVec2f> obstacles;
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(200,100));
    enemies.push_back(ofVec2f(200,300));
    enemies.push_back(ofVec2f(200,400));
    enemies.push_back(ofVec2f(400,500));
    levels[0].setEnemies(enemies, 50);
    levels[0].setObstacles(obstacles, 10);
    //levels[0].setGoal(ofVec2f(ofGetWidth()/2,400));
    enemies.clear();
    obstacles.clear();
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(500,400));
//    obstacles.push_back(ofVec2f(300,300));
//    obstacles.push_back(ofVec2f(800,600));
    levels[1].setGoal(ofVec2f(600,200));
    levels[1].setEnemies(enemies, 50);
    levels[1].setObstacles(obstacles, 10);
    enemies.clear();
    obstacles.clear();
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(500,400));
//    obstacles.push_back(ofVec2f(600,400));
//    obstacles.push_back(ofVec2f(600,100));
    levels[2].setGoal(ofVec2f(600,300));
    levels[2].setEnemies(enemies, 50);
    levels[2].setObstacles(obstacles, 10);
    enemies.clear();
    obstacles.clear();
    
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(500,400));
    enemies.push_back(ofVec2f(600,600));
//    obstacles.push_back(ofVec2f(300,300));
//    obstacles.push_back(ofVec2f(600,400));
    levels[3].setGoal(ofVec2f(400,200));
    levels[3].setEnemies(enemies, 50);
    levels[3].setObstacles(obstacles, 10);
    enemies.clear();
    obstacles.clear();
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(500,400));
//    obstacles.push_back(ofVec2f(300,300));
//    obstacles.push_back(ofVec2f(400,400));
//    obstacles.push_back(ofVec2f(500,500));
//    obstacles.push_back(ofVec2f(800,600));
    levels[4].setGoal(ofVec2f(100,200));
    levels[4].setEnemies(enemies, 100);
    levels[4].setObstacles(obstacles, 10);
    enemies.clear();
    obstacles.clear();
    
}

