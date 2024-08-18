import java.util.HashMap;

HashMap<String, Integer> coresCelulas;

float zoom = 1.0;
float deslocamentoX = 0;
float deslocamentoY = 0;
int tamanhoCelula = 50;

boolean estaArrastando = false;
float inicioArrasteX, inicioArrasteY;

void setup() {
  size(800, 800);
  coresCelulas = new HashMap<String, Integer>();
  noLoop();
}

void draw() {
  background(255);
  desenharGrade();
}

void desenharGrade() {
  stroke(240);
  
  float tamanhoEfetivoCelula = tamanhoCelula * zoom;
  
  int inicioX = floor((deslocamentoX - width/2) / tamanhoEfetivoCelula) - 1;
  int fimX = ceil((deslocamentoX + width/2) / tamanhoEfetivoCelula) + 1;
  int inicioY = floor((deslocamentoY - height/2) / tamanhoEfetivoCelula) - 1;
  int fimY = ceil((deslocamentoY + height/2) / tamanhoEfetivoCelula) + 1;
  
  for (int x = inicioX; x <= fimX; x++) {
    for (int y = inicioY; y <= fimY; y++) {
      float telaX = x * tamanhoEfetivoCelula - deslocamentoX + width/2;
      float telaY = y * tamanhoEfetivoCelula - deslocamentoY + height/2;
      
      String chave = x + "," + y;
      
      int corCelula = coresCelulas.containsKey(chave) ? coresCelulas.get(chave) : color(255);
      
      fill(corCelula);
      rect(telaX, telaY, tamanhoEfetivoCelula, tamanhoEfetivoCelula);
    }
  }
}

void mousePressed() {
  estaArrastando = false;
  inicioArrasteX = mouseX;
  inicioArrasteY = mouseY;
}

void mouseDragged() {
  float distanciaArraste = dist(inicioArrasteX, inicioArrasteY, mouseX, mouseY);
  if (distanciaArraste > 5) {
    estaArrastando = true;
    deslocamentoX -= (mouseX - pmouseX) / zoom;
    deslocamentoY -= (mouseY - pmouseY) / zoom;
    redraw();
  }
}

void mouseReleased() {
  if (!estaArrastando) {
    float mundoX = (mouseX - width/2 + deslocamentoX) / zoom;
    float mundoY = (mouseY - height/2 + deslocamentoY) / zoom;
    
    int gradeX = floor(mundoX / tamanhoCelula);
    int gradeY = floor(mundoY / tamanhoCelula);
    
    String chave = gradeX + "," + gradeY;
    
    if (mouseButton == LEFT) {
      int novaCor = obterProximaCor(coresCelulas.getOrDefault(chave, color(255)));
      if (novaCor == color(255)) {
        coresCelulas.remove(chave);
      } else {
        coresCelulas.put(chave, novaCor);
      }
    }
    
    redraw();
  }
}

int obterProximaCor(int corAtual) {
  if (corAtual == color(255)) return color(0);
  if (corAtual == color(0)) return color(0, 255, 0);
  if (corAtual == color(0, 255, 0)) return color(255, 0, 0);
  if (corAtual == color(255, 0, 0)) return color(0, 0, 255);
  if (corAtual == color(0, 0, 255)) return color(255, 255, 0);
  if (corAtual == color(255, 255, 0)) return color(255);
  return color(255);
}

void mouseWheel(MouseEvent evento) {
  float fatorEscala = 1.05;
  float novoZoom = (evento.getCount() < 0) ? zoom * fatorEscala : zoom / fatorEscala;
  
  novoZoom = constrain(novoZoom, 0.1, 5.0);
  
  float mouseXAntesZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAntesZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  zoom = novoZoom;
  
  float mouseXAposZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAposZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  deslocamentoX += mouseXAntesZoom - mouseXAposZoom;
  deslocamentoY += mouseYAntesZoom - mouseYAposZoom;
  
  redraw();
}
