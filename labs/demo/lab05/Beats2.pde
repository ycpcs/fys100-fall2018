import io.github.daveho.funwithsound.*;

FunWithSound fws = new FunWithSound(this);

// Directory where you keep your soundfonts
String SOUNDFONTS = "C:/SoundFonts";

String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";

class MyComp extends Composer {
  void create() {
    tempo(110, 4);
    major(60);

    Instrument drumkit = percussion(TR808); // Roland TR-808 sounds
    Instrument bass = instr(FLUID, 36); // fretless bass
    v(bass, 0.5); // make the bass a bit quieter
    
    Rhythm kickr = r(p(0), p(2), p(2.5));
    Figure kickf = pf(kickr, 36, drumkit);
    
    Rhythm snarer = r(p(1), p(3), p(3.25), p(3.75));
    Figure snaref = pf(snarer, 40, drumkit);
    
    Rhythm hihat1r = r(p(.25), p(.375), p(.5), p(1), p(1.5));
    Figure hihat1f = pf(hihat1r, 42, drumkit);
    Rhythm hihat2r = r(s(2, 1), s(3, 1));
    Figure hihat2f = pf(hihat2r, 46, drumkit);
    
    Rhythm bassr = r(
      s(.5, .25), s(1, .25), s(1.25, .25), s(1.75, 1.25),
      s(4.5, .25), s(5, .25), s(5.25, .25), s(5.75, .5),
      s(6.5, .25), s(7, .25), s(7.25, .5)
    );
    Melody bassm = m(
      -16,-16,-16,-16,
      -20,-20,-20,-19,
      -14,-14,-14
    );
    Figure bassf = f(bassr, bassm, bass);
    
    add1(gf(kickf, snaref, hihat1f, hihat2f, bassf));
    add1(gf(kickf, snaref, hihat1f, hihat2f));
    add1(gf(kickf, snaref, hihat1f, hihat2f, bassf));
    add1(gf(kickf, snaref, hihat1f, hihat2f));
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
