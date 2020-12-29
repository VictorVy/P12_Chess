void mouseReleased()
{
  //move pieces
  if(!promoting && mouseX > boardPosA && mouseX < boardPosB && mouseY > boardPosA && mouseY < boardPosB)
  {
    if(yourTurn)
    {
      if(firstClick)
        firstClick();
      else
        secondClick();
    }
  }
}

void keyReleased()
{
  if(promoting)
  {
    switch(key)
    {
      case 'r': case 'k': case 'b': case 'q':
        endPromote(key);
        break;
    }
  }
  else
  {
    if(key == 'z' && moveLog.size() > 0)
    {
      undo();
      server.write("undo");
    }
  }
}
