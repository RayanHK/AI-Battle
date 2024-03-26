class Terrain{
  int tileSize = 2;
  int tilesDown = height/tileSize;
  int tilesAlong = width/tileSize;
  float scale = 0.05;
  
  color waterColour = color(0, 204, 204);
  color grassColour = color(0, 255, 110);
  color forestColour = color(0, 195, 0);
  color sandColour = color(255, 204, 0);
  
  color trenchColour = color(128, 85, 0);
  
  //Boolean[][] trenches = new Boolean[tilesAlong][tilesDown];
  
  private color generateTerrain(int x, int y){
    float noisePosition = noise(x*scale, y*scale);
    
    if (noisePosition <0.35){
      return waterColour;
    }
    
    else if(noisePosition <0.37){
      return sandColour;
    }
    
    else if (noisePosition <0.6){
      return grassColour;
    }
    
    else{    
      return forestColour;
    }
  }
  
  public void displayTerrain(){
    for (int i = 0; i < width/tileSize; i++){
      for (int j = 0; j < height/tileSize; j++){
        fill(generateTerrain(i, j));
        rect(i*tileSize, j*tileSize, tileSize, tileSize);
      }
    }
    
   /* for (int i = 0; i < width/tileSize; i++){
      for (int j = 0; j < height/tileSize; j++){
        if(trenches[i][j] == true){
          generateConstruction(i, j, trenchColour);
        }
        
        else{
        }
      }*/
  }
  
  public int getTilesAlong(){
    return tilesAlong;
  }
  
  public void generateConstruction(int x, int y, color constructionColour){
    fill(constructionColour);
    rect(x*tileSize, y*tileSize, tileSize, tileSize);
  }
  
  public color getTileType(int x, int y){   
    return get(x, y);
  }
}
