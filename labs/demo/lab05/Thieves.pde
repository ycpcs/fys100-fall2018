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
    
    //create a rhythm called kickr, play with drumset instrument #36
    Rhythm kickr = r(p(0), p(1), p(2), p(2.5), p(3), p(3.25));
    Figure kickf = pf(kickr, 36, drumkit);
    
    //create a rhythm called kickr2, play with drumset instrument #36
    Rhythm kick2r = r(p(0), p(1), p(2.5), p(2.75), p(2), p(2.5), p(3), p(3.25), p(3.75));
    Figure kick2f = pf(kick2r, 36, drumkit);
    
    Rhythm kick3r = r(p(0), p(1.5), p(2));
    Figure kick3f = pf(kick3r, 36, drumkit);
    
    //create a rhythm called snarer, play with drumset instrument #40
    Rhythm snarer = r(p(3), p(3.5), p(3.75));
    Figure snaref = pf(snarer, 40, drumkit);
    
    Rhythm snare2r = r(p(1), p(3));
    Figure snare2f = pf(snare2r, 40, drumkit);

    Rhythm snare3r = r(p(1), p(3), p(3.5), p(3.75));
    Figure snare3f = pf(snare3r, 40, drumkit);

    //create complex rhythm and melodic line for instrument
    //rhythm for melodic instrument must specific note and sustain for each beat
    Rhythm bassr = r(s(0, .25), s(.25, .25), s(.5, .25), s(.75, .25), s(1, .5), s(1.75, .25), s(2.25, .25), s(2.75, .25), s(3, .5));

    //melodies must be specified relative to the key
    Melody bassm = m(-17, -17, -17, -17, -17, -18, -17, -18, -17);

    //create a figure from the rhythm (bassr) and melody (bassm) using the
    //bass instrument
    Figure bassf = f(bassr, bassm, bass);
    
    Rhythm bass2r = r(s(0, .25), s(.25, .25), s(.5, .25), s(.75, .25), s(1, .5), s(1.5, .25), s(1.75, .5));
    Melody bass2m = m(-17, -17, -17, -17, -17, -18, -17);
    Figure bass2f = f(bass2r, bass2m, bass);
    
    Rhythm hihatr = r(
      p(0),
      p(.5), p(.75), p(1),
      p(1.5), p(1.75), p(2),
      p(2.5), p(2.75), p(3),
      p(3.25), p(3.375), p(3.5), p(3.75)
    );
    Figure hihatf = pf(hihatr, 42, drumkit);
    
    add1(gf(kickf)); //schedule kickf to play in measure 1
    add1(gf(kick2f)); //schedule kick2f to play in measure 2
    add1(gf(kickf)); //schedule kickf to play in measure 3
    add1(gf(kick2f)); //schedule kick2f to play in measure 4
    add1(gf(kick3f)); //schedule kick3f to play in measure 5
    add1(gf(kick3f, snaref)); //schedule kick3f and snaref to both play in measure 6
    add1(gf(kick3f));
    add1(gf(kick3f, snaref));
    add1(gf(kick3f));
    add1(gf(kick3f, snaref));
    add1(gf(kick3f));
    add1(gf(kick3f, snaref));

    add1(gf(kickf, snare2f, hihatf, bassf));
    add1(gf(kick2f, snare3f, hihatf, bass2f));
    add1(gf(kickf, snare2f, hihatf, bassf));
    add1(gf(kick2f, snare3f, hihatf, bass2f));
    
    //audition(bass);
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
