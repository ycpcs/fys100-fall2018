import java.lang.reflect.Array;
import java.util.Comparator;
import java.util.function.Function;
import java.util.function.Predicate;

/////////////////////////////////////////////////////////////////////////////
// Simulation parameters
/////////////////////////////////////////////////////////////////////////////

final int WIDTH = 600;
final int HEIGHT = 600;
final int NUM_PERSONS = 1000;

// persons should be at least this far apart from each other
final float MAXCROWD = 2.0;

// if any sick persons are within this radius,
// try to move away
final float PARANOIA = 160.0;

// normal move distance (when not trying to escape from sick persons)
final float NORMAL_MOVE_DIST = 3.0;

// distance to move when trying to escape from sick persons
final float ESCAPE_MOVE_DIST = 6.0;

// generate this many random moves when deciding how a person
// should move (normally or to escape disease)
final int NUM_MOVES = 10;

// probability that a person is sick initially
final float INIT_SICK = 0.005;

// probability that a sick person recovers
final float RECOVERY = 0.1;

// Probability that a healthy person becomes sick spontaneously
final float SPONTANEOUS_INFECT = 0.001;

// Radius within which a sick person could infect a healthy person
final float INFECT_RADIUS = 20.0;

// Probability of being infected by a sick person within INFECT_RADIUS
final float INFECT = 0.05;

/////////////////////////////////////////////////////////////////////////////
// Implementation
/////////////////////////////////////////////////////////////////////////////

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

Person[] persons = new Person[NUM_PERSONS];

PFont myFont;

void setup() {
  size(600,600);

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

  frameRate(10);
  //noLoop();
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
}

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
      stroke(255,128,128,50);
      fill(255,128,128,50);
      ellipse(p.x, p.y, 2*INFECT_RADIUS,2*INFECT_RADIUS);
      stroke(255,0,0);
      fill(255,0,0);
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
  fill(64, 64, 150, 128);
  text("Sick: " + String.format("%.1f%%", ((float)stats[0]/persons.length)*100.0f), 350, 520);
  
  if (paused) {
    text("Paused", 350, 560);
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
  for (int i = 0; i < NUM_PERSONS; i++) {
    simulatePerson(i);
  }
}

void simulatePerson(int i) {
  // Find out if there are any infected persons within PARANOIA radius
  CloseToSickPerson pred = new CloseToSickPerson(persons[i]);
  Person[] infected = take(i, pred);
  
  // Compute a next move
  Point next;
  
  // Check whether there are any infected persons within
  // PARANOIA radius
  if (infected.length > 0) {
    // Compute random moves, pick the one that maximizes the
    // minimim distance to an infected person
    Point[] randMoves = computeRandomMoves(i, ESCAPE_MOVE_DIST);
    next = moveAway(randMoves, persons[i], infected);
  } else {
    // No sick persons in paranoia raduis: move randomly
    Point[] randMoves = computeRandomMoves(i, NORMAL_MOVE_DIST);
    next = pickMove(persons[i], randMoves);
  }
  persons[i].moveTo(next);
  
  if (persons[i].sick) {
    // Check for spontaneous recovery
    if (random(1) < RECOVERY) {
      persons[i].sick = false;
    }
  } else {
    // Check for spontaneous sickness
    // or infection spread from a sick person
    if (random(1) < SPONTANEOUS_INFECT) {
      persons[i].sick = true;
    } else if (pred.getMinDist() < INFECT_RADIUS && random(1) < INFECT) {
      persons[i].sick = true;
    }
  }
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
      double theta = random((float)(2*Math.PI));
      upx = subj.x + (float)(moveDist * Math.cos(theta));
      upy = subj.y + (float)(moveDist * Math.sin(theta));
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