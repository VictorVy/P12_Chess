class Move
{
  private Piece taking, taken, promoPiece;
  private boolean promoMove;
  
  public Move(Piece taking, Piece taken)
  {
    setTaking(taking);
    setTaken(taken);
    setPromoMove(false);
  }
  public Move(Piece taking, Piece taken, boolean promoMove)
  {
    setTaking(taking);
    setTaken(taken);
    setPromoMove(promoMove);
  }
  
  void check() { println(getTaking().getBoardPos().x + ", " + getTaking().getBoardPos().y + " " + getTaken().getBoardPos().x + ", " + getTaken().getBoardPos().y); }
  
  //getters & setters
  void setTaking(Piece taking) { this.taking = taking; }
  Piece getTaking() { return taking; }
  
  void setTaken(Piece taken) { this.taken = taken; }
  Piece getTaken() { return taken; }
  
  void setPromoMove(boolean promoMove) { this.promoMove = promoMove; }
  boolean getPromoMove() { return promoMove; }
  
  void setPromoPiece(Piece promoPiece) { this.promoPiece = promoPiece; }
  Piece getPromoPiece() { return promoPiece; }
}
