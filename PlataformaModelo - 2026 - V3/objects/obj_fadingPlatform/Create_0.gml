// DIDÁTICO: A plataforma fading herda de obj_wall para colisão automática.
// Ela altera dinamicamente sua máscara de colisão entre sólida e vazia (spr_empty_mask)
// com base em uma onda senoidal de tempo para alternar sua solidez e visibilidade.

fadeSpeed = 0.03;      // Velocidade de oscilação do fôlego/aparecimento
theta = 0;             // Acumulador de ângulo (tempo)
