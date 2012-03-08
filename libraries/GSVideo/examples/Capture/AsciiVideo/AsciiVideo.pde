/**
 * ASCII Video
 * by Ben Fry. 
 *
 * GSVideo version by Andres Colubri. 
 * 
 * Text characters have been used to represent images since the earliest computers.
 * This sketch is a simple homage that re-interprets live video as ASCII text.
 * See the keyPressed function for more options, like changing the font size.
 */

import processing.opengl.*;
import codeanticode.gsvideo.*;

GSCapture video;
boolean cheatScreen;

// All ASCII characters, sorted according to their visual density
String letterOrder =
  " .`-_':,;^=+/\"|)\\<>)iv%xclrs{*}I?!][1taeo7zjLu" +
  "nT#JCwfy325Fp6mqSghVd4EgXPGZbYkOA&8U$@KHDBWNMR0Q";
char[] letters;

float[] bright;
char[] chars;

PFont font;
float fontSize = 16;


public void setup() {
  size(640, 480, P3D);
  // Or run full screen, more fun! Use with Sketch -> Present
  //size(screen.width, screen.height, OPENGL);

  // Uses the default video input, see the reference if this causes an error
  video = new GSCapture(this, 160, 120);
  video.start();  
  int count = video.width * video.height;
  println(count);

  font = loadFont("UniversLTStd-Light-48.vlw");

  // for the 256 levels of brightness, distribute the letters across
  // the an array of 256 elements to use for the lookup
  letters = new char[256];
  for (int i = 0; i < 256; i++) {
    int index = int(map(i, 0, 256, 0, letterOrder.length()));
    letters[i] = letterOrder.charAt(index);
  }

  // current characters for each position in the video
  chars = new char[count];

  // current brightness for each point
  bright = new float[count];
  for (int i = 0; i < count; i++) {
    // set each brightness at the midpoint to start
    bright[i] = 128;
  }
}


public void captureEvent(GSCapture c) {
  c.read();
}

void draw() {
  background(0);
  textFont(font, fontSize);

  int index = 0;
  for (int y = 1; y < video.height; y+=3) {
    for (int x = 0; x < video.width; x+=3) {
      int pixelColor = video.pixels[(y - 1)*video.width + x];
      // Faster method of calculating r, g, b than red(), green(), blue() 
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      // Another option would be to properly calculate brightness as luminance:
      // luminance = 0.3*red + 0.59*green + 0.11*blue
      // Or you could instead red + green + blue, and make the the values[] array
      // 256*3 elements long instead of just 256.
      int pixelBright = max(r, g, b);

      // The 0.1 value is used to damp the changes so that letters flicker less
      float diff = pixelBright - bright[index];
      bright[index] += diff * 0.1;

      //fill(pixelColor);
      int num = int(bright[index]);

      fill(color(r, g, b));
      text(letters[num], map(x, 0, video.width, 0, width), map(y, 0, video.height, 0, height));
      
      // Move to the next pixel
      index++;

    }
  }

  if (cheatScreen) {
    //image(video, 0, height - video.height);
    // set() is faster than image() when drawing untransformed images
    set(0, height - video.height, video);
  }
}


/**
 * Handle key presses:
 * 'c' toggles the cheat screen that shows the original image in the corner
 * 'g' grabs an image and saves the frame to a tiff image
 * 'f' and 'F' increase and decrease the font size
 */
public void keyPressed() {
  switch (key) {
    case 'g': saveFrame(); break;
    case 'c': cheatScreen = !cheatScreen; break;
    case 'f': fontSize *= 1.1; break;
    case 'F': fontSize *= 0.9; break;
  }
}
