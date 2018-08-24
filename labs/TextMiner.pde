import controlP5.*;
import java.io.*;
import java.util.*;

ControlP5 cp5;
Textfield filename;
Textfield word;
Textarea results;
Button statsBtn;
Button top20Btn;
Button top100Btn;
Button occurBtn;

Set<String> boringWords = new HashSet<String>();

void setup() {
  size(640, 520);
  final int width=640, height=520;
  
  // These are "boring" words that we want to exclude from the analysis.
  boringWords.addAll(Arrays.asList(
    "the", "and", "a", "of", "to", "in", "i", "he", "was", "with",
    "that", "at", "it", "you", "had", "for", "on",
    "this", "by", "be", "have", "not", "but", "all", "they",
    "which", "sir", "my", "him", "very",
    "if", "from", "were", "an", "so", "no", "up", "there", "who", "me",
    "her", "or", "been", "what", "when", "one", "into", "your", "do",
    "out", "here", "are", "upon", "she",
    "could", "would", "any", "than", "their", "them",
    "only", "has", "am"
  ));
  
  cp5 = new ControlP5(this);
  
  PFont font = createFont("arial",16);
  PFont monofont = createFont("courier", 16);
  
  filename = cp5.addTextfield("filename")
    .setPosition(20, 20)
    .setSize(width/2-30, 40)
    .setFont(font)
    .setFocus(true)
    .setColor(color(211))
  ;
  
  word = cp5.addTextfield("word")
    .setPosition(width/2+10, 20)
    .setSize(width/2-30, 40)
    .setFont(font)
    .setColor(color(211))
    ;
  
  int bx = 20;
  statsBtn = cp5.addButton("stats")
    .setPosition(bx, 80)
    .setSize(120, 30)
    ;
  bx += 140;
  
  top20Btn = cp5.addButton("top20")
    .setPosition(bx,80)
    .setSize(120, 30)
    ;
  bx += 140;
  
  top100Btn = cp5.addButton("top100")
    .setPosition(bx, 80)
    .setSize(120, 30)
    ;
  bx += 140;
    
  occurBtn = cp5.addButton("occurrences")
    .setPosition(bx,80)
    .setSize(120, 30)
    ;
  bx += 140;
  
  results = cp5.addTextarea("Results")
    .setPosition(20, 120)
    .setSize(width-40,height-120-20)
    .setFont(monofont)
    .setLineHeight(18)
    .setColor(color(211))
    .setColorBackground(color(255,100))
    .setColorForeground(color(255,100));
    ;
}

void draw() {
  background(0);
  fill(255);
}

public void controlEvent(ControlEvent theEvent) {
}

interface Callback {
  void onWord(String word);
}

public void stats(int theValue) {
  try {
    String fname = filename.getText();
    //println("fname: " + fname);
    final int[] stats = { 0 }; // word count
    analyze(fname, new Callback() {
      public void onWord(String w) {
        stats[0]++;
      }
    });
    clearResults();
    appendResult("Words: " + stats[0]);
  } catch (Throwable e) {
    println("Error analyzing file: " + e.toString());
  }
}

public void top20(int theValue) {
  topN(20);
}

public void top100(int theValue) {
  topN(100);
}

void topN(int n) { 
  final HashMap<String,Integer> counts = new HashMap<String,Integer>();
  try {
    String fname = filename.getText();
    analyze(fname, new Callback() {
      public void onWord(String w) {
        if (boringWords.contains(w)) {
          return;
        }
        Integer count = counts.get(w);
        if (count == null) { counts.put(w, 1); }
        else { counts.put(w, count + 1); }
      }
    });
    ArrayList<Map.Entry<String,Integer>> sortedEntries = new ArrayList<Map.Entry<String,Integer>>();
    sortedEntries.addAll(counts.entrySet());
    // Sort entries in descending order by count (using word order as a tiebreaker)
    Collections.sort(sortedEntries, new Comparator<Map.Entry<String,Integer>>() {
      public int compare(Map.Entry<String,Integer> lhs, Map.Entry<String,Integer> rhs) {
        if (lhs.getValue() > rhs.getValue()) {
          return -1;
        } else if (lhs.getValue() < rhs.getValue()) {
          return 1;
        } else {
          return lhs.getKey().compareTo(rhs.getKey());
        }
      }
    });
    clearResults();
    for (int i = 0; i < n; i++) {
      Map.Entry<String,Integer> entry = sortedEntries.get(i);
      appendResult(entry.getKey() + ": " + entry.getValue());
    }
  } catch (Throwable e) {
    println("Error analyzing file: " + e.toString());
  }
}

public void occurrences(int theValue) {
  String fname = filename.getText();
  final String wordToFind = word.getText().toLowerCase();
  final int[] occur = new int[1];
  try {
    analyze(fname, new Callback() {
      public void onWord(String w) {
        if (w.equals(wordToFind)) {
          occur[0]++;
        }
      }
    });
    clearResults();
    appendResult(wordToFind + ": " + occur[0]);
  } catch (Throwable e) {
    println("Error analyzing file: " + e.toString());
  }
}

void analyze(String fname, Callback callback) throws Exception {
  BufferedReader r = new BufferedReader(new FileReader(fname));
  try {
    while (true) {
      String line = r.readLine();
      if (line == null) { break; }
      String[] toks = line.split("\\s+");
      for (String w : toks) {
        w = w.toLowerCase();
        w = stripPunctuation(w);
        if (w.equals("")) {
          continue;
        }
        if (!boringWords.contains(w)) {
          // This is very cheesy and imprecise, but try to convert plural forms to singular
          if (w.endsWith("ies")) {
            w = w.substring(0, w.length()-3) + "y";
          } else if (w.endsWith("es")) {
            w = w.substring(0, w.length()-2);
          } else if (!w.endsWith("ss") && w.endsWith("s")) {
            w = w.substring(0, w.length()-1);
          }
        }
        callback.onWord(w);
      }
    }
  } finally {
    r.close();
  }
}

String stripPunctuation(String s) {
  StringBuilder buf = new StringBuilder();
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (Character.isAlphabetic(c)) {
      buf.append(c);
    }
  }
  return buf.toString();
}

void clearResults() {
  results.setText("");
}

void appendResult(String line) {
  String res = results.getText();
  results.setText(res + line + "\n");
}