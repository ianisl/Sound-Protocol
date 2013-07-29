import controlP5.*;
import ddf.minim.*;
import java.util.Arrays;

ControlP5 cp5;
Minim m;
AudioInput in;
ThresholdSetter t;
int bufferSize = 256;
int lastOnsetTime = -1;

void setup() 
{
  size(400, 400);
  m = new Minim(this);
  in = m.getLineIn(Minim.STEREO, bufferSize);
  cp5 = new ControlP5(this);
  t = (ThresholdSetter) new ThresholdSetter(cp5, "threshold", this).setPosition(20, 20); // Need to assign to a ThresholdSetter type to disambiguate with the Controller interface of Minim
  t.setMax(0.1);
  t.setBufferSize(bufferSize);
  t.setSize(250, 200);
  t.setMax(0.5);
  t.setBufferSize(256);
}

void draw() 
{
  background(0);
  t.addToBuffer(in.left.level()); // add the mean level of the current buffer to ThresholdSetters' internal buffer
  boolean threshold = t.isLastBufferSampleAboveThreshold();
  if (threshold)
  {
    int onsetTime = millis();
    if (onsetTime - lastOnsetTime > 500)
    {
      lastOnsetTime = onsetTime;
      println("true " + millis());
    }
  }
}

public void controlEvent(ControlEvent theEvent) {
  //println("controlEvent : "+theEvent);
}

