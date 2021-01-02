class King extends Piece
{
  public King(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles() //determines reachable tiles
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    //scans a 3*3 grid around itself
    for(int r = -1; r < 2; r++)
    {
      if(iY + r >= 8 || iY + r < 0) continue;
      for(int c = -1; c < 2; c++)
      {
        if(iX + c >= 8 || iX + c < 0 || (r == 0 && c == 0) || board[iY + r][iX + c].getTeam() == getTeam()) continue;
        tiles.add(board[iY + r][iX + c]);
      }
    }
    
    setMoveTiles(tiles);
  }
  
  Piece getCopy() { return new King(getBoardPos(), getTeam(), getImage()); }
}
