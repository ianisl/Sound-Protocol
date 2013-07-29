public class ThresholdSetter extends controlP5.Controller
{
  /*
   * This controller must be associated (for instance using controlP5 auto association) with
   * a signal-level threshold value (accessible trough getValue() and setValue()). It is not stored internally.
   * The controller only stores the position (in pixels) of the threshold line, and the signal-level values
   * at bottom and top of controller display.
   */
  PApplet parent;
  int backgroundColor = 0xff02344d;
  int chartColor = 0xff016c9e;
  int thresholdLineY = 0; // Threshold line position in pixels 
  int bufferSize = 512; // internal buffer, populated via the addToBuffer method
  float minValue = 0; // Signal-level value at bottom of controller display 
  float maxValue = 1; // Signal-level value at top of controller display 
  float[] buffer = new float[bufferSize]; // Buffer of signal values
  boolean lastBufferSampleAboveThreshold = false;

  public ThresholdSetter(ControlP5 cp5, String theName, PApplet parent)
  {
    super(cp5, theName);
    this.parent = parent;
    parent.registerDispose(this);
    if (getValue() > maxValue) 
    {
      setValue(maxValue);
    }
    if (getValue() < minValue) 
    {
      setValue(minValue);
    }
    setView(new ControllerView<ThresholdSetter>() // replace the default view with a custom view.
    {
      public void display(PApplet p, ThresholdSetter b)
      {
        p.strokeWeight(1);
        p.fill(backgroundColor); // draw button background
        p.stroke(backgroundColor);
        p.rect(0, 0, getWidth(), getHeight());
        p.stroke(255); // Threshold line 
        p.line(0, thresholdLineY, width, thresholdLineY);
        p.noFill(); // Draw buffer chart
        p.stroke(0xff016c9e);
        p.beginShape();
        for (int i = bufferSize - 1; i >= 0; i--)
        {
          p.vertex(p.map(i, bufferSize - 1, 0, getWidth(), 0), p.map(buffer[i], minValue, maxValue, getHeight(), 0));
        }
        p.endShape();
        p.fill(255); // draw the custom label 
        Label caption = b.getCaptionLabel();
        caption.style().marginTop = getHeight() + 5;
        caption.draw(p);
        if (lastBufferSampleAboveThreshold) // Threshold activation indicator
        {
          p.stroke(0xffE30202);
          p.fill(0xffE30202);
          p.rect(caption.getWidth() + 5, getHeight() + 5, 5, 5);
        }
      }
    });
  }

  public ThresholdSetter setMinValue(float theValue)
  {
    minValue = theValue;
    setValue(parent.map(thresholdLineY, 0, getHeight(), maxValue, minValue));
    return this;
  }
  
  public float getMinValue(float theValue)
  {
    return minValue;
  }

  public ThresholdSetter setMaxValue(float theValue)
  {
    maxValue = theValue;
    setValue(parent.map(thresholdLineY, 0, getHeight(), maxValue, minValue));
    return this;
  }
  
  public float getMaxValue(float theValue)
  {
    return maxValue;
  }


  public void addToBuffer(float theValue)
  {
    System.arraycopy(buffer, 1, buffer, 0, bufferSize - 1);
    buffer[bufferSize - 1] = theValue;
    if (buffer[bufferSize - 1] > getValue()) 
    { 
      lastBufferSampleAboveThreshold = true;
    } else 
    { 
      lastBufferSampleAboveThreshold = false;
    }
  }

  protected void onDrag()
  {
    Pointer p1 = getPointer();
    float dif = parent.dist(p1.px(), p1.y(), p1.x(), p1.y());
    if (p1.y() > 0 && p1.y() < getHeight())
    {
      thresholdLineY = p1.y();
      setValue(parent.map(thresholdLineY, 0, getHeight(), maxValue, minValue));
    }
  }

  public ThresholdSetter setColorBackground(int theColor)
  {
    backgroundColor = theColor;
    return this;
  }

  public ThresholdSetter setColorChart(int theColor)
  {
    chartColor = theColor;
    return this;
  }

  public ThresholdSetter setBufferSize(int theSize)
  {
    bufferSize = theSize;
    buffer = new float[bufferSize];
    return this;
  }

  public void dispose()
  {
    // anything in here will be called automatically when 
    // the parent applet shuts down. for instance, this might
    // shut down a thread used by this library.
  }
  
  public int getThresholdLineY()
  {
    return thresholdLineY;
  }

  public void setThresholdLineY(int thresholdLineY)
  {
    this.thresholdLineY = thresholdLineY;
  }

  public boolean isLastBufferSampleAboveThreshold()
  {
    return lastBufferSampleAboveThreshold;
  }

}
