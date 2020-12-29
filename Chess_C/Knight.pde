class Knight extends Piece
{
  public Knight(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles()
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    for(int r = -2; r < 3; r++)
    {
      if(iY + r >= 8 || iY + r < 0 || r == 0) continue;
      for(int c = -2; c < 3; c++)
      {
        if(iX + c >= 8 || iX + c < 0 || c == 0 || board[iY + r][iX + c].getTeam() == getTeam()) continue;
        
        if((Math.abs(r) == 2 && Math.abs(c) == 1) || (Math.abs(r) == 1 && Math.abs(c) == 2))
          tiles.add(board[iY + r][iX + c]);
      }
    }
    
    setMoveTiles(tiles);
  }
  
  Piece getCopy() { return new Knight(getBoardPos(), getTeam(), getImage()); }
}
