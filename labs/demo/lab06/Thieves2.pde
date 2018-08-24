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
    
    Instrument pad = instr(FLUID, 91); // Pad 3 (polysynth)
    v(pad, 0.8); // make this a bit quieter

    Instrument synth = instr(FLUID, 7); // Harpsichord, with some audio effects (delay+reverb)
    v(synth, 0.15); // this should be fairly quiet
    addfx(synth, new AddDelay(100, 1, .7));
    addfx(synth, new AddDelay(100, 1, .6));
    addfx(synth, new AddReverb());

    Instrument fifths = instr(FLUID, 87); // Lead 7 (fifths)
    v(fifths, 0.5); // make this quieter
    
    Instrument guitar = instr(FLUID, 30); // overdriven guitar
    v(guitar, 0.4);
    
    Rhythm kickr = r(p(0), p(1), p(2), p(2.5), p(3), p(3.25));
    Figure kickf = pf(kickr, 36, drumkit);
    
    Rhythm kick2r = r(p(0), p(1), p(2.5), p(2.75), p(2), p(2.5), p(3), p(3.25), p(3.75));
    Figure kick2f = pf(kick2r, 36, drumkit);
    
    Rhythm kick3r = r(p(0), p(1.5), p(2));
    Figure kick3f = pf(kick3r, 36, drumkit);
    
    Rhythm snarer = r(p(3), p(3.5), p(3.75));
    Figure snaref = pf(snarer, 40, drumkit);
    
    Rhythm snare2r = r(p(1), p(3));
    Figure snare2f = pf(snare2r, 40, drumkit);

    Rhythm snare3r = r(p(1), p(3), p(3.5), p(3.75));
    Figure snare3f = pf(snare3r, 40, drumkit);

    Rhythm bassr = r(s(0, .25), s(.25, .25), s(.5, .25), s(.75, .25), s(1, .5), s(1.75, .25), s(2.25, .25), s(2.75, .25), s(3, .5));
    Melody bassm = m(-17, -17, -17, -17, -17, -18, -17, -18, -17);
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
    
    Rhythm pad1r = r(s(0, 5), s(5, 1), s(6, .5), s(6.5, 1));
    Melody pad1m = m(0,-2,3,2);
    Figure pad1f = f(pad1r, pad1m, pad);
    
    Melody pad2m = m(1, -1, 0, 1);
    Figure pad2f = f(pad1r, pad2m, pad);
    
    Melody pad3m = m(0, -2, 0, 3);
    Figure pad3f = f(pad1r, pad3m, pad);
    
    Rhythm synth1r = r(
      s(0, .25),
      s(.5, .25), s(.75, .25), s(1, .25),
      s(1.5, .25), s(1.75, .25), s(2, .25), s(2.25, .25), s(2.75, .25),
      s(3.5, .25), s(3.75, .5)
    );
    Melody synth1m = m(
      1,
      1, 1, 1,
      1, 1, 1, 2, 1,
      1, 1
    );
    Figure synth1f = f(synth1r, synth1m, synth);
    
    Rhythm synth2r = r(
      s(0, .25),
      s(.5, .25), s(.75, .25), s(1, .25),
      s(1.5, .25), s(1.75, .25), s(2, .25), s(2.25, .25), s(3.5, .25), s(3.75, .25)
    );
    Melody synth2m = m(
      1,
      1, 1, 1,
      1, 1, 1, 2
    );
    Melody synth3m = m(
      1,
      1, 1, 1,
      1, 1, 1, 2, 2, 2
    );
    Figure synth2f = f(synth2r, synth2m, synth);
    Figure synth3f = f(synth2r, synth3m, synth);
    
    Rhythm fifthsr = r(
      s(0, .5), s(.5, 1), s(1.5, 1), s(2.5, 1),
      s(4.0, .5), s(4.5, 1), s(5.5, 1), s(6.5, 1)
    );
    Melody fifthsm = m(3, 7, 8, 9, 3, 9, 8, 7);
    Figure fifthsf = f(fifthsr, fifthsm, fifths);
    
    Rhythm guitar1r = r(s(-.5,.5), s(0, .8), s(1, .8));
    Melody guitar1m = m(n(-11, -14), n(-10, -13), n(-10, -13));
    Figure guitar1f = f(guitar1r, guitar1m, guitar);

    Rhythm guitar2r = r(s(-.5,.5), s(0, .5), s(.5, .5), s(1, .5));
    Melody guitar2m = m(n(-10, -13), n(-10, -13), n(-11, -14), n(-10, -13));
    Figure guitar2f = f(guitar2r, guitar2m, guitar);

    // Kick drum intro
    add1(gf(kickf));
    add1(gf(kick2f));
    add1(gf(kickf));
    add1(gf(kick2f));
    
    // The famous synth pad line
    add1(gf(kick3f, pad1f));
    add1(gf(kick3f, snaref));
    add1(gf(kick3f, pad2f));
    add1(gf(kick3f, snaref));
    add1(gf(kick3f, pad3f));
    add1(gf(kick3f, snaref));
    add1(gf(kick3f, pad2f));
    add1(gf(kick3f, snaref));

    // Add in the hihats, bass, and staccatto "texture" synth part
    add1(gf(kickf, snare2f, hihatf, bassf, pad1f, synth1f));
    add1(gf(kick2f, snare3f, hihatf, bass2f, synth2f));
    add1(gf(kickf, snare2f, hihatf, bassf, pad2f, synth1f));
    add1(gf(kick2f, snare3f, hihatf, bass2f, synth3f));
    add1(gf(kickf, snare2f, hihatf, bassf, pad3f, synth1f));
    add1(gf(kick2f, snare3f, hihatf, bass2f, synth2f));
    add1(gf(kickf, snare2f, hihatf, bassf, pad2f, synth1f));
    add1(gf(kick2f, snare3f, hihatf, bass2f, synth3f));

    // Fifths lead
    add1(gf(kickf, snare2f, hihatf, bassf, fifthsf));
    add1(gf(kick2f, snare3f, hihatf, bass2f));
    
    // Guitar
    add1(gf(kickf, snare2f, hihatf, guitar1f));
    add1(gf(kickf, snare2f, hihatf, guitar2f));
    
    // Fifths lead
    add1(gf(kickf, snare2f, hihatf, bassf, fifthsf));
    add1(gf(kick2f, snare3f, hihatf, bass2f));
    
    // Guitar
    add1(gf(kickf, snare2f, hihatf, guitar1f));
    add1(gf(kickf, snare2f, hihatf, guitar2f));

    //audition(pad2);
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
