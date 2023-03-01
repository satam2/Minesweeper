import de.bezier.guido.*;
public final static int NUM_ROWS = 8;
public final static int NUM_COLS = 8;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    
    //intialize buttons
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < buttons.length; r++)
      for(int c = 0; c < buttons[r].length; c++)
          buttons[r][c] = new MSButton(r,c);
    
    mines = new ArrayList <MSButton> ();
    setMines();
    
    for(int r = 0; r < buttons.length;r++)
      for(int c = 0; c < buttons[r].length; c++)
        if(!mines.contains(buttons[r][c]))
          buttons[r][c].setLabel(countMines(r,c));
}
public void setMines()
{
  for(int i = 0; i < NUM_ROWS/2; i ++){
    int ranRow = (int)(Math.random()*NUM_ROWS);
    int ranCol = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[ranRow][ranCol]))
      mines.add(buttons[ranRow][ranCol]);
    else
      i--;
  }
}

public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    text("you loser",200,200);
}
public void displayWinningMessage()
{
    //your code here
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1; r++)
      for(int c = col-1; c <= col+1; c++)
         if(isValid(r,c) && mines.contains(buttons[r][c]))
           numMines++;
      return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton (int row, int col)
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false)
            clicked = false;
        }
        else if (mines.contains(buttons[myRow][myCol]))
          displayLosingMessage();
       else if(countMines(myRow,myCol)>0)
         buttons[myRow][myCol].setLabel(countMines(myRow,myCol));
       else{  
           if(isValid(myRow,myCol-1) && !buttons[myRow][myCol-1].isClicked() && countMines(myRow,myCol-1) == 0)
               buttons[myRow][myCol-1].mousePressed();
               
           if(isValid(myRow,myCol+1) && !buttons[myRow][myCol+1].isClicked() && countMines(myRow,myCol+1) == 0)
               buttons[myRow][myCol+1].mousePressed();
               
           if(isValid(myRow-1,myCol) && !buttons[myRow-1][myCol].isClicked() && countMines(myRow-1,myCol) == 0)
               buttons[myRow-1][myCol].mousePressed();
        
           if(isValid(myRow+1,myCol) && !buttons[myRow+1][myCol].isClicked() && countMines(myRow+1,myCol) == 0)
               buttons[myRow+1][myCol].mousePressed();    
       }
    }
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
             fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
      
    public boolean isClicked(){
      return clicked;
    }
}
