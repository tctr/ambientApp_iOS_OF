#pragma once


#include "ofxiOS.h"
#include "ofxSoundMixer.h"
#include "ofxSoundPlayerObject.h"
//#include "ofxGui.h"

#include "SineWaveGenerator.h"

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
		
	ofxSoundMixer mixer;
	vector<unique_ptr<ofxSoundPlayerObject>> players;
	
    ofSoundStream stream;
	
	ofEventListener playerEndListener;
	void playerEnded(size_t & id);
	
	
};
