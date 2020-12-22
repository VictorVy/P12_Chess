class Queen extends Piece
{
  public Queen(PVector boardPos, int team, PImage image)
  {
    super(boardPos, team, image);
  }
  
  void getTiles()
  {
    ArrayList<Piece> tiles = new ArrayList();
    
    int iX = (int)getBoardPos().x;
    int iY = (int)getBoardPos().y;
    
    boolean t, r, l, b, tr, tl, br, bl;
    t = r = l = b = tr = tl = br = bl = true;
    
    for(int i = 1; t || r || l || b || tr || tl || br || bl; i++)
    {
      if(t && iY - i < 0) t = false;
      if(r && iX + i >= 8) r = false;
      if(l && iX - i < 0) l = false;
      if(b && iY + i >= 8) b = false;
      if(tr && (iY - i < 0 || iX + i >= 8)) tr = false;
      if(tl && (iY - i < 0 || iX - i < 0)) tl = false;
      if(br && (iY + i >= 8 || iX + i >= 8)) br = false;
      if(bl && (iY + i >= 8 || iX - i < 0)) bl = false;
      
      if(t)
      {
        Piece tile = board[iY - i][iX];
        if(tile.getTeam() == getTeam()) t = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1) t = false;
        }
      }
      if(r)
      {
        Piece tile = board[iY][iX + i];
        if(tile.getTeam() == getTeam()) r = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1) r = false;
        }
      }
      if(l)
      {
        Piece tile = board[iY][iX - i];
        if(tile.getTeam() == getTeam()) l = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1) l = false;
        }
      }
      if(b)
      {
        Piece tile = board[iY + i][iX];
        if(tile.getTeam() == getTeam()) b = false;
        else
        {
          tiles.add(tile);
          if(tile.getTeam() != -1) b = false;
        }
      }
      
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
}
