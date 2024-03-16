#include "ofApp.h"

/// Uncomment the following line if you want to use a load dialog instead of a fixed file path to open
//#define USE_LOAD_DIALOG

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(40);
    ofSetVerticalSync(false);
    ofEnableAlphaBlending();
    ofSetLogLevel(OF_LOG_VERBOSE);
    
    shader.load("shaders/noise.vert", "shaders/noise.frag");
    bUseShader = true;

    //we load a font and tell OF to make outlines so we can draw it as GL shapes rather than textures
    fontSize = ofGetWidth() / 4;
    font.load("type/verdana.ttf", fontSize, true, false, true, 0.4, 72);
    
    ofRectangle rect = font.getStringBoundingBox("meditate", 0, 0);   // size of text.
    mousePoint.x = (ofGetWidth() - rect.width) * 0.5 +200;  // position in center screen
    mousePoint.y = (ofGetHeight() - rect.height) * 0.5;

    //----- Loading sound player begin -------.

    ofDirectory dir;
    dir.listDir("sounds");
    for(int i = 0; i < dir.size(); i ++){
        ofLogNotice() << ofToDataPath(dir.getPath(i), true );
    }
    
    player.load( ofToDataPath("sounds/meditationApp_robertAntonWilson.mp3", true),
                //set the following to true if you want to stream the audio data from the disk on demand instead of
                //reading the whole file into memory. Default is false
                false);

    //----- Loading sound player end -------.

    //----- Sound stream setup begin -------.
    ofSoundStreamSettings soundSettings;
    soundSettings.numInputChannels = 0;
    soundSettings.numOutputChannels = 2;
    soundSettings.sampleRate = player.getSoundFile().getSampleRate();
    soundSettings.bufferSize = 256;
    soundSettings.numBuffers = 1;
    stream.setup(soundSettings);
    
    stream.setOutput(output);
    //-------Sound stream setup end -------.
    
    // --------- Audio signal chain setup.-------
    // Each of our objects need to connect to each other in order to create a signal chain, which ends with the output; the object that we set as the sound stream output.

    player.connectTo(output);

    
    player.play();
    
    // set if you want to either have the player looping (playing over and over again) or not (stop once it reaches the its end).
    player.setLoop(true);
    
    // the endEvent gets triggered when it reaches the end of the file, regardless of it being
    // in looping or not
    playerEndListener = player.endEvent.newListener(this, &ofApp::playerEnded);

}
//--------------------------------------------------------------
void ofApp::playerEnded(size_t & id){
    // This function gets called when the player ends. You can do whatever you need to here.
    // This event happens in the main thread, not in the audio thread.
    cout << "the player's instance " << id << "finished playing" << endl;
    
}
//--------------------------------------------------------------
void ofApp::exit(){
    stream.close();
}
//--------------------------------------------------------------
void ofApp::update(){
}
//--------------------------------------------------------------
void ofApp::draw(){

    
    ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
    ofPushStyle();
    ofSetColor(245, 58, 135);
    ofFill();
    
    if(bUseShader) {
    
        shader.begin();
        shader.setUniform1f("timeValX", ofGetElapsedTimef() * 0.1 );     // we want to pass in some varrying 
                                                                        // values to animate our type / color
        shader.setUniform1f("timeValY", -ofGetElapsedTimef() * 0.18 );
        shader.setUniform2f("mouse", mousePoint.x, mousePoint.y);       // we also pass in the mouse position
    }
    
    ofRectangle rect = font.getStringBoundingBox("meditate", 0, 0);   // size of text.
    int x = (ofGetWidth() - rect.width) * 0.5;                              // position in center screen
    int y = (ofGetHeight() - rect.height) * 0.5 + fontSize/2;
    font.drawStringAsShapes("meditate", x, y);

    if(bUseShader) {
        shader.end();
    }
    
    ofPopStyle();
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    bUseShader = true;
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    bUseShader = false;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    // we have to transform the coords to what the shader is expecting which is 0,0 in the center and y axis flipped.
    mousePoint.x = touch.x * 2 - ofGetWidth();
    mousePoint.y = ofGetHeight() * 0.5 - touch.y;
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


