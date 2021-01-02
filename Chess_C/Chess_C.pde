//client program

import processing.net.*;
import java.util.LinkedList;

Client client;

color lBrown = #FFFFC3;
color dBrown  = #D8864E;
PImage wRook, wBishop, wKnight, wQueen, wKing, wPawn;
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;
PImage screenCap;

int iRow, iCol, fRow, fCol;
//board is movable and resizable by changing these values
int boardPosA = 5;
int boardCellSize = 100;
int boardPosB = boardPosA + boardCellSize * 8;

boolean firstClick = true;
boolean yourTurn = false;
boolean promoting = false;

ArrayList<Piece> pieces = new ArrayList(); //list of all active pieces
LinkedList<Move> moveLog = new LinkedList(); //record of all moves

Piece[][] board = new Piece[8][8]; //matrix of Pieces representing the board

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

void loadImages() //assigns images
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

void setupBoard() //initializes the Pieces on the board
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

void drawBoard() ////draws coloured grid
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

void drawPieces() //draws active pieces
{
  for(Piece piece : pieces)
    piece.show();
}

void undo() //undoes the last move, disregarding who's turn it is
{
  Piece taking = moveLog.getLast().getTaking(); //the pieced that moved
  Piece taken = moveLog.getLast().getTaken(); //the piece or tile that was moved on
  
  if(moveLog.getLast().getPromoMove()) //handles undoing promotions
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

void promote() //draws the promotion menu
{
  //dimming background
  rectMode(CORNER);
  imageMode(CORNER);
  image(screenCap, 0, 0);
  noStroke();
  fill(0, 128);
  rect(0, 0, width, height);
  
  //drawing ui
  fill(255);
  textSize(128);
  text("PROMOTE", width / 2, height / 4);
  
  choiceBox(bRook, "R", width / 5, height / 1.75);
  choiceBox(bKnight, "K", width / 5 * 2, height / 1.75);
  choiceBox(bBishop, "B", width / 5 * 3, height / 1.75);
  choiceBox(bQueen, "Q", width / 5 * 4, height / 1.75);
}

void endPromote(char type) //promotes a pawn, and sends relevent data to server
{
  pieces.remove(board[fRow][fCol]);
  
  switch(type) //finishes logging promotion as a Move
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

void choiceBox(PImage image, String text, float x, float y) //draws an option for the player to select
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

void listen() //listens for messages from the server
{
  if(client.available() > 0)
  {
    String incoming = client.readString();
    
    if(incoming.contains("undo")) //recieves the 'undo' message
      undo();
    else //recieves move
    {
      int iR = int(incoming.substring(0, 1));
      int iC = int(incoming.substring(2, 3));
      int fR = int(incoming.substring(4, 5));
      int fC = int(incoming.substring(6, 7));
      
      if(pieces.contains(board[fR][fC])) pieces.remove(board[fR][fC]);
      
      if(incoming.contains("promotion")) //handles promotion moves
      {
        char type = incoming.charAt(8);
        
        moveLog.addLast(new Move(board[iR][iC].getCopy(), board[fR][fC].getCopy(), true)); //begins logging promotion as a Move
        
        board[fR][fC] = type == 'r' ? new Rook(new PVector(fC, fR), 0, wRook):
                        type == 'k' ? new Knight(new PVector(fC, fR), 0, wKnight):
                        type == 'b' ? new Bishop(new PVector(fC, fR), 0, wBishop):
                                      new Queen(new PVector(fC, fR), 0, wQueen);
        
        pieces.add(board[fR][fC]);
        pieces.remove(board[iR][iC]);
        board[iR][iC] = new Piece(new PVector(iC, iR));
      }
      else //handles typical moves
      {
        moveLog.addLast(new Move(board[iR][iC].getCopy(), board[fR][fC].getCopy()));
        movePiece(iR, iC, fR, fC);
      }
      
      yourTurn = true;
    }
  }
}

void firstClick() //handles the player's selection-click
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
void secondClick() //handles other clicks
{
  fRow = (mouseY - boardPosA) / 100;
  fCol = (mouseX - boardPosA) / 100;
  
  if(fRow == iRow && fCol == iCol) //deselects selected piece (clicked same piece)
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
  }
  else if(board[fRow][fCol].getTeam() == 1) //changes selected piece (clicked another piece)
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
    firstClick();
  }
  else if(board[iRow][iCol].getMoveTiles().contains(board[fRow][fCol])) //moves selected piece (clicked reachable tile)
  {
    if(!(fRow == 7 && board[iRow][iCol] instanceof Pawn)) //typical move
    {
      if(pieces.contains(board[fRow][fCol])) pieces.remove(board[fRow][fCol]);
      board[iRow][iCol].setSelected(false);
      moveLog.addLast(new Move(board[iRow][iCol].getCopy(), board[fRow][fCol].getCopy())); //logs move
      movePiece(iRow, iCol, fRow, fCol);
      
      client.write(iRow + "," + iCol + "," + fRow + "," + fCol);
      
      firstClick = true;
      yourTurn = false;
    }
    else //pawn promotion
    {
      if(pieces.contains(board[fRow][fCol])) pieces.remove(board[fRow][fCol]);
      board[iRow][iCol].setSelected(false);
      moveLog.addLast(new Move(board[iRow][iCol].getCopy(), board[fRow][fCol].getCopy(), true)); //begins logging promotion as Move
      movePiece(iRow, iCol, fRow, fCol);
      
      promoting = true;
      screenCap = get();
    }
  }
  else //deselects selected piece (clicked unreachable tile)
  {
    board[iRow][iCol].setSelected(false);
    firstClick = true;
  }
}

void movePiece(int iRow, int iCol, int fRow, int fCol) //updates the position of a piece on theboard
{
  board[fRow][fCol] = board[iRow][iCol];
  board[iRow][iCol] = new Piece(new PVector(iCol, iRow));
  board[fRow][fCol].move(fCol, fRow);
}
