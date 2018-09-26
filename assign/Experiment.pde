import io.github.daveho.funwithsound.*;

FunWithSound fws = new FunWithSound(this);

// Directory where you keep your soundfonts
final String SOUNDFONTS = "c:/SoundFonts";

// Emulation of classic Roland TR-808 drum machine: for percussion
// instruments only
final String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";

// Excellent general purpose soundfont: can be used for both melodic
// and percussion instruments
final String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";

// Excellent collection of vintage synthesizer sounds, but note that
// this soundfont does NOT use the GM1 sound set.  So, to find good
// patches, you'll need to experiment.
final String VDW = SOUNDFONTS + "/hammersound/Vintage Dreams Waves v2.sf2";

class MyComp extends Composer {
  void create() {
    //////////////////////////////////////////////////////////
    // Set overall composition properties (tempo and key)
    //////////////////////////////////////////////////////////
    
    //create a tempo at 110 beats per minute; play 4 beats per measure
    tempo(110, 4); 

    // select the natural minor key (A3)
    // use the web page below to select a new MIDI note number
    // https://newt.phys.unsw.edu.au/jw/notes.html
    naturalMinor(57);
    
    //////////////////////////////////////////////////////////
    // Define instruments (percussion and melodic)
    //////////////////////////////////////////////////////////

    // create a percussive instruction called drumkit; use the TR808 soundfile
    Instrument drumkit = percussion(TR808); // Roland TR-808 sounds
    
    // create a melodic instrument called bass using path
    // 4 from the Vintage Dreams Waves soundfont
    Instrument bass = instr(VDW, 4); // fretless bass
    v(bass, 0.4); // make the bass a bit quieter
    
    //////////////////////////////////////////////////////////
    // Define rhythms, melodies, and figures
    //////////////////////////////////////////////////////////

    // Kick drum figure 1
    Rhythm kickr1 = r(p(0), p(.5), p(1));
    Figure kickf1 = pf(kickr1, 36, drumkit); // 36=bass drum 1
    
    // Kick drum figure 2
    Rhythm kickr2 = r(p(0), p(.25), p(1), p(1.75));
    Figure kickf2 = pf(kickr2, 36, drumkit); // 36=bass drum 1
    
    // Snare figure 1
    Rhythm snarer1 = r(p(1.5), p(3.5));
    Figure snaref1 = pf(snarer1, 40, drumkit); // 40=electric snare
    
    // Snare figure 2 (actually, hand claps)
    Rhythm snarer2 = r(p(0), p(.25), p(.5), p(.75), p(1), p(1.25), p(1.5), p(1.75));
    Figure snaref2 = pf(snarer2, 39, drumkit); // 39=hand clap
    
    // Hi-hat figure 1 (part a)
    Rhythm hihatr1a = rr(p(1), .25, 12); // repeated strikes, start at beat 1, separated by .25
    Figure hihatf1a = pf(hihatr1a, 42, drumkit); // 42=closed hi hat
    
    // Hi-hat figure 1 (part b)
    Rhythm hihatr1b = r(s(0, 1));
    Figure hihatf1b = pf(hihatr1b, 46, drumkit); // 46=open hi hat
    
    // Combine hi-hat figures 1a and 1b into a single figure
    Figure hihatf1 = gf(hihatf1a, hihatf1b);
    
    // Bass figure 1
    Rhythm bass1r = r(s(0, .5), s(.5, .5), s(1, .5), s(2, .5), s(2.5, .5), s(3.5, .5));
    Melody bass1m = m(1, 0, -1, -3, 1, 0);
    Figure bass1f = f(bass1r, bass1m, bass);
    
    // Bass figure 2 (note that it reuses the rhythm from bass figure 1)
    Melody bass2m = m(4, 5, 2, 5, 3, 4);
    Figure bass2f = f(bass1r, bass2m, bass);
    
    //////////////////////////////////////////////////////////
    // Specify the overall composition by scheduling
    // which figures will begin playing in each measure of
    // the composition
    //////////////////////////////////////////////////////////
    
    add1(gf(kickf1, snaref1));
    add1(gf(kickf1, snaref2));
    add1(gf(kickf2, snaref1));
    add1(gf(kickf2, snaref2));
    add1(gf(kickf1, hihatf1));
    add1(gf(kickf2, hihatf1));
    add1(gf(kickf1, snaref1, hihatf1));
    add1(gf(kickf2, snaref1, hihatf1));
    add1(gf(kickf1, snaref2, hihatf1));
    add1(gf(kickf2, snaref2, hihatf1));
    add1(gf(kickf1, snaref1, hihatf1, bass1f));
    add1(gf(kickf2, snaref1, hihatf1, bass2f));
    add1(gf(kickf1, snaref2, hihatf1, bass1f));
    add1(gf(kickf2, snaref2, hihatf1, bass2f));
  }
}

MyComp c = new MyComp();

void setup() {
  size(600,200);
  textSize(32);
  fill(0);
  text("Click to start playing", 125, 140); 
  c.create();
}

void draw() {
}

void mouseClicked() {
  fws.play(c);
}
