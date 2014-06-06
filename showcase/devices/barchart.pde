class bar {
  int len;
  int wid;
  int posX;
  int posY;
  int label;
  int shade;
 
  
  // define bar constuctor
  bar (int tempLen, int tempWid, int tempPosX, 
       int tempPosY, int tempLabel, int tempShade) {
    len = tempLen;
    wid = tempWid;
    posX = tempPosX;
    posY = tempPosY;
    label = tempLabel;
    shade = tempShade;
  }

  void display() {
    fill (color_shade [shade + colorChoose]);
    rect (posX, posY, len, wid);
    fill (0);
    textAlign(CENTER, CENTER);
    textFont(fontA, 11);
    text(label, posX + len/2, posY + wid/2);
    if ((mouseX > posX) && (mouseX < posX + len) &&
         (mouseY > posY) && (mouseY < posY + wid)) {
       fill (color_shade [colorChoose]);
       rect (posX, posY, len, wid);
       fill (255);
       text(label, posX + len/2, posY + wid/2);
     } 
  } 

}


// define color shade - green 4, blue 4, gray 4, orange 4 and Font
color [] color_shade = {color (96,139,45), color (125,185,53), color(175,224,110), 
          color (218,240,168), 
          color(6,107,176), color(76,155,220), color(118,178,228), color(165,204,237), 
          color(105,105,105), color(147,147,147), color(191,191,191), color(220,220,220),
          color(210,99,8), color(241,137,23), color(239,182,67), color(243,207,116)};
color signal_red = color (217, 13, 57);
color backgroundColor  = color (255);
PFont fontA;

// for choosing between graph type - stacked and cluster
int typeX = 25;
int typeY = 0;
int rectTypeSizeX = 100;
int rectTypeSizeY = 25;
int typeChoose; // stacked = 0, cluster = 1
boolean [] typeOver= {false, false};
String [] typeLabel = {"Stacked", "Dodged"};

// for choosing form -  Pcs, smartphones and tablets
int formX = 25;
int formY = 575;
int rectFormSizeX = 100;
int rectFormSizeY = 25;
boolean[] formChoose = {true, true , true}; // pcs is 0, smartphone is 1, tablet is 2;
boolean [] formOver= {false, false, false};
String [] formLabel = {"PCs", "Smartphones", "Tablets"};

// for choosing between color
int colorX = 525;
int colorY = 0;
int rectColorSizeX = 50;
int rectColorSizeY = 25;
int colorChoose; // green = 0, blue = 4, gray = 8, orange = 12
boolean [] colorOver= {false, false, false, false};

// for the table
int rows = 8;
int columns = 5;
int margin = 6;

// for writing the message
int messageX, messageY;
String message;


// for the bar chart dimensions
int bar_stacked_width = 60;
int bar_stacked_gap = 20;
int bar_cluster_width = bar_stacked_width /3;
int bar_cluster_gap = bar_stacked_gap;
int bar_cluster_nos = 3;
int bar_cluster_count;
int total_stacked_length = (bar_stacked_width + bar_stacked_gap) * rows + bar_stacked_gap;
int total_cluster_length = (bar_cluster_width * 3 + bar_cluster_gap) * rows + bar_cluster_gap;

// for the bar in the BarChart
bar[][] bar_stacked = new bar[rows] [columns] ;  
bar[][] bar_cluster = new bar[rows] [columns] ; 

// variables for graphing
float scalar_stacked = 0;
float scalar_cluster = 0;
int startX = 25;
int startY = 450;
int tempX, tempY; 
int cumX,  cumY;

// For the Data_Bar file and the data array
String[] lines;
int indexI;
int indexJ;
int [][] data;


void setup() {
  size(750, 600);
  smooth();
  background (backgroundColor);

  // Load font for Helvetica
  fontA = loadFont("Helvetica-16.vlw");
  textFont(fontA, 16);
  
  // Load the data file into array data Array
  lines = loadStrings("data_barchart.txt");
  data = new int [rows] [columns];
  for (indexI = 0; indexI < lines.length; indexI++) {
    String[] piece = split(lines[indexI], '\t');
    for (indexJ = 0; indexJ < piece.length; indexJ++) {
      data [indexI] [indexJ] = int (piece[indexJ]);
    } 
  }

}

void draw() {
 update (mouseX , mouseY); 
 background (backgroundColor);
 
 // Assess max size for setting the scalar - Bar Stacked
  float tempMax = 0; 
  float totalMax = 0;
  for (indexI = 0; indexI < rows; indexI++) {
    tempMax = 0; 
    for (indexJ = 1; indexJ < columns - 1; indexJ++) {
      if (formChoose [indexJ - 1] == true ) {   
      tempMax = data [indexI] [indexJ] + tempMax; 
      }
    }
    if (totalMax < tempMax) { 
      totalMax = tempMax;
    }  
  }
  scalar_stacked = tempMax / 350; 

  // Assess max size for setting the scalar - Bar Cluster
  tempMax = 0; 
  for (indexI = 0; indexI < rows; indexI++) {
    for (indexJ = 1; indexJ < columns - 1; indexJ++) {
      if (tempMax < data[indexI][indexJ]) { 
        if (formChoose [indexJ - 1] == true ) {  
        tempMax = data [indexI][indexJ];
        }
      }  
    }
  }
  scalar_cluster = tempMax / 350; 
  
  // Calculate the number of column and the width of the cluster
  int adjust = 0;
  for (int z = 0; z < 3; z++) {
    if (formChoose [z] == true) {adjust++;}
  }
  if (adjust == 0) {
    bar_cluster_width = bar_stacked_width / 3 ;
    bar_cluster_nos = 3;
  } else {
    bar_cluster_width = bar_stacked_width / adjust ;
    bar_cluster_nos = adjust;
  }
  
  // Create bars for the Bar Stacked chart 
  tempX = 0;
  tempY = 0;
  for (int indexI = 0; indexI < rows; indexI++) {
    cumY = 0;
    for (int indexJ = 1; indexJ < columns - 1; indexJ++) {
      tempY = int (data[indexI][indexJ] / scalar_stacked);
      if (formChoose [indexJ -1] == true) {cumY = cumY + tempY;}
      bar_stacked [indexI] [indexJ] = new bar(bar_stacked_width, tempY,
      startX + bar_stacked_width * (indexI) + bar_stacked_gap * (indexI + 1), startY - cumY,
      data [indexI] [indexJ], indexJ);
    }
  }
  
  // Create bars for the Bar Cluster chart 
  for (int indexI = 0; indexI < rows; indexI++) {
    bar_cluster_count = 0;
    for (int indexJ = 1; indexJ < columns -1; indexJ++) {
      tempY = int (data[indexI][indexJ] / scalar_cluster);
      if (formChoose [indexJ -1] == true) {bar_cluster_count++;}
      bar_cluster [indexI] [indexJ] = new bar(bar_cluster_width, tempY,
      startX + bar_cluster_width * (indexI * bar_cluster_nos + bar_cluster_count -1) + bar_cluster_gap * (indexI + 1),
      startY - tempY, data [indexI] [indexJ], indexJ);
    }
  }
 
 
 // Display the bars
 if (typeChoose == 0) {
   
   for (int indexI = 0; indexI < rows; indexI++) {
      for (int indexJ = 1; indexJ < columns - 1; indexJ++) {
         if (formChoose [indexJ - 1] == true ) {  
          bar_stacked [indexI] [indexJ].display();
         }
       }
   }
   
 } else {
    
   for (int indexI = 0; indexI < rows; indexI++) {
      for (int indexJ = 1; indexJ < columns - 1; indexJ++) {
        if (formChoose [indexJ - 1] == true ) {
          bar_cluster [indexI] [indexJ].display();
        }
      }   
    }
 
 }
 
 // Create the basic line and labels for the bar chart
  stroke (125);
  fill (0);
  line (startX, startY, startX + total_stacked_length, startY);
  for (int indexI = 0; indexI < rows; indexI++) {
    textAlign (CENTER, CENTER);
    textFont (fontA, 12);
    text (data[indexI][0], startX + bar_stacked_width /2 + bar_stacked_width * (indexI)
            + bar_stacked_gap * (indexI + 1), startY + 20); 
  }
  
  // Write the initial message
  messageX = 725;
  messageY = height - 12; 
  fill (0);
  textAlign(RIGHT);
  textFont (fontA, 11);
  text ("Installed Device Estimate in Mln Units by Amit Kapoor", messageX, messageY);
  
  //Display the Graph Choice
  for(int z = 0; z < 2; z++) {
    if (typeChoose == z ) {
      fill (color_shade[2*4 + 1]);
    } else { 
       if (typeOver [z] == true) { 
         fill (color_shade[2*4 +2]);
       } else {
          fill (color_shade [2*4 + 3]);
        }
    } 
  stroke (255);
  rect (typeX + z * rectTypeSizeX, typeY, rectTypeSizeX, rectTypeSizeY);
  fill (0);
  textAlign(CENTER, CENTER);
  text (typeLabel[z], typeX + z * rectTypeSizeX + rectTypeSizeX/2, typeY + rectTypeSizeY/2);
  }
  
  // Display the Color Choice
  for (int z = 0; z < 4; z++) {
    if (colorChoose == z *4) {
        fill (color_shade[z*4 +1]);
    } else { 
      if (colorOver [z] == true) {
        fill (color_shade[z*4 +2]);
      } else {
        fill (color_shade [z*4 + 3]);
      }
    }
    stroke (255);
    rect(colorX + z * rectColorSizeX, colorY, rectColorSizeX, rectColorSizeY);
  }
 
  // Display the Form Choice
  for (int z = 0; z < 3; z++) {
    if (formChoose [z] == true ) {
      fill (color_shade[colorChoose + z]);
    } else { 
          fill (color_shade [2*4 + 3]);
     }
    stroke (255);
    rect(formX + z * rectFormSizeX, formY, rectFormSizeX, rectFormSizeY);
    fill (0);
    textAlign(CENTER, CENTER);
    text (formLabel[z], formX + z * rectFormSizeX + rectFormSizeX /2, formY +rectFormSizeY/2);
  } 
}


boolean overRect(int x, int y, int w, int h) {
  if (mouseX >= x && mouseX <= x + w && 
      mouseY >= y && mouseY <= y + h) {
    return true;
  } else {
    return false;
  }
}

void mousePressed(){
  
  for (int z =0; z < 2; z++) {
    if(typeOver[z]) {typeChoose = z;}
  }  
  for (int z = 0; z < 3; z++) {
    if (formOver [z]) {formChoose [z] = !formChoose [z];}
  }
  for (int z = 0; z < 4; z++) {
    if(colorOver[z]) {colorChoose = z * 4;}
  }
  
}

void update(int x, int y) {
  
  // for type choice
  for (int count =0; count < 2; count++) {
    if (overRect(typeX + count * rectTypeSizeX, typeY, rectTypeSizeX, rectTypeSizeY) ) {
    typeOver [count] = true;
    } else {
      typeOver [count] = false;
    }  
  }  
  
  // for form choice
  for (int count = 0; count < 3; count++) {
    if (overRect(formX + count * rectFormSizeX, formY, rectFormSizeX, rectFormSizeY)){
      formOver [count] = true;
    } else { 
      formOver [count] = false;
    }   
  }
  
  // for color choice
  for (int count = 0; count < 4; count++) {
    if (overRect(colorX + count * rectColorSizeX, colorY, rectColorSizeX, rectColorSizeY)){
      colorOver [count] = true;
    } else { 
      colorOver [count] = false;
    }   
  }
  
  
}