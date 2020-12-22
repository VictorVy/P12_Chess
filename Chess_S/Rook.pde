class Rook extends Piece
{
  public Rook(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles()
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    //top
    for(int y = iY - 1; y >= 0; y--)
    {
      if(board[y][iX].getTeam() == getTeam()) break;
      tiles.add(board[y][iX]);
      if(board[y][iX].getTeam() != -1) break; 
    }
    //bottom
    for(int y = iY + 1; y < 8; y++)
    {
      if(board[y][iX].getTeam() == getTeam()) break;
      tiles.add(board[y][iX]);
      if(board[y][iX].getTeam() != -1) break; 
    }
    //left
    for(int x = iX - 1; x >= 0; x--)
    {
      if(board[iY][x].getTeam() == getTeam()) break;
      tiles.add(board[iY][x]);
      if(board[iY][x].getTeam() != -1) break; 
    }
    //right
    for(int x = iX + 1; x < 8; x++)
    {
      if(board[iY][x].getTeam() == getTeam()) break;
      tiles.add(board[iY][x]);
      if(board[iY][x].getTeam() != -1) break; 
    }
    
    setMoveTiles(tiles);
  }
}
