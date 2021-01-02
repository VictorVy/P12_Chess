class Rook extends Piece
{
  public Rook(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles() //determines reachable tiles
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    //depth-first "raycasting" outwards (horizontally/vertically)
    for(int y = iY - 1; y >= 0; y--) //top
    {
      if(board[y][iX].getTeam() == getTeam()) break;
      tiles.add(board[y][iX]);
      if(board[y][iX].getTeam() != -1) break; 
    }
    for(int y = iY + 1; y < 8; y++) //bottom
    {
      if(board[y][iX].getTeam() == getTeam()) break;
      tiles.add(board[y][iX]);
      if(board[y][iX].getTeam() != -1) break; 
    }
    for(int x = iX - 1; x >= 0; x--) //left
    {
      if(board[iY][x].getTeam() == getTeam()) break;
      tiles.add(board[iY][x]);
      if(board[iY][x].getTeam() != -1) break; 
    }
    for(int x = iX + 1; x < 8; x++) //right
    {
      if(board[iY][x].getTeam() == getTeam()) break;
      tiles.add(board[iY][x]);
      if(board[iY][x].getTeam() != -1) break; 
    }
    
    setMoveTiles(tiles);
  }
  
  Piece getCopy() { return new Rook(getBoardPos(), getTeam(), getImage()); }
}
