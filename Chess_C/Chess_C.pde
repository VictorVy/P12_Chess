//client
import processing.net.*;
import java.util.LinkedList;

Client client;

color lBrown = #FFFFC3;
color dBrown  = #D8864E;
PImage wRook, wBishop, wKnight, wQueen, wKing, wPawn;
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;
PImage screenCap;

int iRow, iCol, fRow, fCol;
int boardPosA = 5;
int boardCellSize = 100;
int boardPosB = boardPosA + boardCellSize * 8;

boolean firstClick = true;
boolean yourTurn = false;
boolean promoting = false;

ArrayList<Piece> pieces = new ArrayList();
LinkedList<Move> moveLog = new LinkedList();

Piece[][] board = new Piece[8][8];

void setup()
{
  size(810, 810);
  background(0);
  textAlign(CENTER, CENTER);

  client = new Client(this, "127.0.0.1", 1234);
  
  iRow = iCol = fRow = fCol = -1;

  loadImages();
  setupBoard();
}

void draw()
{
  drawBoard();
  drawPieces();
  
  if(promoting) promote();
  
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

void drawBoard()
{
  rectMode(CORNER);
  
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

void undo()
{
  Piece taking = moveLog.getLast().getTaking();
  Piece taken = moveLog.getLast().getTaken();
  
  if(moveLog.getLast().getPromoMove())
  {
    int team = board[(int)taken.getBoardPos().y][(int)taken.getBoardPos().x].getTeam();
    pieces.remove(board[(int)taken.getBoardPos().y][(int)taken.getBoardPos().x]);
    board[(int)taken.getBoardPos().y][(int)taken.getBoardPos().x] = new Pawn(new PVector(taken.getBoardPos().x, taken.getBoardPos().y), team, team == 0 ? wPawn : bPawn);
    pieces.add(board[(int)taken.getBoardPos().y][(int)taken.getBoardPos().x]);
  }
  
  movePiece((int)taken.getBoardPos().y, (int)taken.getBoardPos().x, (int)taking.getBoardPos().y, (int)taking.getBoardPos().x);
  if(!moveLog.getLast().getPromoMove()) board[(int)taken.getBoardPos().y][(int)taken.getBoardPos().x] = taken;
  if(taken.getTeam() != -1) pieces.add(taken);
  yourTurn = !yourTurn;
  
  moveLog.removeLast();
}

void promote()
{
  //background
  rectMode(CORNER);
  imageMode(CORNER);
  image(screenCap, 0, 0);
  noStroke();
  fill(0, 128);
  rect(0, 0, width, height);
  
  //ui
  fill(255);
  textSize(128);
  text("PROMOTE", width / 2, height / 4);
  
  choiceBox(bRook, "R", width / 5, height / 1.75);
  choiceBox(bKnight, "K", width / 5 * 2, height / 1.75);
  choiceBox(bBishop, "B", width / 5 * 3, height / 1.75);
  choiceBox(bQueen, "Q", width / 5 * 4, height / 1.75);
}

void endPromote(char type)
{
  pieces.remove(board[fRow][fCol]);
  
  switch(type)
  {
    case 'r':
      moveLog.getLast().setPromoPiece(new Rook(new PVector(fCol, fRow), 1, bRook));
      break;
    case 'k':
      moveLog.getLast().setPromoPiece(new Knight(new PVector(fCol, fRow), 1, bKnight));
      break;
    case 'b':
      moveLog.getLast().setPromoPiece(new Bishop(new PVector(fCol, fRow), 1, bBishop));
      break;
    case 'q':
      moveLog.getLast().setPromoPiece(new Queen(new PVector(fCol, fRow), 1, bQueen));
      break;
  }
  
  board[fRow][fCol] = moveLog.getLast().getPromoPiece();
  pieces.add(moveLog.getLast().getPromoPiece());
  
  client.write(iRow + "," + iCol + "," + fRow + "," + fCol + "," + type + ",promotion");
  
  promoting = false;
  firstClick = true;
  yourTurn = false;
}

void choiceBox(PImage image, String text, float x, float y)
{
  rectMode(CENTER);
  imageMode(CENTER);
  
  stroke(0);
  strokeWeight(4);
  fill(lBrown);
  
  rect(x, y, boardCellSize * 1.25, boardCellSize * 1.25);
  image(image, x, y, boardCellSize, boardCellSize);
  
  fill(255);
  textSize(64);
  
  text(text, x, y + boardCellSize);
}

void listen()
{
  if(client.available() > 0)
  {
    String incoming = client.readString();
    
    if(incoming.contains("undo"))
      undo();
    else
    {
      int iR = int(incoming.substring(0, 1));
      int iC = int(incoming.substring(2, 3));
      int fR = int(incoming.substring(4, 5));
      int fC = int(incoming.substring(6, 7));
      
      if(pieces.contains(board[fR][fC])) pieces.remove(board[fR][fC]);
      
      if(incoming.contains("promotion"))
      {
        char type = incoming.charAt(8);
        
        moveLog.addLast(new Move(board[iR][iC].getCopy(), board[fR][fC].getCopy(), true));
        
        board[fR][fC] = type == 'r' ? new Rook(new PVector(fC, fR), 0, wRook):
                        type == 'k' ? new Knight(new PVector(fC, fR), 0, wKnight):
                        type == 'b' ? new Bishop(new PVector(fC, fR), 0, wBishop):
                                      new Queen(new PVector(fC, fR), 0, wQueen);
        
        pieces.add(board[fR][fC]);
        pieces.remove(board[iR][iC]);
        board[iR][iC] = new Piece(new PVector(iC, iR));
      }
      else
      {
        moveLog.addLast(new Move(board[iR][iC].getCopy(), board[fR][fC].getCopy()));
        movePiece(iR, iC, fR, fC);
      }
      
      yourTurn = true;
    }
  }
}

void firstClick()
{
  iRow = (mouseY - boardPosA) / 100;
  iCol = (mouseX - boardPosA) / 100;
  
  if(board[iRow][iCol].getTeam() == 1)
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
  else if(board[fRow][fCol].getTeam() == 1)
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
    firstClick();
  }
  else if(board[iRow][iCol].getMoveTiles().contains(board[fRow][fCol]))
  {
    if(!(fRow == 7 && board[iRow][iCol] instanceof Pawn))
    {
      if(pieces.contains(board[fRow][fCol])) pieces.remove(board[fRow][fCol]);
      board[iRow][iCol].setSelected(false);
      moveLog.addLast(new Move(board[iRow][iCol].getCopy(), board[fRow][fCol].getCopy()));
      movePiece(iRow, iCol, fRow, fCol);
      
      client.write(iRow + "," + iCol + "," + fRow + "," + fCol);
      
      firstClick = true;
      yourTurn = false;
    }
    else
    {
      if(pieces.contains(board[fRow][fCol])) pieces.remove(board[fRow][fCol]);
      board[iRow][iCol].setSelected(false);
      moveLog.addLast(new Move(board[iRow][iCol].getCopy(), board[fRow][fCol].getCopy(), true));
      movePiece(iRow, iCol, fRow, fCol);
      
      promoting = true;
      screenCap = get();
    }
  }
  else
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
  }
}

void movePiece(int iRow, int iCol, int fRow, int fCol)
{
  board[fRow][fCol] = board[iRow][iCol];
  board[iRow][iCol] = new Piece(new PVector(iCol, iRow));
  board[fRow][fCol].move(fCol, fRow);
}
