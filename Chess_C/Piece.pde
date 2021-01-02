class Piece
{
  private int team;
  private PVector boardPos, pos; //boardPos is index in grid, pos is position on screen
  private PImage image;
  private ArrayList<Piece> moveTiles = new ArrayList(); //reachable tiles
  private boolean selected = false;
  
  public Piece(PVector boardPos) //blank tile
  {
    setBoardPos(boardPos);
    team = -1;
  }
  public Piece(PVector boardPos, int team, PImage image) //actual piece
  {
    setBoardPos(boardPos);
    setTeam(team);
    setImage(image);
  }
  
  void show() //draws piece
  {
    imageMode(CORNER);
    
    if(selected && !firstClick) //highlighting
    {
      highlight();
      
      for(Piece piece : moveTiles) //highlights reachable tiles
        piece.highlight();
    }
    
    image(image, pos.x, pos.y, boardCellSize, boardCellSize);
  }
  
  void move(int newX, int newY)
  {
    setBoardPos(new PVector(newX, newY));
  }
  
  void getTiles() {}
  
  void highlight() //highlights piece/tile
  {
    rectMode(CORNER);
    
    if(getTeam() == -1) //highlights blank tile
    {
      noStroke();
      fill(0, 50);
      circle(getPos().x + boardCellSize / 2, getPos().y + boardCellSize / 2, boardCellSize / 2.5);
    }
    else //highlights actual piece
    {
      noStroke();
      fill(0, 50);
      square(getPos().x, getPos().y, boardCellSize);
    }
  }
  
  //getters & setters
  void setTeam(int team) { this.team = team; }
  int getTeam() { return team; }
  
  void setBoardPos(PVector boardPos)
  {
    this.boardPos = boardPos;
    pos = new PVector(boardPosA + boardPos.x * boardCellSize, boardPosA + boardPos.y * boardCellSize);
  }
  PVector getBoardPos() { return boardPos; }
  PVector getPos() { return pos; }
  
  void setImage(PImage image) { this.image = image; }
  PImage getImage() { return image; }
  
  void setSelected(boolean bool) { this.selected = bool; }
  boolean getSelected() { return selected; }
  
  void setMoveTiles(ArrayList<Piece> moveTiles) { this.moveTiles = moveTiles; }
  ArrayList<Piece> getMoveTiles() { return moveTiles; }
  
  Piece getCopy() { return new Piece(getBoardPos()); }
}
