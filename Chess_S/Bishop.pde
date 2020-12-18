class Bishop extends Piece
{
  public Bishop(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles()
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    boolean tr, tl, br, bl;
    tr = tl = br = bl = true;
    
    for(int i = 1; tr || tl || br || bl; i++)
    {
      if(tr && (iY - i < 0 || iX + i >= 8)) tr = false;
      if(tl && (iY - i < 0 || iX - i < 0)) tl = false;
      if(br && (iY + i >= 8 || iX + i >= 8)) br = false;
      if(bl && (iY + i >= 8 || iX - i < 0)) bl = false;
      
      if(tr)
      {
        Piece tile = board[iY - i][iX + i];
        
        if(tile.getTeam() == getTeam())
          tr = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1)
            tr = false;
        }
      }
      if(tl)
      {
        Piece tile = board[iY - i][iX - i];
        
        if(tile.getTeam() == getTeam())
          tl = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1)
            tl = false;
        }
      }
      if(br)
      {
        Piece tile = board[iY + i][iX + i];
        
        if(tile.getTeam() == getTeam())
          br = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1)
            br = false;
        }
      }
      
      if(bl)
      {
        Piece tile = board[iY + i][iX - i];
        
        if(tile.getTeam() == getTeam())
          bl = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1)
            bl = false;
        }
      }
    }
    
    setMoveTiles(tiles);
  }
  
  void highlight()
  {
    noStroke();
    fill(0, 50);
    square(getPos().x, getPos().y, boardCellSize);
  }
}
