ArrayList<Soldier> soldiers;
HeadQuarters HQ = new HeadQuarters();
Terrain terrain = new Terrain();

int redSoldiers = 20;
int blueSoldiers = 20;
int totalSoldiers = (redSoldiers+blueSoldiers)-1;

int activeSoldiers = totalSoldiers;


// Key settings
Boolean displayVision = false;
Boolean paused = false;

void setup(){
  size(1080, 720);
  noStroke();
  terrain.displayTerrain();
  
  soldiers = new ArrayList<Soldier>();
  
  for (int i = 0; i<=totalSoldiers; i++){  // Looping through every soldier object and adding it to array
    soldiers.add(new Soldier());
  }
  
  int soldiersToSort = totalSoldiers;
  // Assigning teams
  for (int i = totalSoldiers; i>=0; i--){ //Loops through every soldier object
    
    Soldier soldier = soldiers.get(i);
    
    if (soldiersToSort >= blueSoldiers){
      soldiersToSort-=1;
      soldier.faction = "red";
      soldier.factionChoice = 1;
    }
    
    else{
      soldier.faction = "blue";
      soldier.factionChoice = 2;
    }   
  }  
}

void keyPressed(){
  if (key == 'v' || key == 'V'){
    displayVision = true;
  }
  
  if (key == 'p' || key == 'P'){
    paused = !paused;
  }
  
  if (key == 'r' || key == 'R'){
    setup();
  }
  
  if (key == 'b' || key == 'B'){
    Soldier a = new Soldier();
    a.faction = "blue";
    a.x = mouseX;
    a.y = mouseY;
    soldiers.add(a);
  }
  
  if (key == 'n' || key == 'N'){
    Soldier a = new Soldier();
    a.faction = "red";
    a.x = mouseX;
    a.y = mouseY;
    soldiers.add(a);
  }
}

void keyReleased() {
  if (key == 'v' || key == 'V'){
    displayVision = false;
  }
}

void draw(){
  
  if (paused == false){
    terrain.displayTerrain();
    
    for (int i = soldiers.size()-1; i>=0; i--){ //Loops through every soldier object
      Soldier soldier = soldiers.get(i);   
      
      // Checks if it is alive
      
      if (soldier.alive == false){
        soldiers.remove(soldier);
      }
      
      for (int j = soldiers.size()-1; j>=0; j--){ // Checks every object to see if they're colliding with the selected object
        soldier.distances(soldiers.get(j));
      }
      
      if (displayVision == true){
        soldier.displayVision();
      }
      
      //println("I am ", soldier.faction, " and am I pinged: ", soldier.currentlyPinged);
      
      soldier.display();
      
    }
  }
  
  
}
