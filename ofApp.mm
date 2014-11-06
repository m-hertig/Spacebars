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

    nextBtnX=ofGetWidth()/2;
    nextBtnY=ofGetHeight()/5*4;
    nextBtnW=300;
    nextBtnH=70;
    nextBtnDisplayed = false;
    gameFinished = false;
    
    for (int i=0; i<NPARTICLES; i++) {
        Particle p = Particle();
        p.init(ofRandom(ofGetWidth()),ofGetHeight(),1,0,ofRandom(-5,-3),ofRandom(90));
        particles.push_back(p);
        //particles[i].init(ofRandom(ofGetWidth()),ofGetHeight()+10,1,0,ofRandom(-5,5),1);
    }
    currentNumParticles = 0;
    currentLevel = 0;
    playerSize = 25;
    font.loadFont("fonts/OratorStd.otf", 50);
    
    createLevels();

    bgImage.loadImage("dots.png");
    for (int i=0; i<3; i++) {
        ofSoundPlayer collisionSound = ofSoundPlayer();
        string path = "sounds/sfx/"+ofToString(i)+".mp3";
        collisionSound.loadSound(path);
        collisionSounds.push_back(collisionSound);
    }
    for (int i=0; i<7; i++) {
        ofSoundPlayer loopSound = ofSoundPlayer();
        string path = "sounds/test/"+ofToString(i)+".mp3";
        cout << path << endl;
        loopSound.loadSound(path);
        loopSounds.push_back(loopSound);
    }
    collisionSoundsIndex = 0;
    loopSoundsIndex = -1;
    
    //barsTexture.loadImage("texnew.jpg");
    //barsTexture.getTextureReference().setTextureWrap( GL_REPEAT, GL_REPEAT );
    
    ofSoundStreamSetup(2, 0, this, kAudioSampleRate, kAudioBufferSize, 4);
    tone_ = new ofxRP2A03();
    
    maxBoxes = 50;
    maxBoxLength =30;
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
    
//    texFlimmer.allocate(texW,texH,GL_LUMINANCE);
//    
//    flimmerPixels = new unsigned char [texW*texH];
//    
//	// gray pixels, set them randomly 0 or 255
//	for (int i = 0; i < texW*texH; i++){
//        // random 0 or 1
//        int a=rand()%2;
//		flimmerPixels[i] = (unsigned char)(a * 255);
//	}
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
                nextBtnDisplayed=true;
            } else {
                gameFinished = true;
            }
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
   
    if (tone_->isPlaying() && (ofGetElapsedTimef()-lastTonePlayedTime)>0.1) {
        tone_->stop();
    }
    
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
    ofDrawBitmapString("Level "+ofToString(currentLevel+1),15,25);
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
    
    for (int i=0; i<levels[currentLevel].obstacles.size(); i++) {
        levels[currentLevel].obstacles[i].draw();
    }
    
    if (isGoal) {
        ofSetHexColor(0xffffff);
        //ofDrawBitmapStringHighlight("CLEAR !!", ofGetWidth()/2, ofGetHeight()/2);
        if ((ofGetElapsedTimef()-levelFinishedTime)<3) {
            string msg ="CLEAR";
            font.drawString(msg, ofGetWidth()/2-font.stringWidth(msg)/2, ofGetHeight()/2-font.stringHeight(msg)/2);
        }
    }
    
    if (gameFinished) {
        ofSetHexColor(0xffffff);
        string msg ="WELL DONE";
        font.drawString(msg, ofGetWidth()/2-font.stringWidth(msg)/2, ofGetHeight()/2-font.stringHeight(msg)/2);
    }
    
    if (isDead) {
        ofSetHexColor(0xffffff);
        font.drawString("DEAD !!", ofGetWidth()/2, ofGetHeight()/2);
    }
    
    if (nextBtnDisplayed) {
        displayNextBtn();
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
    if (nextBtnDisplayed && touch.x>nextBtnX-nextBtnW/2 && touch.x<nextBtnX+nextBtnW/2 && touch.y>nextBtnY-nextBtnH/2 && touch.y<nextBtnY+nextBtnH/2) {
        nextBtnDisplayed = false;
        levels[currentLevel].destroy();
        player.physicsBody.destroy();
        currentLevel++;
        isGoal = false;
        initLevel();false;
        cout << "BTN PUSHED!" << endl;
    } else {
        boxes.clear();
        boxLength = maxBoxLength;
        touchAction(touch.x, touch.y);
        //ofLog() << "touch";
    }
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
//        cout << userDataA+" "+userDataB << endl;
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
                    //cout << "enemy destroyed";
                    enemiesDestroyed++;
                    collisionSounds[abs(ofRandom(collisionSounds.size()-1))].play();
                }
                if (enemiesDestroyed>=levels[currentLevel].numEnemies) {
                    isGoal = true;
                    cout << "LEVEL FINISHED";
                    levelFinishedTime = ofGetElapsedTimef();
                    loopSounds[loopSoundsIndex].play();
                    loopSounds[loopSoundsIndex].setLoop(true);
//                    for (int j=0; j<=loopSoundsIndex; j++) {
//                        loopSounds[j].play();
//                        loopSounds[j].setLoop(true);
//                    }
                }
            }
        }
    }
    
    //int userData = e.a->GetUserData();
}

void ofApp::contactEnd(ofxBox2dContactArgs &e) {
    //ofLog() << "ContactEnd";
}

void ofApp::initLevel() {
    enemiesDestroyed = 0;
    levels[currentLevel].init(box2d.getWorld());
    boxes.clear();
    boxes.init(box2d.getWorld(), maxBoxes, maxBoxLength*10);
    player.init(ofGetWidth()/2, ofGetHeight()/2, playerSize, box2d.getWorld());
    for (int i=0; i<loopSounds.size(); i++) {
        if (loopSounds[i].getIsPlaying()) {
            loopSounds[i].stop();
        }
    }
    if (loopSoundsIndex<loopSounds.size()-1) {
        loopSoundsIndex++;
    } else {
        loopSoundsIndex = 0;
    }
}


void ofApp::touchAction(int x, int y) {
//    for (int i=0; i<collisionSounds.size(); i++) {
//        collisionSounds[i].stop();
//    }
//    collisionSounds[abs(boxLength)].play();
    ofVec2f vec = ofVec2f(x,y);
    boxes.add(vec,boxLength*10);
    
    // Configure sound
    int note_number = 36 + x / ofGetWidth() * kKeyRange;
    //note_number = 36;
    int rect_height = ofGetHeight() / kPolyphonyVoices;
    //int program_index = x  / rect_height;
    int program_index = 2;
    if (program_index == 4) program_index = 3;
    tone_->setProgram(kPresetTable[program_index]);
    int tone_y = static_cast<int>(y) % rect_height;
    int volume_env_rate = static_cast<float>(tone_y) / rect_height * 127;
    tone_->setVolumeEnvRate(volume_env_rate);
    tone_->play(note_number,
                1.0,    // volume
                0.5);  // pan
    lastTonePlayedTime = ofGetElapsedTimef();
}

void ofApp::audioOut(float *output, int buffer_size, int n_channels) {
    // clear buffer
    for (int i = 0; i < buffer_size; ++i) {
        output[i * n_channels] = 0;
        output[i * n_channels + 1] = 0;
    }
    
    tone_->audioOut(output, buffer_size, n_channels);
}

void ofApp::displayNextBtn() {
    ofSetHexColor(0xffffff);
    ofNoFill();
    ofDrawBox(nextBtnX, nextBtnY,0, nextBtnW, nextBtnH,1);
    ofDrawBitmapString("Take me to the next level", nextBtnX-100, nextBtnY+5);
}

void ofApp::createLevels() {
    vector<ofVec2f> enemies;
    
    enemies.push_back(ofVec2f(200,400));
    enemies.push_back(ofVec2f(600,800));
//    obstacles.push_back(ofVec2f(300,300));
//    obstacles.push_back(ofVec2f(800,600));
//    levels[1].setGoal(ofVec2f(600,200));
    levels[0].setEnemies(enemies, 50);
    enemies.clear();
    
//    enemies.push_back(ofVec2f(100,400));
//    enemies.push_back(ofVec2f(500,400));
////    obstacles.push_back(ofVec2f(600,100));
////    levels[2].setGoal(ofVec2f(600,300));
//    levels[1].setObstacle(200,400,400, 6, 45);
//    levels[1].setObstacle(200,650,400, 6, 135);
//    levels[1].setEnemies(enemies, 50);
//    enemies.clear();
    
    
    enemies.push_back(ofVec2f(200,500));
    //enemies.push_back(ofVec2f(500,400));
    enemies.push_back(ofVec2f(ofGetWidth()/2,700));
//    obstacles.push_back(ofVec2f(300,300));
//    obstacles.push_back(ofVec2f(600,400));
 //   levels[3].setGoal(ofVec2f(400,200));
//    levels[3].setObstacle(ofGetWidth()/4,ofGetHeight()/4,400, 6, 45);
//    levels[3].setObstacle(ofGetWidth()/4*3,ofGetHeight()/4*3,400, 6, 135);
    levels[1].setObstacle(ofGetWidth()/2,ofGetHeight()/2,1000, 6, 45);
    levels[1].setObstacle(ofGetWidth()/2,ofGetHeight()/2,1000, 6, 135);
    levels[1].setEnemies(enemies, 50);
    enemies.clear();
    
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(500,400));
    enemies.push_back(ofVec2f(ofGetWidth()/2,100));
    levels[2].setObstacle(200,ofGetHeight()/2,420, 6, 0);
    levels[2].setObstacle(ofGetWidth()/2-3,200,6, 400, 90);
    levels[2].setEnemies(enemies, 100);
    enemies.clear();
    
    enemies.push_back(ofVec2f(100,410));
    enemies.push_back(ofVec2f(600,450));
    for (int i=0; i<4; i++) {
        levels[3].setObstacle(ofGetWidth()/2,200+200*i,1000, 6, 45);
    }
//    for (int i=0; i<4; i++) {
//        levels[4].setObstacle(ofGetWidth()-100,200+200*i,400, 6, 135);
//    }
    levels[3].setEnemies(enemies, 50);
    enemies.clear();
    
    enemies.push_back(ofVec2f(200,500));
    enemies.push_back(ofVec2f(600,400));
    levels[4].setObstacle(ofGetWidth()/2,3,ofGetWidth()-100, 6, 0);
    levels[4].setObstacle(ofGetWidth()/2-3,ofGetHeight()/2,6, ofGetHeight(), 0);
    levels[4].setObstacle(ofGetWidth()/2,ofGetHeight()-3,ofGetWidth()-150, 6, 0);
    levels[4].setObstacle(3,ofGetHeight()/2,6,ofGetHeight()-100, 0);
    levels[4].setObstacle(ofGetWidth()-3,ofGetHeight()/2,6,ofGetHeight()-150, 0);
    levels[4].setEnemies(enemies, 100);
    enemies.clear();
    
    enemies.push_back(ofVec2f(150,150));
    enemies.push_back(ofVec2f(200,700));
    enemies.push_back(ofVec2f(ofGetWidth()/4*3,ofGetHeight()/4*3));
    levels[5].setObstacle(ofGetWidth()/4,ofGetHeight()/2-200,ofGetWidth()/2-50, 6, 0);
    levels[5].setObstacle(ofGetWidth()/4*3,ofGetHeight()/2+100,ofGetWidth()/2-50, 6, 0);
    levels[5].setObstacle(ofGetWidth()/2-3,ofGetHeight()/2,6, ofGetHeight(), 0);
    levels[5].setEnemies(enemies, 100);
    enemies.clear();
    
}

