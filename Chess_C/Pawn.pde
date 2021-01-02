class Pawn extends Piece
{
  public Pawn(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles() //determines reachable tiles
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    //scans in front of itself, taking into consideration the diagonals and the first-move double-jump
    if(getTeam() == 0) //white pawns (unnecessary here)
    {
      for(int i = -1; i < 2; i++)
      {
        if(iY - 1 < 0 || iX + i >= 8 || iX + i < 0 || board[iY - 1][iX + i].getTeam() == getTeam()) continue;
        
        if((i != 0 && board[iY - 1][iX + i].getTeam() != -1) || (i == 0 && board[iY - 1][iX + i].getTeam() == -1))
          tiles.add(board[iY - 1][iX + i]);
        if(i == 0 && iY == 6 && board[iY - 2][iX].getTeam() == -1)
          tiles.add(board[iY - 2][iX]);
      }
    }
    else //black pawns
    {
      for(int i = -1; i < 2; i++)
      {
        if(iY + 1 < 0 || iX + i >= 8 || iX + i < 0 || board[iY + 1][iX + i].getTeam() == getTeam()) continue;
        
        if((i != 0 && board[iY + 1][iX + i].getTeam() != -1) || (i == 0 && board[iY + 1][iX + i].getTeam() == -1))
          tiles.add(board[iY + 1][iX + i]);
        if(i == 0 && iY == 1 && board[iY + 2][iX].getTeam() == -1)
          tiles.add(board[iY + 2][iX]);
      }
    }
    
    setMoveTiles(tiles);
  }
  
  Piece getCopy() { return new Pawn(getBoardPos(), getTeam(), getImage()); }
}
