//server
import processing.net.*;

Server server;

color lBrown = #FFFFC3;
color dBrown  = #D8864E;
PImage wRook, wBishop, wKnight, wQueen, wKing, wPawn;
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;
boolean firstClick = true;
int iRow, iCol, fRow, fCol;

ArrayList<Piece> pieces = new ArrayList();

int boardPosA = 5;
int boardCellSize = 100;
int boardPosB = boardPosA + boardCellSize * 8;

Piece[][] board = new Piece[8][8];

void setup()
{
  size(810, 810);
  background(0);

  server = new Server(this, 1234);

  loadImages();
  setupBoard();
}

void draw()
{
  drawBoard();
  drawPieces();
  
  listen();
}

void loadImages()
{
  bRook = loadImage("blackRook.png");
  bBishop = loadImage("blackBishop.png");
  bKnight = loadImage("blackKnight.png");
  bQueen = loadImage("blackQueen.png");
  bKing = loadImage("blackKing.png");
  bPawn = loadImage("blackPawn.png");

  wRook = loadImage("whiteRook.png");
  wBishop = loadImage("whiteBishop.png");
  wKnight = loadImage("whiteKnight.png");
  wQueen = loadImage("whiteQueen.png");
  wKing = loadImage("whiteKing.png");
  wPawn = loadImage("whitePawn.png");
}

void drawBoard()
{
  for (int r = 0; r < 8; r++)
  {
    for (int c = 0; c < 8; c++)
    {
      noStroke();
      
      if (r % 2 == c % 2) 
        fill(lBrown);
      else
        fill(dBrown);
      
      rect(boardPosA + c * boardCellSize, boardPosA + r * boardCellSize, boardCellSize, boardCellSize);
    }
  }
}

void drawPieces()
{
  for(Piece piece : pieces)
    piece.show();
}

void setupBoard()
{
  for(int r = 0; r < 8; r++)
  {
    for(int c = 0; c < 8; c++)
    {
      switch(r)
      {
        case 0: case 7:
          switch(c)
          {
            case 0: case 7: board[r][c] = new Rook(new PVector(c, r), r == 0 ? 1 : 0, r == 0 ? bRook : wRook); break;
            case 1: case 6: board[r][c] = new Knight(new PVector(c, r), r == 0 ? 1 : 0, r == 0 ? bKnight : wKnight); break;
            case 2: case 5: board[r][c] = new Bishop(new PVector(c, r), r == 0 ? 1 : 0, r == 0 ? bBishop : wBishop); break;
            case 3: board[r][c] = new Queen(new PVector(c, r), r == 0 ? 1 : 0, r == 0 ? bQueen : wQueen); break;
            case 4: board[r][c] = new King(new PVector(c, r), r == 0 ? 1 : 0, r == 0 ? bKing : wKing); break;
          }
          pieces.add(board[r][c]);
          break;
        case 1: case 6:
          board[r][c] = new Pawn(new PVector(c, r), r == 1 ? 1 : 0, r == 1 ? bPawn : wPawn);
          pieces.add(board[r][c]);
          break;
        default:
          board[r][c] = new Piece(new PVector(c, r));
      }
    }
  }
}

void listen()
{
  //Client client = server.available();
  
  //if(client != null)
  //{
  //  String incoming = client.readString();
    
  //  int iR = int(incoming.substring(0, 1));
  //  int iC = int(incoming.substring(2, 3));
  //  int fR = int(incoming.substring(4, 5));
  //  int fC = int(incoming.substring(6, 7));
    
  //  board[fR][fC] = board[iR][iC];
  //  board[iR][iC] = ' ';
  //}
}

void firstClick()
{
  iRow = (mouseY - boardPosA) / 100;
  iCol = (mouseX - boardPosA) / 100;
  
  if(board[iRow][iCol].getTeam() == 0)
  {
    board[iRow][iCol].setSelected(true);
    board[iRow][iCol].getTiles();
    firstClick = false;
  }
}
void secondClick()
{
  fRow = (mouseY - boardPosA) / 100;
  fCol = (mouseX - boardPosA) / 100;
  
  if((fRow == iRow && fCol == iCol))
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
  }
  else if(board[fRow][fCol].getTeam() == 0)
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
    firstClick();
  }
  else if(board[iRow][iCol].getMoveTiles().contains(board[fRow][fCol]))
  {
    board[fRow][fCol] = board[iRow][iCol];
    board[iRow][iCol] = new Piece(new PVector(iCol, iRow));
    board[fRow][fCol].move(fCol, fRow);
    board[fRow][fCol].setSelected(false);
    
    server.write(iRow + "," + iCol + "," + fRow + "," + fCol);
    
    firstClick = true;
  }
  else
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
  }
}

void mouseReleased()
{
  //move pieces
  if(mouseX > boardPosA && mouseX < boardPosB && mouseY > boardPosA && mouseY < boardPosB)
  {
    if(firstClick)
      firstClick();
    else
      secondClick();
  }
}
