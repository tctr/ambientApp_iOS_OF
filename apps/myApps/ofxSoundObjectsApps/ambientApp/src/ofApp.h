#pragma once


#include "ofxiOS.h"
#include "ofxSoundMixer.h"
#include "ofxSoundPlayerObject.h"

#include "SineWaveGenerator.h"
#include "NoiseGenerator.h"
#include "LowPassFilter.h"
#include "DigitalDelay.h"
#include "ofxSoundObjects.h"


class ofApp : public ofxiOSApp{

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
	
	ofShader shader;
	
	bool bUseShader;
	ofTrueTypeFont font;
	ofPoint mousePoint;
    int fontSize;
    
    
    // these are all subclasses of ofSoundObject
    NoiseGenerator noise;
    LowPassFilter filter;
    DigitalDelay delay;
    
    float filterCutoff;
    float delayFeedback;
		
	ofxSoundMixer mixer;
	vector<unique_ptr<ofxSoundPlayerObject>> players;
	
    ofSoundStream stream;
	
	ofEventListener playerEndListener;
	void playerEnded(size_t & id);
	
	
};
