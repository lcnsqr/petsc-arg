#include <stdio.h>
#include <stdlib.h>

// Exibiçao de cor por Led RGB
#define MAXR 255
#define MAXG 255
#define MAXB 255
struct { 
  // Numero de cores disponveis
  int estagios;
  // Pontos de passagem
  int verticesQuant;
  // Intervalos entre vertices
  int intervQuant;
  // Tamanho de cada intervalo
  double intervTaman;
  // Os vertices
  int** vertices;
  // Direcoes (vertices - 1)
  int** direcoes;
  // Cor gerada
  int t[3];
} cor;

void confCor(){
  // Definicoes de transicao de cor Led RGB
  cor.estagios = 1024;
  cor.verticesQuant = 5;
  cor.intervQuant = cor.verticesQuant - 1;
  cor.intervTaman = cor.estagios / cor.intervQuant;

  cor.vertices = (int**) malloc(sizeof(int*) * cor.verticesQuant);
  for ( int i = 0; i < cor.verticesQuant; i++ ){
    cor.vertices[i] = (int*) malloc(sizeof(int) * 3);
  }

  cor.direcoes = (int**) malloc(sizeof(int*) * cor.intervQuant);
  for ( int i = 0; i < cor.intervQuant; i++ ){
    cor.direcoes[i] = (int*) malloc(sizeof(int) * 3);
  }

  // Pontos de passagem de cor
  cor.vertices[0][0] = 0;
  cor.vertices[0][1] = 0;
  cor.vertices[0][2] = MAXB;

  cor.vertices[1][0] = 0;
  cor.vertices[1][1] = (int)(MAXG/2.0);
  cor.vertices[1][2] = (int)(MAXB/2.0);

  cor.vertices[2][0] = 0;
  cor.vertices[2][1] = MAXG;
  cor.vertices[2][2] = 0;

  cor.vertices[3][0] = (int)(MAXR/2.0);
  cor.vertices[3][1] = (int)(MAXG/2.0);
  cor.vertices[3][2] = 0;

  cor.vertices[4][0] = MAXR;
  cor.vertices[4][1] = 0;
  cor.vertices[4][2] = 0;

  // Definir direções entre vértices
  for ( int i = 0; i < cor.intervQuant; i++ ){
    for ( int k = 0; k < 3; k++ ){
      cor.direcoes[i][k] = cor.vertices[i + 1][k] - cor.vertices[i][k];
    }
  }
}

void gerarCor(int c, int* t ){
  long int k, p;
  k = cor.intervQuant * c / cor.estagios;
  p = c - cor.intervTaman * k;
  for ( int j = 0; j < 3; j++ ){
    t[j] = cor.vertices[k][j] + p * cor.direcoes[k][j] / cor.intervTaman;
  }
}

int main(int argc, char **argv){

	// Configurar transição de cores
  confCor();

	for (int c = 0; c < cor.estagios; c++){
		gerarCor(c, cor.t);
		printf("#%02X%02X%02X\n", cor.t[0], cor.t[1], cor.t[2]);
	}

}
