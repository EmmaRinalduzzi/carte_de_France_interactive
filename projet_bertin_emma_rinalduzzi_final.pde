/* Créer une carte de France interractive où:
- le deplacement de la souris nous indique la desité de la population 
via la grosseur du point
- on montre les "clichés" que l'on peut retrouver en France 
(bcp de monde à Paris, de la pluie en Bretagne, du Soleil dans le sud...) 
grâce à des evenements qui se déclenchent au passage de la souris sur cez zones.
- le nom des grandes villes apparait lorsque l'on clique sur la souris
*/


PImage image;
PImage france;
PImage fondcarte;
PImage region;
PImage perso;
PFont karrik;
float posX = 300;
float posY = 500;
int epaisseur = 0;
int fond = 255;
float currentStrokeWeight = 0;
boolean texteVisible = false;
boolean isMouseOnPerimeter = false;

color c;
color d;
color e;
color brest;
color brestft;
color paris;
color sud;
color lyon;
color petiteville;
color villemoyenne;
color grandeville;
color personne;
ArrayList<EllipseCustomEmma> ellipses;
ArrayList<Raindrop> raindrops;
ArrayList<ExpandingCircle> expandingCircles;
ArrayList<Particle> particles;
float lastCircleTime = 0;
float circleInterval = 550; // Intervalle de temps en millisecondes (1 seconde)
float circleRadius;

// ecran d'introduction
boolean montrerIntro = true;
int finIntro;
int dureeIntro = 6 * 1000; // 6 secondes

void setup() {
  size(800, 800);
  //on appelle les differentes classes en les créant des listes
  ellipses = new ArrayList<EllipseCustomEmma>(); 
  raindrops = new ArrayList<Raindrop>();
  expandingCircles = new ArrayList<ExpandingCircle>();
  particles = new ArrayList<Particle>();
  


  // Chargement des images
  image = loadImage("noir_blanc_contour.png");
  france = loadImage("francecouleur2.png");
  fondcarte = loadImage("noir_blanc.png");
  region = loadImage("regions.png");
  perso = loadImage("bonhomme.png");

  // Chargement de la police de caractères
  karrik = createFont("Karrik-Regular.otf", 32);
  textFont(karrik);

  // Définition des couleurs qui permettront les événements au passage de la souris
  brest = color(255, 0, 255);
  brestft = color(132, 0, 190);
  sud = color(255, 130, 0);
  paris = color(0, 0, 255);
  lyon = color(255,77,0);
  grandeville = color(255, 255, 0);
  villemoyenne = color(0, 255, 255);
  petiteville = color(0, 255, 0);
  personne = color(255, 0, 0);

  noCursor(); 
  
  // Définir le moment de fin de l'introduction
  finIntro = millis() + dureeIntro;
}

void draw() {
  if (montrerIntro) {
    // Afficher l'écran d'introduction
    background(0); // Fond blanc
    fill(255); // Couleur du texte noir
    textSize(54);
    textAlign(CENTER, CENTER);
    text("Une balade en France", width / 2, height / 2);
    textSize(16);
    fill(255,0,255);
    text("bougez la souris sur la France et laissez vous emporter par sa richesse", width / 2, (height / 2+ 40));
    fill(255,0,255);
    //text("Cliquez pour faire apparaitre les villes", width / 2 , (height / 2+ 65));

    // Vérifier si la durée de l'introduction est écoulée
    if (millis() > finIntro) {
      montrerIntro = false;
    }
  } else {
    
  background(0);
  noCursor();
  posX = mouseX;
  posY = mouseY; //on associe posX et posY au deplacement de la souris

  imageMode(CENTER); 
  image(image, width/2, height/2); // on fait apparaitre le contour de la carte de France

  // Récupération de la couleur sous la souris pour la carte nommée france
  c = france.get(int(posX), int(posY));
  circle(70, 600, 5); // rond de la légende
  fill(255);
  noStroke();

  // Gérer les actions en fonction de la couleur de la zone sous la souris
  if (color(c) == paris) {
    // Afficher les perso
    image(perso, 125, 600);
    image(perso, 145, 600);
    image(perso, 165, 600);
    image(perso, 185, 600);
    image(perso, 205, 600);
    
    // Gérer l'épaisseur du trait en douceur (transition d'une epaisseur d'un point à une autre)
    float targetWeight = epaisseur + 260;
    float smoothingFactor = 9.99;
    
    if (currentStrokeWeight < targetWeight) {
      currentStrokeWeight = min(currentStrokeWeight + smoothingFactor, targetWeight);
    } else if (currentStrokeWeight > targetWeight) {
      currentStrokeWeight = max(currentStrokeWeight - smoothingFactor, targetWeight);
    }
    
    stroke(255);
    strokeWeight(currentStrokeWeight);
    point(posX, posY);
    
    // Créer des ellipses avec une liste de couleurs
    //color[] couleur = {#F0C20C, #FA5001, #E000CA, #2026F7, #53EDE1};
    //color ellipseColor = couleur[int(random(couleur.length))];
    
    // couleur(et opacité), taille et durée des objets de la classe ellipsecustomEmma
    color ellipseColor = color(255, random(30,150));
    float ellipseSize = random(40, 250);
    float duration = random(1, 5);
    // faire apparaitre des ellipses de la classe si l'épaisseur du point est de 260)
    if (currentStrokeWeight == 260) {
      stroke(250, 50);
      EllipseCustomEmma newEllipse = new EllipseCustomEmma(mouseX, mouseY, ellipseSize, ellipseColor, duration);
      ellipses.add(newEllipse); //génération des ellipses via la classe
    }
  }
  // Mettre à jour et afficher les ellipses
  for (int i = 0; i < ellipses.size(); i++) {
    EllipseCustomEmma e = ellipses.get(i); //lancement de la classe ellipsecustomemma et de ses methodes update et display
    e.update();
    e.display();

    if (e.finished() == true) {
      ellipses.remove(i);
    }
  }

  // Récupération de la couleur de la région sous la souris
  e = region.get(int(posX), int(posY));

  // Gérer les actions en fonction de la couleur de la région sous la souris
  if (color(e) == brest) {
      //on associe des caracteristiques de position aux gouttes de pluie
    float x = random(width);
    float y = random(height);
    float duration = random(2000);
    Raindrop raindrop = new Raindrop(x, y, duration); 
    
    raindrops.add(raindrop); //génération des gouttes via la classe
  }
    

  // Afficher des gouttes de pluie
    for (int i = 0;i < raindrops.size(); i++) { //lancement de la classe raindrop et de ses methodes fall et display
      Raindrop raindrop = raindrops.get(i);
      raindrop.fall();
      raindrop.display();
    if (raindrop.isitreallyFinished() == true) {
      raindrops.remove(i);
    }
}
    

  // Gérer les actions en fonction de la couleur de la région "sud" couleur sous la souris (ExpandingCircles)
 if (color(e) == sud) {
      if (millis() - lastCircleTime >= circleInterval) { //interval entre chaque cercle
        float x = mouseX;
        float y = mouseY;
     
        float duration = 9000;//temps de vie
        ExpandingCircle circle = new ExpandingCircle(x, y, duration);//génération de 1 cercle via la classe
        expandingCircles.add(circle); //ajout au tableau de cercles
        lastCircleTime = millis();
      }
     
     
    }
    else {
       for (int i = 0;i < expandingCircles.size(); i++) { 
        if (region.get(int(expandingCircles.get(i).x), int(expandingCircles.get(i).y)) != sud){
          expandingCircles.remove(i);
           print("boucle + "+ i );  
        }
        
       
      }
    
  
    
       //circleInterval = random(500,1000);
         
 }
   for (int i = 0;i < expandingCircles.size(); i++) { 
      ExpandingCircle circle = expandingCircles.get(i); //lancement de la classe expandingcircle et de ses methodes grow et display
      circle.grow();
      circle.display();
      if (circle.isitFinished() == true) {
        expandingCircles.remove(i);
        }
      if (circle.maxTransparency <= 0) { //si la transparence est de 0, faire disparaitre le cercle en question
        expandingCircles.remove(i);
        }
   }
       /* if (circle.maxTransparency < 0) { //si la transaprence est de 0, faire disparaitre le cercle en question
        expandingCircles.remove(i);
        }
    if (millis() - lastCircleTime >= circleInterval) { //verifie le temps passé depuis la création du dernier cercle
      ExpandingCircle newCircle = new ExpandingCircle(mouseX, mouseY,2000); //fait apparaitre un nouveau cercle 
      expandingCircles.add(newCircle); //ajoute le nouveau cercle à la liste
      lastCircleTime = millis(); // met à jour le temps du dernier cercle créé
    }
   */

    
    
    
 
  
      
    /*  if (circle.maxTransparency < 0) { //si la transaprence est de 0, faire disparaitre le cercle en question
        expandingCircles.remove(i);
      }
    }
    //circleInterval = random(500,1000);
    if (millis() - lastCircleTime >= circleInterval) { //verifie le temps passé depuis la création du dernier cercle
      ExpandingCircle newCircle = new ExpandingCircle(mouseX, mouseY,1000); //fait apparaitre un nouveau cercle 
      expandingCircles.add(newCircle); //ajoute le nouveau cercle à la liste
      lastCircleTime = millis(); // met à jour le temps du dernier cercle créé
    }*/
     
    
  
 if (color(e) == lyon) {
   // calcule le centre du cercle autour de la souris
  float centerX = mouseX;
  float centerY = mouseY;

  // creation de particule autour du perimetre du cercle
  if (frameCount % 4 == 0) {  // creation de particules selon un temps
    circleRadius = 50; // perimetre d'un cercle grand
    float angle = random(TWO_PI);  // Random angle
    float x = centerX + cos(angle) * circleRadius;
    float y = centerY + sin(angle) * circleRadius;
    float particleRadius = random(5, 20);
    color particleColor = color(255, random(30,130));   // particules blanches +ou- transparentes
    float duration = 2000;
    particles.add(new Particle(x, y, particleRadius, particleColor, duration));
  }
  
  if (frameCount % 4 == 0) {  // creation de particules selon un temps
    circleRadius = 70; // perimetre d'un cercle + grand
    float angle = random(TWO_PI);  // Random angle
    float x = centerX + cos(angle) * circleRadius;
    float y = centerY + sin(angle) * circleRadius;
    float particleRadius = random(5, 20);
    color particleColor = color(255, random(0,70));  // particules blanches + transparentes
    float particleDuration = 2000;  // Durée en millisecondes (2 secondes)
    particles.add(new Particle(x, y, particleRadius, particleColor, particleDuration));
  }
  
   if (frameCount % 4 == 0) {  // creation de particules selon un temps
    circleRadius = 90; // perimetre d'un cercle ++ grand
    float angle = random(TWO_PI);  // Random angle
    float x = centerX + cos(angle) * circleRadius;
    float y = centerY + sin(angle) * circleRadius;
    float particleRadius = random(5, 20);
    color particleColor = color(255, random(0,40));  // particules blanches ++ transparentes
    float particleDuration = 2000;  // Durée en millisecondes (2 secondes)
    particles.add(new Particle(x, y, particleRadius, particleColor, particleDuration));
  }

 }
// faits apparaitre et disparaitre les particules
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    particle.display();

    if (particle.isFinished()== true) {
      particles.remove(i); 
    }
  }
  // Gérer les actions en fonction de la couleur de la région "grandeville" sous la souris
  if (color(c) == grandeville) {
    //apparition des persos
    image(perso, 125, 600);
    image(perso, 145, 600);
    image(perso, 165, 600);
    image(perso, 185, 600);
    
    // Gérer l'épaisseur du trait en douceur (transition d'une epaisseur d'un point à une autre)
    float targetWeight = epaisseur + 80;
    float smoothingFactor = 2.99;
    
    if (currentStrokeWeight < targetWeight) {
      currentStrokeWeight = min(currentStrokeWeight + smoothingFactor, targetWeight);
    } else if (currentStrokeWeight > targetWeight) {
      currentStrokeWeight = max(currentStrokeWeight - smoothingFactor, targetWeight);
    }
    
    stroke(255);
    strokeWeight(currentStrokeWeight);
    point(posX, posY);
  
  
  }
 

  // Gérer les actions en fonction de la couleur de la région "villemoyenne" sous la souris
  if (color(c) == villemoyenne) {
    //apparition des persos
    image(perso, 125, 600);
    image(perso, 145, 600);
    image(perso, 165, 600);
    textSize(15);
    fill(255);
    
    // Gérer l'épaisseur du trait en douceur (transition d'une epaisseur d'un point à une autre)
    float targetWeight = epaisseur + 50;
    float smoothingFactor = 2.99;
    
    if (currentStrokeWeight < targetWeight) {
      currentStrokeWeight = min(currentStrokeWeight + smoothingFactor, targetWeight);
    } else if (currentStrokeWeight > targetWeight) {
      currentStrokeWeight = max(currentStrokeWeight - smoothingFactor, targetWeight);
    }
    stroke(#FA5001);
    strokeWeight(currentStrokeWeight);
    point(posX, posY);
  }

  // Gérer les actions en fonction de la couleur de la région "petiteville" sous la souris
  if (color(c) == petiteville) {
    //apparition des persos
    image(perso, 125, 600);
    image(perso, 145, 600);
    textSize(15);
    fill(255);
    
    // Gérer l'épaisseur du trait en douceur (transition d'une epaisseur d'un point à une autre)
    float targetWeight = epaisseur + 30;
    float smoothingFactor = 2.99;
    
    if (currentStrokeWeight < targetWeight) {
      currentStrokeWeight = min(currentStrokeWeight + smoothingFactor, targetWeight);
    } else if (currentStrokeWeight > targetWeight) {
      currentStrokeWeight = max(currentStrokeWeight - smoothingFactor, targetWeight);
    }
    stroke(#E000CA);
    strokeWeight(currentStrokeWeight);
    point(posX, posY);
  }

  // Gérer les actions en fonction de la couleur de la région "personne" sous la souris
  if (color(c) == personne) {
    //faire apparaitre le perso
    image(perso, 125, 600);
   
    // Gérer l'épaisseur du trait en douceur (transition d'une epaisseur d'un point à une autre)
    float targetWeight = epaisseur + 10;
    float smoothingFactor = 2.99;
    
    if (currentStrokeWeight < targetWeight) {
      currentStrokeWeight = min(currentStrokeWeight + smoothingFactor, targetWeight);
    } else if (currentStrokeWeight > targetWeight) {
      currentStrokeWeight = max(currentStrokeWeight - smoothingFactor, targetWeight);
    }
    stroke(#53EDE1);
    strokeWeight(currentStrokeWeight);
    point(posX, posY);
  }

  
// place les villes sur l'écran
  
    fill(0);
    textSize(20);
    text("Lyon", 598, 490);
    text("Marseille", 620, 690);
    text("Toulouse", 386, 685);
    text("Lille", 441, 52);
    text("Rennes", 269, 326);
    text("Bordeaux", 265, 558);
    text("Strasbourg", 680, 221);
    text("Paris", 450, 221);
    text("Brest", 34, 225);
    text("Nice", 752, 649);
  
  println(posX + "/" + posY + "/");
}
}


/*void mouseClicked() {
  texteVisible = !texteVisible; // fait apparaitre et disparaitre le texte en cliquant 
 }
*/
 
// création d'une classe qui génére des ellipses qui partent dans tous les sens et diminuent en opacité jusqu'à disparaitre
class EllipseCustomEmma {
  float x, y;  // Position
  float startSize;  // Taille initiale
  color col;   // Couleur
  float startTime;  // Heure de création de l'ellipse
  float duration;   // Durée en secondes
  float deltaX, deltaY;  // Directions de mouvement

  EllipseCustomEmma(float x, float y, float size, color col, float duration) {
    this.x = x;
    this.y = y;
    this.startSize = size;
    this.col = col;
    this.startTime = millis() / 1000.0;
    this.duration = duration;
    deltaX = random(-4, 4);
    deltaY = random(-4, 4);
  }

  void update() {
    x += deltaX; //x prends la valeur de deltax (random)
    y += deltaY; // idem pour y
    d = fondcarte.get(int(x), int(y));
    // rebondit contre le fond de carte grace au pixelget qui recupere la valeur de luminosté du pixel sous lequel est l'ellipse
    if (brightness(d) < 128) {
      deltaX *= -1; // inverse
      deltaY *= -1; 
    }
  }
  //taille et opacité qui diminue en fonction du temps dans la methode dsiplay(affiche l'eelipse)
  void display() {
    float currentTime = millis() / 1000.0;
    float elapsedTime = currentTime - startTime;

    float newSize = startSize * (1 - min(1, elapsedTime / duration));
    float radiusX = newSize / 2;
    float radiusY = newSize / 2;

    if (elapsedTime < 1.0) { // au debut, l'ellipse est blanche
      fill(255, 50);
    } else { // ensuite, elle diminue en opacité progressivement 
      fill(lerpColor(col, color(255, 0), (elapsedTime - 1.0) / (duration - 1.0)));
    }

    noStroke();
    ellipse(x, y, radiusX * 2, radiusY * 2); 
  }

  boolean finished() { // l'ellipse a fini son cycle ? renvoie true or false selon la durée
    float currentTime = millis() / 1000.0;
    return (currentTime - startTime) > duration;
  }
}


// création d'une classe qui génére des gouttes de pluie
class Raindrop {
  float x, y;    // Position
  float speed;   // Vitesse de chute
  float length;  // Longueur de la goutte de pluie
  int alpha;     // Transparence
  float startTime;
  float duration;

  Raindrop(float x, float y, float duration) {
    this.x = x;
    this.y = y;
    this.speed = random(5, 15);  // Vitesse de chute aléatoire
    this.length = random(10, 50);  // Longueur de la goutte de pluie aléatoire
    this.alpha = 255;  // Valeur alpha initiale
    this.startTime = millis();
    this.duration = duration;
  }

  void fall() {
    y += speed;  // Déplace la goutte de pluie vers le bas en fonction de la vitesse

    // Réinitialise la position de la goutte de pluie si elle sort de l'écran
    if (y > height) {
      y = random(-100, -10);
      x = random(width);
      alpha = 255;  // Réinitialiser l'alpha lorsque la goutte de pluie réapparaît
    }
  }

  void display() {
    float currentTime = millis() / 1000.0;
    float elapsedTime = currentTime - startTime;
    stroke(255, alpha);  // Couleur de la goutte de pluie avec alpha(transparence)
    strokeWeight(4); //epaisseur
    line(x, y, x, y + length);  // Dessiner la goutte de pluie
    alpha -= 2;  // Réduire l'alpha progressivement
    alpha = constrain(alpha, 0, 255);  // S'assurer que l'alpha reste dans une plage valide
  }
  boolean isitreallyFinished() {
      float currentTime = millis();  // Temps actuel en millisecondes
      return (currentTime - startTime) > duration;  // Renvoie vrai si la particule a dépassé sa durée de vie
    }
}


// création d'une classe qui génére des cercles qui grossissent et s'attenuent avec le temps
class ExpandingCircle {
  float x, y;            // Position
  float diameter;        // Diameter of the circle
  float maxTransparency; // Max transparency

  float growthRate;       // Growth rate
  float startTime;
  float duration;

  ExpandingCircle(float x, float y, float duration) {
    this.x = x;
    this.y = y;
    this.diameter = 10;
    this.maxTransparency = 255;
    this.growthRate = 4;
    this.startTime = millis();
    this.duration = duration;
  }

  void grow() {
    
    diameter += growthRate;

    float d = dist(x, y, mouseX, mouseY);
    float currentTransparency = map(d, 0, diameter, maxTransparency, 0);
    maxTransparency = currentTransparency;

    if (maxTransparency < 10) {
      diameter = 10;
      maxTransparency = 255;
      x = mouseX;
      y = mouseY;
    }
   }
  
  void display() {


    noFill();
    stroke(255, maxTransparency);
    strokeWeight(2);
    ellipse(x, y, diameter, diameter);
  }

  boolean isitFinished() {
    float currentTime = millis();  // Temps actuel en millisecondes
    float elapsedTime = currentTime - startTime;  // Calcule le temps écoulé depuis la création de la particule
    return elapsedTime >= duration;  // Renvoie vrai si la particule a dépassé sa durée de vie
  }
}



class Particle {
  float x;  // Position en x de la particule
  float y;  // Position en y de la particule
  float radius;  // Rayon de la particule
  color particleColor;  // Couleur de la particule
  float startTime;  // Moment où la particule a été créée
  float duration;  // Durée de vie de la particule
  
  Particle(float x, float y, float radius, color particleColor, float duration) {
    // Constructeur de la classe Particle
    this.x = x;  
    this.y = y;  
    this.radius = radius;  
    this.particleColor = particleColor;  
    this.startTime = millis();  
    this.duration = duration;  
  }
  
  void display() {
    noStroke();  
     
    float currentTime = millis() / 1000.0;
    float elapsedTime = currentTime - startTime;
    if (elapsedTime < 1.0) { // au debut, l'ellipse est blanche
      fill(255, 50);
    } else { // ensuite, elle diminue en opacité progressivement 
      fill(lerpColor( particleColor, color(255, 0), (elapsedTime - 1.0) / (duration - 1.0)));
    }

    ellipse(x, y, radius, radius);  // Dessine une ellipse à la position (x, y) avec le rayon spécifié
  }
  
  boolean isFinished() {
    float currentTime = millis();  // Temps actuel en millisecondes
    return (currentTime - startTime) > duration;  // Renvoie vrai si la particule a dépassé sa durée de vie
    
  }
}
