import java.util.*;

class Soldier{
  int x;
  int y;
  int size = 10;
  float speed = 2;
  int health = 100;
  int vision = 100;
  
  int maxHealth = health;
  float maxSpeed = speed;
  int maxVision = vision;
  
  int maxSize = size;
  
  Boolean alreadyMoved = false;  
  Boolean currentlyPinged = false;
  
  int[][] soldierDistances = new int[totalSoldiers][4];
  
  int direction;
  int prevDirection;
  
  String previousTileOn = "null";
  String tileOn = "null";
  
  int red = 0;
  int green = 0;
  int blue = 0;
  
  String faction;
  int factionChoice;
  
  boolean alive = true;
    
  color colour = color(red, green, blue);
  
  Soldier() {
    x = int(random(width));
    y = int(random(height));
  }
  
  public void display(){
    
    // Updates the stats of the soldier
    alive = checkHealth();
    colour = color(red, green, blue);
    
    // Only does things if it is alive;
    walkDirection();
    
    //Checks if there is an active ping
    switch (faction){
      case "red":
        currentlyPinged = HQ.activeRedPing;
        break;
      
      case "blue":
        currentlyPinged = HQ.activeBluePing;
        break;
    }
      
    // Draws the soldier;
    noStroke();
    fill(colour);
    ellipse(x, y, size, size); 
  }
  
  public void displayVision(){
    stroke(0);
    noFill();
    ellipse(x, y, vision, vision);
  }

  public boolean distances(Soldier object){    
    
    // Gets the type of terrain the soldiers is on and does the relevant actions
    color tileColour = get(x, y);
    
    if (tileColour == terrain.grassColour){
      tileOn = "grass";
    }
    
    else if (tileColour == terrain.waterColour){
      tileOn = "water";
    }
    
    else if (tileColour == terrain.forestColour){
      tileOn = "forest";
    }
    
    else if (tileColour == terrain.sandColour){
      tileOn = "sand";
    }
    
    // If the type of terrain changes, this is done
    if (tileOn != previousTileOn){
      speed = maxSpeed;
      vision = maxVision;
      size = maxSize;
    
      switch(tileOn){
        case "grass":
          speed += 0.2;
          break;
        
        case "water":
          speed /= 2;          
          break;
        
        case "sand":
          break;
        
        case "forest":
          vision /= 2;
          speed *= 0.75;
          size *= 0.9;          
          break;
      }
    }
    
    previousTileOn = tileOn;
    
    
    float distance = dist(this.x, this.y, object.x, object.y);
        
    if (distance < (this.size / 2) + (object.size) / 2 && object != this && this.faction != object.faction){ //If they are colliding, are not the same object and are not of the same faction then collision is true -- COLLISION DETECTION
      object.health -= 1;
      activeSoldiers-=1;
      return true; // Battle Script Goes here
    }
    
    //Attacks enemy soldiers that it can see
    if (faction != object.faction){
      HQ.validatePing(faction, object.x, object.y);
      alreadyMoved = true;
      
      if(distance <= vision){
        if (x-object.x > 0){
          x-=speed;
        }
        
        else if (x+object.x < 0){
          x+=speed;
        }
        
        if (y-object.y > 0){
          y-=speed;
        }
        
        else if (y+object.y < 0){
          y+=speed;
        }
      }
    }


    return false;
  }

  
  private boolean checkHealth(){
    if (this.health <= 0){ // Checks if soldier is dead (health 0)
      return false;
    }
    
    // Represents soldiers health by adjusting their colour
    switch (faction){
      case "red":
        red = 255-health;
        break;
      
      case "blue":
        blue = 255-health;
        break;
    }
    
    return true;
  }
  
  private void walkDirection(){
    direction = chooseDirection();
    
    switch (direction){
    case 1: //left
      if ((x-speed)<=0){
      }    
      else{
        x-=speed;
      }
      
      break;
    case 2: //right
      if ((x+speed)>=width){
      }
      else{
        x+=speed;
      }
      
      break;
    case 3: //down
      if ((y+speed)>=height){
      }
      else{
        y+=speed;
      } 
      
      break;
    case 4: //up
      if ((y-speed)<=0){
      }
      else{
        y-=speed;
      } 
      
      break;
      
    case 5:
      break;
    }
  }
  
  private int chooseDirection(){
    int number = 1;
    
    // Makes sure Soldiers can't leave the screen.
    int border = 10;
    
    if(x<border){
      number = 2; // right
    }
    
    else if (x>(width-border)){
     number = 1;  // left
    }
    
    else if (y<border){
      number = 3; // down
    }
    
    else if (y>(height-border)){
      number = 4; //up
    }
    
    else{ // Select state/behaviour
      
      if (currentlyPinged == true){
        number = ping();
      }
      else{
        number = wander();
      }
    }
    
    prevDirection = number;
    
    return number;
  }
  
  // Behaviours
  
  private int wander(){
    int number = int(random(1, 10));
      if (number == 1){
        number = int(random(1, 10));
        if (number == 1){
          number = int(random(1, 5));
        }
        
        else {
          if (prevDirection == 1 || prevDirection == 2){
            number = int(random(3, 5));
          }
          
          else{
            number = int(random(1, 3));
          }
        }
      }
      
      else {
        number = prevDirection;
      }
      
     return number;
  }
  
  private int pathFinding(int targetX, int targetY){
    int size = terrain.getTilesAlong();
    
    int startX = x; 
    int startY = y; 
    
    int tempStartX = x;
    int tempStartY = y;
    
    int currentX = x; 
    int currentY = y;  
    
    int tempTargetX = size;
    int tempTargetY = size;
    
    int[][] distance = new int[size][size]; 
    String[][] locationFrom = new String[size][size];
    
    int[][] matrix = terrain.distances;
    
    Queue<String> queue = new PriorityQueue();
    
    for (int i = 0; i<distance.length; i++){ 
      for (int j = 0; j<distance.length; j++){ 
        distance[i][j] = 99;         
        //print(matrix[i][j] + " "); 
      } 
      //print("\n"); 
    }    
    
    Boolean[][] visited = new Boolean[size][size];   
    for (int i = 0; i<distance.length; i++){ 
      for (int j = 0; j<distance.length; j++){ 
        visited[i][j] = false;
      } 
    } 
    
    distance[startX][startY] = 0; 
    visited[startX][startY] = true;
    queue.offer(str(0) + "l" + str(startX) + "l" + str(startY));
    int count = 1;
    Boolean loop = true;
    
    if (targetX == startX){
      if(tempTargetX +1 < size){
        tempTargetX ++;
      }
      else{
        tempTargetX --;
      }
    }
    
    while (loop){ 
      String a = queue.poll();
      try{
        int[] b = int((split(a, "l")));
        currentX = b[1]; 
        currentY = b[2];
      } catch (Exception e){
        //loop = false;
      }
      
      
      
      if (tempTargetX > currentX){
        try{
          if(distance[currentX+1][currentY] > distance[currentX][currentY] + matrix[currentX+1][currentY]){
            distance[currentX+1][currentY] = distance[currentX][currentY] + matrix[currentX+1][currentY];
            locationFrom[currentX+1][currentY] = currentX + "," + currentY;
            queue.offer(str(distance[currentX+1][currentY]) + "l" + str(currentX+1) + "l" + str(currentY));
          }     
          
        } catch (Exception e){
          }
      }
      
      if (tempTargetY > currentY){
        try{
          if(distance[currentX][currentY+1] > distance[currentX][currentY] + matrix[currentX][currentY+1]){
            distance[currentX][currentY+1] = distance[currentX][currentY] + matrix[currentX][currentY+1];
            locationFrom[currentX][currentY+1] = currentX + "," + currentY;
            queue.offer(str(distance[currentX][currentY+1]) + "l" + str(currentX) + "l" + str(currentY+1)); 
          }
        } catch (Exception e){
          }
        }
       
       if (tempTargetX < currentX){
        try{
          if(distance[currentX-1][currentY] > distance[currentX][currentY] + matrix[currentX-1][currentY]){
            distance[currentX-1][currentY] = distance[currentX][currentY] + matrix[currentX-1][currentY];
            locationFrom[currentX-1][currentY] = currentX + "," + currentY;
            queue.offer(str(distance[currentX-1][currentY]) + "l" + str(currentX-1) + "l" + str(currentY));  
          }
        } catch (Exception e){
          }
      }
      
      if (tempTargetY < currentY){
        try{
          if(distance[currentX][currentY-1] > distance[currentX][currentY] + matrix[currentX][currentY-1]){
            distance[currentX][currentY-1] = distance[currentX][currentY] + matrix[currentX][currentY-1];
            locationFrom[currentX][currentY-1] = currentX + "," + currentY;
            queue.offer(str(distance[currentX][currentY-1]) + "l" + str(currentX) + "l" + str(currentY-1));
          }
        } catch (Exception e){
          }
        }
      
      if (currentX == tempTargetX-1 && currentY == tempTargetY-1){
        tempTargetX = targetX;
        tempTargetY = targetY;
      }
      
      if (queue.isEmpty()){
        for (int i = 0; i<distance.length; i++){ 
          for (int j = 0; j<distance.length; j++){ 
            if (!visited[i][j]){
              if (distance[i][j]<distance[targetX][targetY]){
                queue.offer(str(distance[i][j]) + "l" + str(i) + "l" + str(j));
              }
            }
          } 
        } 
      }
      
      count++;
      
      if (count == 1000){
        loop = false;
      }
    }
        
    for (int i = 0; i<distance.length; i++){ 
      for (int j = 0; j<distance.length; j++){ 
        print(/*"|" +*/ distance[i][j] + " " /*+ locationFrom[i][j] + "|"*/); 
      } 
      print("\n"); 
    } 
    
    Boolean[][] path = new Boolean[size][size];
    for (int i = 0; i<size; i++){ 
      for (int j = 0; j<size; j++){ 
        path[i][j] = false;
      } 
    } 
    
    Queue<String> pathQueue = new PriorityQueue();
    for (int i = 0; i<size; i++){ 
      for (int j = 0; j<size; j++){ 
        pathQueue.offer(str(distance[i][j]) + "l" + str(i) + "l" + str(j));
      } 
    }
    
    Stack<Integer> finalPathX = new Stack();
    Stack<Integer> finalPathY = new Stack();
    finalPathX.push(targetX);
    finalPathY.push(targetY);
    
    path[startX][startY] = true;
    path[targetX][targetY] = true;
    
    currentX = targetX; currentY = targetY;
    int prevX, prevY;
    prevX = startX;
    prevY = startY;
    
    loop = true;
    count = 0;
    
    
    
    while (loop){
      count++;
      
      try{
        int[] nextLocation = int((split(locationFrom[currentX][currentY], ",")));
        currentX = nextLocation[0];
        currentY = nextLocation[1];
      } catch (Exception e){}
      
      
      path[currentX][currentY] = true;
      finalPathX.push(currentX);
      finalPathY.push(currentY);
      
      if (currentX == startX && currentY == startY){
        loop = false;
      }
    }
    
    for (int i = 0; i<size; i++){ 
      for (int j = 0; j<size; j++){ 
        //print(path[i][j] + " ");
      } 
      //println("  ");
    } 
    
   // while (!finalPathY.isEmpty()){
      //println(finalPathX.pop(), ",", finalPathY.pop());
    //}
  }
  
  private int ping(){
    int number = 6;
    int xDestination = 0;
    int yDestination = 0;
    
    if (faction == "blue"){
      xDestination = HQ.bluePingList[0][0];
      yDestination = HQ.bluePingList[0][1];
    }
    
    else if (faction == "red"){
      xDestination = HQ.redPingList[0][0];
      yDestination = HQ.redPingList[0][1];
    }
      
    int lowerX = xDestination-10;
    int upperX = xDestination+10;
    int lowerY = yDestination-10;
    int upperY = yDestination+10;
    
    int axisSelect;
    
    // Checks that the Soldier has a ping and is not already at destination
    
    if (xDestination == 0 && yDestination == 0 ){
      number = wander();
    }
    
    else if(x >= lowerX && x<= upperX && y >= lowerY && y<= upperY){
      currentlyPinged = false;
      HQ.removePing(faction);
    }
    
    else{
       
      // Decide which axis the soldier will travel across
      
      if (x >= lowerX && x<= upperX){
        axisSelect = 2;
      }
       
      else if (y >= lowerY && y<= upperY){
        axisSelect = 1;
      }
      
      else{
        axisSelect = int(random(1, 3));
      }
        
      // Movement logic
        
      if (axisSelect == 1){ // X-axis
          
        if (x-xDestination > 0){
          number = 1;
        }
          
        else if (x-xDestination < 0){
          number = 2;
        }
          
        else {
          number = 5;
        }
      }
      
      else if (axisSelect == 2){ //Y-axis
        
        if (y-yDestination > 0){
           number = 4;
        }
          
        else if (y-yDestination < 0){
          number = 3;
        }
        
        else {
          number = 5;
        }
      }
         
    }
    
    return number;
  }
}
