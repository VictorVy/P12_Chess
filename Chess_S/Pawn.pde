class Pawn extends Piece
{
  public Pawn(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles()
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    if(getTeam() == 0)
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
    else
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
}
