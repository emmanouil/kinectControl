// this signal uses the mouseX and mouseY position to build a signal
class SawWave implements AudioSignal
{
  void generate(float[] samp)
  {
    float amp = map((height-mouseY), 0, height, 0, 1);
    float frequency = map(mouseX, 0, width, 1, 2000);
    float peaks = frequency/21.5332;
    float inter = float(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter, -amp, amp);
      }
    }
  }
  
  // this is a stricly mono signal
  void generate(float[] left, float[] right)
  {
    generate(left);
    generate(right);
  }
}
