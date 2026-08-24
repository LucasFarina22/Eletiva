// DIDÁTICO: A plataforma móvel herda de obj_wall (definido via objeto pai) 
// para que o jogador e inimigos colidam fisicamente com ela de forma automática.
// Ela usa a função matemática seno para realizar movimentos suaves (Ease-In-Out).

// Variáveis configuráveis pelo editor de salas (Variable Definitions ou Creation Code)
isHorizontal = true;     // Se true, move-se horizontalmente; se false, verticalmente
moveSpeed = 2.0;         // Velocidade de oscilação
moveRange = 128.0;       // Distância total do trajeto em pixels (pixels)

// Variáveis de controle de estado interno
startX = x;
startY = y;
theta = 0;               // Acumulador de ângulo (tempo acumulado)

hsp = 0;                 // Velocidade horizontal calculada neste frame
vsp = 0;                 // Velocidade vertical calculada neste frame
