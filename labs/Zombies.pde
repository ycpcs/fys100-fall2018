import java.lang.reflect.Array;
import java.util.Comparator;
import java.util.function.Function;
import java.util.function.Predicate;

/////////////////////////////////////////////////////////////////////////////
// Simulation parameters
/////////////////////////////////////////////////////////////////////////////

// distance to move when trying to escape from sick persons
final float ESCAPE_MOVE_DIST = 5.0;

// distance that sick person (zombie) can move
final float ZOMBIE_MOVE_DIST = 3.5;

// Radius within which a sick person could infect a healthy person
final float INFECT_RADIUS = 10.0;

// Probability of being infected by a sick person within INFECT_RADIUS
final float INFECT = 0.80;

// probability that a sick person recovers
final float RECOVERY = 0;

final int WIDTH = 480;//600;
final int HEIGHT = 480;//600;
final int NUM_PERSONS = 1000;

// persons try to be at least this far apart from each other
final float MAXCROWD = 2.0;

// if any sick persons are within this radius,
// try to move away
final float PARANOIA = 160.0;

// normal move distance (when not trying to escape from sick persons)
final float NORMAL_MOVE_DIST = 3.0;

// generate this many random moves when deciding how a person
// should move (normally, to escape disease, or to pursue normals)
final int NUM_MOVES = 6;

// probability that a person is sick initially
final float INIT_SICK = 0.01;

// Probability that a healthy person becomes sick spontaneously
final float SPONTANEOUS_INFECT = 0; // 0.00001;

// Radius within which zombie will pursue victim
final float AGRESSION_RADIUS = 300;

/////////////////////////////////////////////////////////////////////////////
// Implementation
/////////////////////////////////////////////////////////////////////////////

// Precomputed sine and cosine values for angles describing 360
// degree rotation by 1 degree increments.
float[] SIN = new float[360];
float[] COS = new float[360];
{
  for (int i = 0; i < 360; i++) {
    float theta = (2*(float)Math.PI) * (i / 360.0);
    SIN[i] = sin(theta);
    COS[i] = cos(theta);
  }
}

boolean paused = false;

// Represents a person
class Person {
  float x, y; // location
  boolean sick; // true if this person is sick
  Point where() { return new Point(x, y); }
  double distanceFrom(Person other) {
    return where().distanceFrom(other.where());
  }
  void moveTo(Point where) {
    x = where.x;
    y = where.y;
  }
  Person dup() {
    Person copy = new Person();
    copy.x = x;
    copy.y = y;
    copy.sick = sick;
    return copy;
  }
}

// Represents a location (x/y coordinates)
class Point {
  final float x, y;
  Point(float x, float y) { this.x = x; this.y = y; }
  
  double distanceFrom(Point other) {
    double xdiff = other.x - this.x;
    double ydiff = other.y - this.y;
    return Math.sqrt(xdiff*xdiff + ydiff*ydiff);
  }
}

class LessThan implements Comparator<Float> {
  public int compare(Float left, Float right) { return left.compareTo(right); }
}

class GreaterThan implements Comparator<Float> {
  public int compare(Float left, Float right) { return right.compareTo(left); }
}

// Predicate to test whether any sick persons are in proximity
// to a subject person.  As a side effect, determine minimum
// distance to any sick person.
class CloseToSickPerson implements Predicate<Person> {
  Person subj;
  float minDist = Float.MAX_VALUE;
  CloseToSickPerson(Person p) { this.subj = p; }
  public boolean test(Person q) {
    boolean close = false;
    if (subj != q && q.sick) {
       float dist = (float)q.distanceFrom(subj);
       if (dist < minDist) {
         minDist = dist;
       }
       if (dist < PARANOIA) {
         close = true;
       }
    }
    return close;
  }
  float getMinDist() {
    return minDist;
  }
}

// Predicate to test whether any healthy persons are in proximity
// to a subject person.  As a side effect, determine minimum
// distance to any healthy person.
class CloseToHealthyPerson implements Predicate<Person> {
  Person subj;
  float minDist = Float.MAX_VALUE;
  CloseToHealthyPerson(Person p) { this.subj = p; }
  public boolean test(Person q) {
    boolean close = false;
    if (subj != q && !q.sick) {
       float dist = (float)q.distanceFrom(subj);
       if (dist < minDist) {
         minDist = dist;
       }
       if (dist < AGRESSION_RADIUS) {
         close = true;
       }
    }
    return close;
  }
  float getMinDist() {
    return minDist;
  }
}

// Predicate to test whether a point is not too close to any
// person (besides the subject person (to test whether it is
// ok for a subject person to move to the point)
class NotTooClose implements Predicate<Point> {
  Person subj;
  NotTooClose(Person p) {
    subj = p;
  }
  public boolean test(Point pt) {
    boolean tooClose = false;
    for (int i = 0; i < persons.length; i++) {
      if (persons[i] != subj && subj.where().distanceFrom(pt) < MAXCROWD) {
        tooClose = true;
        break;
      }
    }
    return !tooClose;
  }
}

// Get person's location
class LocationOfPerson implements Function<Person,Point> {
  public Point apply(Person p) {
    return p.where();
  }
}

// Compute distance from a specified point
class DistanceFrom implements Function<Point,Float> {
  Point place;
  DistanceFrom(Point p) { place = p; }
  public Float apply(Point other) {
    return (float)place.distanceFrom(other);
  }
}

// Function to compute a Point's minimum distance from any member
// of a collection of infected persons
class MinDistanceFromInfectedPerson implements Function<Point,Float> {
  Person[] sickies;
  MinDistanceFromInfectedPerson(Person[] s) { sickies = s; }
  public Float apply(Point place) {
    Point[] locations = new Point[sickies.length];
    map(sickies, new LocationOfPerson(), locations);
    Point min = optimize(locations, new DistanceFrom(place), new LessThan());
    return (float) min.distanceFrom(place);
  }
}

// Compute minimum distance to any healthy person 
class MinDistanceFromHealthyPerson implements Function<Point,Float> {
  Person[] victims;
  MinDistanceFromHealthyPerson(Person[] s) { victims = s; }
  public Float apply(Point place) {
    Point[] locations = new Point[victims.length];
    map(victims, new LocationOfPerson(), locations);
    Point min = optimize(locations, new DistanceFrom(place), new LessThan());
    return (float) min.distanceFrom(place);
  }
}

class Work {
  int start, end;
}

java.util.concurrent.LinkedBlockingQueue<Work> workQ =
  new java.util.concurrent.LinkedBlockingQueue<Work>();
java.util.concurrent.LinkedBlockingQueue<Work> doneQ =
  new java.util.concurrent.LinkedBlockingQueue<Work>();

class Worker implements Runnable {
  public void run() {
    try {
      while (true) {
        Work work = workQ.take();
        if (work.start < 0) { return; }
        //System.out.printf("Simulating %d..%d\n", work.start, work.end);
        for (int i = work.start; i < work.end; i++) {
          Person p;
          if (persons[i].sick) {
            p = simulateZombie(i);
          } else {
            p = simulatePerson(i);
          }
          nextGen[i] = p;
        }
        doneQ.put(work);
      }
    } catch (InterruptedException e) {
      println("Interrupted!");
    }
  }
}

Thread[] threads = new Thread[Runtime.getRuntime().availableProcessors()];

Person[] persons = new Person[NUM_PERSONS];
Person[] nextGen = new Person[NUM_PERSONS];

PFont myFont;

final boolean PARALLEL = true;

final int FPS = 10;

void setup() {
  size(480,480);

  myFont = createFont("arial", 32);

  // Create initial population
  for (int i = 0; i < NUM_PERSONS; i++) {
    Person p = null;
    while (p == null) {
      Person q = new Person();
      q.x = random(WIDTH);
      q.y = random(HEIGHT);
      
      boolean ok = true;
      for (int j = 0; j < i; j++) {
        if (persons[j].distanceFrom(q) < MAXCROWD) {
          ok = false;
          break;
        }
      }
      if (ok) { p = q; }
    }
    persons[i] = p;
    if (random(1) < INIT_SICK) {
      p.sick = true;
    }
  }

  if (PARALLEL) {
    for (int i = 0; i < threads.length; i++) {
      threads[i] = new Thread(new Worker());
      threads[i].start();
    }
  }

  frameRate(FPS);
  //noLoop();
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
}

int ticks = 0;

void draw() {
  background(225);
  strokeWeight(0);

  if (!paused) {
    simulate();
  }
  
  // Print persons (using color to represent healthy/sick)
  for (int i = 0; i < NUM_PERSONS; i++) {
    Person p = persons[i];
    if (p.sick) {
      stroke(44,128,44,50);
      fill(44,128,44,50);
      ellipse(p.x, p.y, 2*INFECT_RADIUS,2*INFECT_RADIUS);
      stroke(0,128,0);
      fill(0,128,0);
      ellipse(p.x, p.y, 2.0, 2.0);
    }
    else {
      stroke(0);
      fill(0);
      ellipse(p.x, p.y, 2.0, 2.0);
    }
  }
  
  // Print stats
  int[] stats = computeStats();
  textFont(myFont);
  fill(64, 64, 170, 128);
  text("Zombies: " + String.format("%5.1f%%", ((float)stats[0]/persons.length)*100.0f), 190, 400);
  
  // Print time
  int sec = ticks / (FPS);
  int frac = ((ticks % (FPS)) * 100) / FPS;
  String time = String.format("%3d.%02d", sec, frac);
  text(time, 20, 400);
  
  if (paused) {
    text("Paused", 190, 240);
  } else {
    ticks++;
  }
}

int[] computeStats() {
  int[] stats = {0};
  for (int i = 0; i < persons.length; i++) {
    if (persons[i].sick) {
      stats[0]++;
    }
  }
  return stats;
}

// Do computations for one time step of the simulation
void simulate() {
  try {
    doSimulate();
  } catch (InterruptedException e) {
    // ignore
  }
}

void doSimulate() throws InterruptedException {
  if (!PARALLEL) {
    for (int i = 0; i < NUM_PERSONS; i++) {
      Person p;
      if (persons[i].sick) {
        p = simulateZombie(i);
      } else {
        p = simulatePerson(i);
      }
      nextGen[i] = p;
    }
  } else {
    // Send work to worker threads
    int numChunks = threads.length * 4;
    int chunkSize = persons.length / numChunks;
    for (int i = 0; i < numChunks; i++) {
      Work work = new Work();
      work.start = i*chunkSize;
      work.end = work.start + chunkSize;
      if (i == numChunks - 1) { work.end += persons.length % chunkSize; }
      workQ.put(work);
    }

    // Wait for work to be complete
    for (int i = 0; i < numChunks; i++) {
      doneQ.take();
      //println("Received notification");
    }
    //println("All workers done");
  }
  
  // flip arrays
  Person[] t = persons;
  persons = nextGen;
  nextGen = t;
}

Person simulateZombie(int i) {
  Person clone = persons[i].dup();
  
  // Check whether any victims are within agression radius
  CloseToHealthyPerson pred = new CloseToHealthyPerson(clone);
  Person[] victims = take(i, pred);
  
  Point next;
  if (victims.length > 0) {
    // pursue!
    Point[] randMoves = computeRandomMoves(i, ZOMBIE_MOVE_DIST);
    next = moveTowards(randMoves, clone, victims);
  } else {
    // normal random move
    float moveDist = NORMAL_MOVE_DIST;

    // No sick persons in paranoia raduis: move randomly
    Point[] randMoves = computeRandomMoves(i, moveDist);
    next = pickMove(clone, randMoves);
  }
  clone.moveTo(next);
  
  // check for spontaneous recovery
  if (random(1) < RECOVERY) {
    clone.sick = false;
  }
  
  return clone;
}

Person simulatePerson(int i) {
  Person clone = persons[i].dup();
  
  // Find out if there are any infected persons within PARANOIA radius
  CloseToSickPerson pred = new CloseToSickPerson(clone);
  Person[] infected = take(i, pred);
  
  // Compute a next move
  Point next;
  
  // Check whether there are any infected persons within
  // PARANOIA radius
  if (infected.length > 0) {
    float moveDist = ESCAPE_MOVE_DIST;
    
    // Compute random moves, pick the one that maximizes the
    // minimim distance to an infected person
    Point[] randMoves = computeRandomMoves(i, moveDist);
    next = moveAway(randMoves, clone, infected);
  } else {
    float moveDist = NORMAL_MOVE_DIST;

    // No sick persons in paranoia raduis: move randomly
    Point[] randMoves = computeRandomMoves(i, moveDist);
    next = pickMove(clone, randMoves);
  }
  clone.moveTo(next);
  
  // Check for spontaneous sickness
  // or infection spread from a sick person
  if (random(1) < SPONTANEOUS_INFECT) {
    clone.sick = true;
  } else if (pred.getMinDist() < INFECT_RADIUS && random(1) < INFECT) {
    clone.sick = true;
  }
  
  return clone;
}

Person[] take(int ignore, Predicate<Person> pred) {
  ArrayList<Person> result = new ArrayList<Person>();
  for (int i = 0; i < NUM_PERSONS; i++) {
    if (i != ignore && pred.test(persons[i])) {
      result.add(persons[i]);
    }
  }
  return result.toArray(new Person[result.size()]);
}

Point[] computeRandomMoves(int index, float moveDist) {
  Person subj = persons[index];
  Point[] moves = new Point[NUM_MOVES];
  
  for (int i = 0; i < NUM_MOVES; i++) {
    boolean inBounds = false;
    float upx=0, upy=0;
    while (!inBounds) {
      int t = (int)random(360); // choose a random angle
      upx = subj.x + (moveDist * SIN[t]);
      upy = subj.y + (moveDist * COS[t]);
      inBounds = upx >= 0 && upx < WIDTH && upy >= 0 && upy < HEIGHT;
    }
    moves[i] = new Point(upx, upy);
  }
  
  return moves;
}

Point moveAway(Point[] moves, Person subj, Person[] sickies) {
  // Check to see which moves (if any) are not within MAXCROWD
  // distance of any person
  Point[] notTooClose = filter(moves, new NotTooClose(subj), Point.class);
  
  // Candidate moves
  Point[] candidates = (notTooClose.length > 0) ? notTooClose : moves;
  return optimize(candidates, new MinDistanceFromInfectedPerson(sickies), new GreaterThan());
}

Point moveTowards(Point[] moves, Person subj, Person[] victims) {
  // Check to see which moves (if any) are not within MAXCROWD
  // distance of any person
  Point[] notTooClose = filter(moves, new NotTooClose(subj), Point.class);
  
  // Candidate moves
  Point[] candidates = (notTooClose.length > 0) ? notTooClose : moves;
  return optimize(candidates, new MinDistanceFromHealthyPerson(victims), new LessThan());
}

// Pick a random move for subject person, trying to avoid placing
// the person too close to another person
Point pickMove(Person subj, Point[] moves) {
  Point[] notTooClose = filter(moves, new NotTooClose(subj), Point.class);
  Point[] candidates = (notTooClose.length > 0) ? notTooClose : moves;
  return candidates[int(random(candidates.length))];
}

<E> E optimize(E[] arr, Function<E,Float> fn, Comparator<Float> comp) {
  int best = 0;
  float bestVal = fn.apply(arr[0]);
  for (int i = 1; i < arr.length; i++) {
    float itsVal = fn.apply(arr[i]);
    if (comp.compare(itsVal, bestVal) < 0) {
      best = i;
      bestVal = itsVal;
    }
  }
  return arr[best];
}

<From,To> void map(From[] src, Function<From,To> fn, To[] dest) {
  for (int i = 0; i < src.length; i++) {
    dest[i] = fn.apply(src[i]);
  }
}

<E> E[] filter(E[] src, Predicate<E> pred, Class<E> type) {
  E[] temp = (E[]) Array.newInstance(type, src.length);
  int count = 0;
  for (int i = 0; i < src.length; i++) {
    E val = src[i];
    if (pred.test(val)) {
      temp[count++] = val;
    }
  }
  E[] result = (E[]) Array.newInstance(type, count);
  System.arraycopy(temp, 0, result, 0, count);
  return result;
}