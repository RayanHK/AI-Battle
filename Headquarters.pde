class HeadQuarters{
  
  Boolean activeRedPing = false;
  Boolean activeBluePing = false;
  
  int[][] redPingList = new int[5][5];
  int[][] bluePingList = new int[5][5];
  
  
  private void alertPing(String faction, String action){
    
    if (action == "ping"){
      switch (faction){
        case "red":
          activeRedPing = true;
          break;
        
        case "blue":
          activeBluePing = true;
          break;
      }
    }
    
    else if (action == "unping"){
      switch (faction){
        case "red":
          activeRedPing = false;
          break;
        
        case "blue":
          activeBluePing = false;
          break;
      }
    }
  }
  
  public void validatePing(String faction, int x, int y){
    
    if (faction == "blue" && bluePingList[0][0] == 0){
      ping(faction, x, y);
      alertPing(faction, "ping");
    }
    
    else if (faction == "red" && redPingList[0][0] == 0){
      ping(faction, x, y);
      alertPing(faction, "ping");
    }   
  }
  
  private void ping(String faction, int x, int y){

    switch (faction){
        case "red":
          redPingList[0][0] = x;
          redPingList[0][1] = y;
          break;
        
        case "blue":
          bluePingList[0][0] = x;
          bluePingList[0][1] = y;
          break;    
    }
  }
  
  public void removePing(String faction){
    switch (faction){
        case "red":
          redPingList[0][0] = 0;
          redPingList[0][1] = 0;
          break;
        
        case "blue":
          bluePingList[0][0] = 0;
          bluePingList[0][1] = 0;
          break;    
    }
    alertPing(faction, "unping");
  }
  
}
