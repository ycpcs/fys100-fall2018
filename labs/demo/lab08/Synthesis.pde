import io.github.daveho.funwithsound.*;
import net.beadsproject.beads.core.*;
import net.beadsproject.beads.data.*;

FunWithSound fws = new FunWithSound(this) {
  protected Player createPlayer() {
    Player player = super.createPlayer();
    registerCustomInstruments(player);
    return player;
  }
};

// Directory where you keep your soundfonts
String SOUNDFONTS = "C:/SoundFonts";

String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";

class MyComp extends Composer {
  void create() {
    tempo(110, 4);
    major(60);

    // Create instruments
    Instrument drumkit = percussion(TR808);
    
    // Custom monosynth instrument
    Instrument synth = custom(0); // <-- change this to select among the custom instruments
    v(synth, 0.2); // the custom instruments are very loud 

    // Create rhythms, melodies, and figures
    Rhythm metr = r(p(0), p(1), p(2), p(3));
    Figure metf = pf(metr, 42, drumkit);

    // Schedule figures to be played
    add1(gf(metf));
    add1(gf(metf));
    add1(gf(metf));
    add1(gf(metf));
    
    audition(synth);
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

void registerCustomInstruments(Player player) {
  // The code below defines the characteristics of the custom instruments.
  // Comments indicate where you can make changes.
  
  CustomInstrumentFactory factory = new CustomInstrumentFactoryImpl(
    // Custom instrument 0: plays simple wave forms with a single frequency,
    // using a simple on/off envelope
    0, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 0.0f);
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withOnOffNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0 },
          new double[]{ 1.0 }
          );
        return new RealizedInstrument(u, ac);
      }
    },
    
    // Custom instrument 1: simple waveforms with a single frequency,
    // but with an attack/sustain/release envelope
    1, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 0.0); // <-- try increasing this for portamento
        params.put(ParamNames.ATTACK_TIME_MS, 10.0); // <-- change the attack time
        params.put(ParamNames.RELEASE_TIME_MS, 80.0); // <-- change the release time
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withASRNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0 },
          new double[]{ 1.0 }
          );
        return new RealizedInstrument(u, ac);
      }
    },
    
    // Custom instrument 2: simple wave forms with multiple frequencies,
    // with attack/sustain/release envelope
    2, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 40.0);
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SINE) // <-- try Buffer.SQUARE, Buffer.SAW, Buffer.TRIANGLE
          .withASRNoteEnvelope()
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0, 1.5, 2.0 }, // <-- try changing the multiples, adding new multiples
          new double[]{ 1.0, 0.5, 0.25 } // <-- try changing the gains (volumes)
          );
        return new RealizedInstrument(u, ac);
      }
    }
    
    );
  player.setCustomInstrumentFactory(factory);
}
