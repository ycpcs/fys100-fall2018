import io.github.daveho.funwithsound.*;

FunWithSound fws = new FunWithSound(this);

// Directory where you keep your soundfonts
String SOUNDFONTS = "C:/SoundFonts";

String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";

class MyComp extends Composer {
  void create() {
    //create a tempo at 110 beats per minute; play 4 beats per measure
    tempo(110, 4); 

    //select the major key (C4)
    //use the web page below to select a new MIDI note number
    //https://newt.phys.unsw.edu.au/jw/notes.html
    major(60);

    //create a percussive instruction called drumkit; use the TR808 soundfile
    Instrument drumkit = percussion(TR808); // Roland TR-808 sounds
    
    //create a melodic instruction called bass. Use instrument #36
    //from the FLUID sound file. Select other sounds using the MIDI
    //sound set at https://www.midi.org/specifications/item/gm-level-1-sound-set
    Instrument bass = instr(FLUID, 36); // fretless bass
    v(bass, 0.5); // make the bass a bit quieter
    
    //create a rhythm called kickr to play on beats 0, 1, 2, and 3
    Rhythm kickr = r(p(0), p(1), p(2), p(3));

    //assign kickr to be played with instrument 36 from the
    //drumkit sound set. New instruments can be selected from
    //the pecursive sound set https://www.midi.org/specifications/item/gm-level-1-sound-set
    Figure kickf = pf(kickr, 36, drumkit);
    
    add1(gf(kickf)); //schedule kickf to play on measure 1
    add1(gf(kickf)); //schedule kickf to play on measure 2
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
