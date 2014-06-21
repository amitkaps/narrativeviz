class bar2 {
  int len;
  int wid;
  int posX;
  int posY;
  int label;
  int shade;
  String name;
 
  
  // define bar constuctor
  bar2 (int tempLen, int tempWid, int tempPosX, int tempPosY, 
  			int tempLabel, int tempShade, String tempName) {
    len = tempLen;
    wid = tempWid;
    posX = tempPosX;
    posY = tempPosY;
    label = tempLabel;
    shade = tempShade;
    name = tempName;
  }

  void display() {
    fill (color_shade [shade]);
    rect (posX, posY, len, wid);
    fill (0);
    textAlign(CENTER, CENTER);
    textFont(fontA, 11);
    if (label != 0) {text(label, posX + len/2, posY + wid/2);}
    if ((mouseX > posX) && (mouseX < posX + len) &&
         (mouseY > posY) && (mouseY < posY + wid)) {
       fill (color_shade [shade]);
       rect (posX, posY, len, wid);
       fill (255);
       text(name + " " + label, posX + len/2, posY + wid/2);
     } 
  } 

}


 // define color shade - green 4, blue 4, gray 4, orange 4 and Font
color [] color_shade = {color (96,139,45), color (125,185,53),  color (175,224,110), color (218,240,168),
                      color(6,107,176), color(76,155,220), color(118,178,228), color(165,204,237),
                      color(105,105,105), color(147,147,147), color(191,191,191), color(220,220,220),
                      color(210,99,8), color(241,137,23), color(239,182,67), color(243,207,116)};
color signal_red = color (217, 13, 57);
color backgroundColor  = color (255);
PFont fontA;

// for choosing form -  Pcs, smartphones and tablets
int formX = 25;
int formY = 575;
int rectFormSizeX = 100;
int rectFormSizeY = 25;
boolean[] formChoose = {true, true , true}; // pcs is 3, smartphone is 0, tablet is 1;
boolean [] formOver= {false, false, false};
String [] formLabel = {"Smartphones", "Tablets", "PCs"};

// for choosing between Years
int yearsX = 25;
int yearsY = 525;
int rectYearsSizeX = 50;
int rectYearsSizeY = 25;
int yearsChoose = 0; // 2010 = 0, 2011 = 1, ... 2017 = 7
boolean [] yearsOver= {false, false, false, false, false, false, false, false};


// for showing the labels
int osLabelX = 700;
int osLabelY = 150;
int rectOsLabelSizeX = 50;
int rectOsLabelSizeY = 25;
boolean [] osLabelOver= {false, false, false, false, false, false, false, false, false, false, false};
int [] osLabelColor = {5,6,7,9,10,11,2,3,13,14,15,16};
String [] osLabel = new String [12];

// for the data table
int form = 3; // pcs, smp and tab
int years = 8;
int os = 12; //type of OS + total
String [] formSLabel = {"SMP", "TAB", "PCS"};

// for writing the message
int messageX, messageY;
String message;

// for writing the title
int titleX, titleY;

// for writing the year and os
int yearMessageX, yearMessageY;
int osMessageX, osMessageY;

// for the MariMekko chart dimensions
int marimekko_width;
int marimekko_height;

// for the bar in the BarChart
bar2[][][] marimekko = new bar2[form][years] [os] ;  

// variables for graphing
float scalarX = 0;
float scalarY = 0;
int startX = 25;
int startY = 450;
int sizeX = 600;
int sizeY = 350;
int tempX, tempY; 
int cumX,  cumY;

// For the Data_Bar file and the data array
String[] lines;
int indexI;
int indexJ;
int indexK;
int [][][] data;


void setup() {
  size(750, 600);
  smooth();
  background (backgroundColor);

  // Load font for Helvetica
  fontA = loadFont("Helvetica-16.vlw");
  textFont(fontA, 16);
  
  // Load the data file into array data Array
  lines = loadStrings("data_marimekko.txt");
  int formTemp = -1;
  int yearsTemp = 0;
  data = new int [form] [years] [os];
  for (indexI = 0; indexI < lines.length; indexI++) {
    String[] piece = split(lines[indexI], '\t');
    formTemp = -1;
    for (int z = 0; z < 3; z++) {
      if (piece[0].equals (formSLabel [z])) {formTemp = z;}
    }
    yearsTemp = int(piece [1]);
    if (yearsTemp > 2009) {
      for (indexJ = 2; indexJ < piece.length; indexJ++) {
          data [formTemp] [yearsTemp - 2010] [indexJ-2] = int (piece[indexJ]);
      }  
    } else {
      for (indexJ = 2; indexJ< piece.length; indexJ++) {
         osLabel [indexJ -2] = piece[indexJ]; 
      }
    }
  }
}


void draw() {
 update (mouseX , mouseY); 
 background (backgroundColor);
 
 // Assess relevant size for setting the scalarX - marimekko
  float tempMax = 0; 
  for (indexI = 0; indexI < form; indexI++) {
      if (formChoose [indexI] == true) {tempMax = data [indexI][yearsChoose][os-1] + tempMax;} 
  }
  scalarX = tempMax / sizeX; 

  // Create bars for the Bar Stacked chart 
  tempX = 0;
  tempY = 0;
  cumX = 0;
  
  for (int indexI = 0; indexI < form; indexI++) {
    tempX = int (data [indexI][yearsChoose][os - 1] / scalarX);
    cumY = 0;
    if (formChoose [indexI]) {
      for (int indexK = 0; indexK < os; indexK++) {
        tempY = data [indexI] [yearsChoose] [indexK] * sizeY / data [indexI] [yearsChoose] [os - 1];
        cumY = cumY + tempY;
        marimekko [indexI] [yearsChoose] [indexK] = new bar2(tempX, tempY, startX + cumX, 
                                                  startY - cumY, data [indexI] [yearsChoose][indexK], 
                                                  osLabelColor[indexK], osLabel[indexK]);
       }
     cumX = cumX + tempX;
    }
  }
  
 
 // Display the bars   
   for (int indexI = 0; indexI < form; indexI++) {
      for (int indexK = 0; indexK < os - 1; indexK++) {
         if (formChoose [indexI] == true ) {  
          marimekko [indexI] [yearsChoose] [indexK].display();
         }
       }
   }
 
 // Create the basic line and labels for the bar chart
  stroke (125);
  fill (0);
  tempX = 0;
  cumX = 0;
  line (startX, startY, startX + sizeX, startY);
  for (int indexI = 0; indexI < form; indexI++) {
    textAlign (CENTER, CENTER);
    textFont (fontA, 12);
    tempX = int (data [indexI][yearsChoose][os - 1] / scalarX);
    
    if(formChoose [indexI] == true) {
      text (formLabel [indexI], startX + cumX + tempX/2, startY + 12); 
      cumX = cumX + tempX;
    }
  }    
  
  // Write the initial message
  messageX = 25;
  messageY = 70; 
  fill (0);
  textAlign(LEFT);
  textFont (fontA, 11);
  text ("Installed device estimates by OS in million units by Amit Kapoor", messageX, messageY);
  
 // Write the title
  titleX = 25;
  titleY = 50; 
  fill (0);
  textAlign(LEFT);
  textFont (fontA, 24);
  text ("Growth of Android and Apple Ecosystem", titleX, titleY)

 // Write the OS message
  osMessageX = 25;
  osMessageY = 570; 
  fill (0);
  textAlign(LEFT);
  textFont (fontA, 11);
  text ("Switch the devices on or off", osMessageX, osMessageY);

 // Write the Years message
  yearMessageX = 25;
  yearMessageY = 520; 
  fill (0);
  textAlign(LEFT);
  textFont (fontA, 11);
  text ("Choose the year to see the transition", yearMessageX, yearMessageY);

  //Display the Years Choice
  for(int z = 0; z < years; z++) {
    if (yearsChoose == z ) {
      fill (color_shade[2*4 + 1]);
    } else { 
       if (yearsOver [z] == true) { 
         fill (color_shade[2*4 +2]);
       } else {
          fill (color_shade [2*4 + 3]);
        }
    } 
    stroke (255);
    rect (yearsX + z * rectYearsSizeX, yearsY, rectYearsSizeX, rectYearsSizeY);
    fill (0);
    textAlign(CENTER, CENTER);
    text (2010+z, yearsX + z * rectYearsSizeX + rectYearsSizeX/2, yearsY + rectYearsSizeY/2);
  }

  //Display the osLabel 
    for(int z = 0; z < os-1; z++) {   
      fill (color_shade[osLabelColor[z]]);
      stroke (255);
      rect (osLabelX, osLabelY + z* rectOsLabelSizeY, rectOsLabelSizeX, rectOsLabelSizeY);
      fill (0);
      textAlign(CENTER, CENTER);
      text (osLabel [z], osLabelX + rectOsLabelSizeX/2, 
            osLabelY + z * rectOsLabelSizeY + rectOsLabelSizeY/2);
    }
 
  // Display the Form Choice
  for (int z = 0; z < form; z++) {
    if (formChoose [z] == true ) {
      fill (color_shade[2*4 + 1]);
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
  
  for (int z =0; z < years; z++) {
    if(yearsOver[z]) {yearsChoose = z;}
  }  
  for (int z = 0; z < form; z++) {
    if (formOver [z]) {formChoose [z] = !formChoose [z];}
  }
  
}

void update(int x, int y) {
  
  // for years choice
  for (int count =0; count < years; count++) {
    if (overRect(yearsX + count * rectYearsSizeX, yearsY, rectYearsSizeX, rectYearsSizeY) ) {
    yearsOver [count] = true;
    } else {
      yearsOver [count] = false;
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
    
}
