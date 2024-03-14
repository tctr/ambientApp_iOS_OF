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
#ifdef USE_LOAD_DIALOG
    ofFileDialogResult result = ofSystemLoadDialog();
    if (result.bSuccess) {
        player.load(result.getPath());
    }
#else
    ofDirectory dir;
    dir.listDir("sounds");
    for(int i = 0; i < dir.size(); i ++){
        ofLogNotice() << ofToDataPath(dir.getPath(i), true );
    }
    
    player.load( ofToDataPath("sounds/synth.mp3", true),
                //set the following to true if you want to stream the audio data from the disk on demand instead of
                //reading the whole file into memory. Default is false
                false);
#endif
    //----- Loading sound player end -------.

    //----- Sound stream setup begin -------.
    // the sound stream is in charge of dealing with your computers audio device.
    // lets print to the console the sound devices that can output sound.
    ofxSoundUtils::printOutputSoundDevices();
    
    auto outDevices = ofxSoundUtils::getOutputSoundDevices();
    
    // IMPORTANT!!!
    // The following line of code is where you set which audio interface to use.
    // the index is the number printed in the console inside [ ] before the interface name
    // You can use a different input and output device.
    
    int outDeviceIndex = 0;
    
    //cout << ofxSoundUtils::getSoundDeviceString(outDevices[outDeviceIndex], false, true) << endl;
    
    
    ofSoundStreamSettings soundSettings;
    soundSettings.numInputChannels = 0;
    soundSettings.numOutputChannels = 2;
    soundSettings.sampleRate = player.getSoundFile().getSampleRate();
    soundSettings.bufferSize = 256;
    soundSettings.numBuffers = 1;
    
    stream.setup(soundSettings);
    
    
    // it is important to set up which object is going to deliver the audio data to the sound stream.
    // thus, we need to set the stream's output. The output object is going to be the last one of the audio signal chain, which is set up further down
    stream.setOutput(output);

    //-------Sound stream setup end -------.
    


    
    // ------ waveforms ---------
    // the waveformDraw class setup receives the rectangle where it is going to be drawn
    // you can skip this and pass this while drawing if you are changing where this is going to be drawn.
    // As well, the waveformDraw class inherits from ofRectangle so you can access the functions of the latter.
    
    
    fullFileWaveform.setup( 0, 0, ofGetWidth(), ofGetHeight()/3);
    wave.setup(0, fullFileWaveform.getMaxY(), ofGetWidth(), ofGetHeight() - fullFileWaveform.getMaxY());
    // the fullFileWaveform object will have a static waveform for the whole audio file data. This is only created once as it will read the whole sound file data.
    // For such, we need to get the sound buffer from the sound file in order to get the whole file's data.
    // calling player.getBuffer(), which actually is a function, will return the players current buffer, the one that is being sent to the sound device, so it will not work for what we are trying to achieve.
    // the waveformDraw's makeMeshFromBuffer(ofBuffer&) function will create a waveform from the buffer passed
    
    fullFileWaveform.makeMeshFromBuffer( player.getSoundFile().getBuffer());
    

    // wave object will be part of the signal chain and will update on real time as the audio passes to the output
    
    // --------- Audio signal chain setup.-------
    // Each of our objects need to connect to each other in order to create a signal chain, which ends with the output; the object that we set as the sound stream output.

    player.connectTo(wave).connectTo(output);

    
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


/*
    ofSetColor(ofColor::white);

    fullFileWaveform.draw();
    
    ofSetColor(ofColor::red);
    float playhead = ofMap(player.getPosition(), 0,1, fullFileWaveform.getMinX(),fullFileWaveform.getMaxX());
    ofDrawLine(playhead, 0, playhead, fullFileWaveform.getMaxY());
    
    if(fullFileWaveform.inside(ofGetMouseX(), ofGetMouseY())){
        ofSetColor(ofColor::cyan);
        ofDrawLine(ofGetMouseX(), 0, ofGetMouseX(), fullFileWaveform.getMaxY());
    }
    ofSetColor(ofColor::white);
    wave.draw();

    
    ofSetColor(ofColor::yellow);
    player.drawDebug(20, 20);
 */
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    bUseShader = true;
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    bUseShader = false;
    
    if(fullFileWaveform.inside(touch.x, touch.y)){
    player.setPositionMS(ofMap(touch.x, fullFileWaveform.getMinX(), fullFileWaveform.getMaxX(), 0, player.getDurationMS()));
    }
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


