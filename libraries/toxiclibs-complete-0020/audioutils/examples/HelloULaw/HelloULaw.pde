/**
 * A Hello World demo for using the built in µLaw sample converter to be able to
 * work with audio files from VOIP sources etc.
 * 
 * Key controls:
 * Press any key to play a µLaw encoded sample
 */

/* 
 * Copyright (c) 2010 Karsten Schmidt
 * 
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

import toxi.audio.*;
import toxi.geom.*;

JOALUtil audioSys;
AudioSource source;

void setup() {
  size(100,100);
  // JOALUtil is implemented as singleton, so get an instance like this & initialize it
  audioSys = JOALUtil.getInstance();
  audioSys.init();
  // load a sample and initialize an audio source using it
  // NOTE: path to file needs to be absolute, hence we use the dataPath() wrapper
  AudioBuffer buffer = audioSys.loadBuffer(dataPath("phone_ulaw.wav"));
  if (buffer.convertUlawToPCM(false)) {
    source = audioSys.generateSource();
    source.setBuffer(buffer);
  } 
  else {
    println("couldn't convert µLaw data");
    exit();
  }
}

// needed because else Processing is calling stop() prematurely
void draw() {
}

void keyPressed() {
  source.play();
}

// release all audio resources
public void stop() {
  audioSys.shutdown();
}

