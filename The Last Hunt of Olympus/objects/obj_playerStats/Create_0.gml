// DIDÁTICO: Este é o controlador persistente que armazena todas as estatísticas do jogador.
// Por ser persistente, ele não é destruído ao trocar de salas (rooms), mantendo os valores
// de vida, estamina, moedas e upgrades salvos corretamente de forma centralizada.

// Atributos de Vida e Vidas (Restauráveis)
hp_max = 100;
hp = hp_max;

livesMax = 3;
currentLives = livesMax;

// Atributos de Recurso (Estamina)
stamina_max = 100;
stamina = stamina_max;

// Coletáveis / Recursos da jornada
coins = 0;

// Upgrades Desbloqueados (Habilidades de Progressão)
hasDoubleJump = true;
hasAttack = false;
hasRangedAttack = false;
hasWallSlide = true;
hasWallJump = true;
