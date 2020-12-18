//client
import processing.net.*;

Client client;

color lBrown = #FFFFC3;
color dBrown  = #D8864E;
PImage wRook, wBishop, wknight, wQueen, wKing, wPawn;
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;
boolean selected;
int iRow, iCol, fRow, fCol;


char board[][] =
{
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'},
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

void setup()
{
  size(800, 800);
  
  client = new Client(this, "127.0.0.1", 1234);

  selected = true;

  loadImages();
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
  wknight = loadImage("whiteKnight.png");
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
      
      rect(c * 100, r * 100, 100, 100);
    }
  }
}

void drawPieces()
{
  for (int r = 0; r < 8; r++)
  {
    for (int c = 0; c < 8; c++)
    {
      switch(board[r][c])
      {
        case 'r': image (wRook, c*100, r*100, 100, 100); break;
        case 'R': image (bRook, c*100, r*100, 100, 100); break;
        case 'b': image (wBishop, c*100, r*100, 100, 100); break;
        case 'B': image (bBishop, c*100, r*100, 100, 100); break;
        case 'n': image (wknight, c*100, r*100, 100, 100); break;
        case 'N': image (bKnight, c*100, r*100, 100, 100); break;
        case 'q': image (wQueen, c*100, r*100, 100, 100); break;
        case 'Q': image (bQueen, c*100, r*100, 100, 100); break;
        case 'k': image (wKing, c*100, r*100, 100, 100); break;
        case 'K': image (bKing, c*100, r*100, 100, 100); break;
        case 'p': image (wPawn, c*100, r*100, 100, 100); break;
        case 'P': image (bPawn, c*100, r*100, 100, 100); break;
      }
    }
  }
}

void listen()
{
  if(client.available() > 0)
  {
    String incoming = client.readString();
    
    int iR = int(incoming.substring(0, 1));
    int iC = int(incoming.substring(2, 3));
    int fR = int(incoming.substring(4, 5));
    int fC = int(incoming.substring(6, 7));
    
    board[fR][fC] = board[iR][iC];
    board[iR][iC] = ' ';
  }
}

void mouseReleased()
{
  if (selected)
  {
    iRow = mouseY / 100;
    iCol = mouseX / 100;
    
    if(board[iRow][iCol] != ' ')
      selected = false;
  }
  else
  {
    fRow = mouseY / 100;
    fCol = mouseX / 100;
    
    if (!(fRow == iRow && fCol == iCol))
    {
      board[fRow][fCol] = board[iRow][iCol];
      board[iRow][iCol] = ' ';
      
      client.write(iRow + "," + iCol + "," + fRow + "," + fCol);
      
      selected = true;
    }
  }
}
