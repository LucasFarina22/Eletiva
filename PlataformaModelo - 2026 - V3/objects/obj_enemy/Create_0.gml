// 1. HERANÇA: Importante! Garante que as variáveis do obj_lifeForm (Pai) sejam carregadas primeiro.
event_inherited();

// Inicializa o estado.
state = ENEMY_STATE.PATROL;

// ================================================================================================================
//                                              VARIÁVEIS ESPECÍFICAS DO INIMIGO
// ================================================================================================================
// ============================================================
// MOVIMENTO - PARÂMETROS
// ============================================================
walkSpeed = 3;
hsp = walkSpeed;
idleTime = 0;

// =================================================================
// HURT
// =================================================================
//tempo de dano (reduzido de 60 para 20 frames para balancear o stun)
hurtTime = 0; 
hurtTimeMax = 20;

//knockback
knockbackHsp = 2; 
knockbackVsp = 2;

//diração do dano
hitDir = image_xscale;

// ============================================================
// VISÃO E DETECÇÃO (FASE 3)
// ============================================================
visionRange = 300;     // Distância máxima de detecção
visionCone = 60;       // Metade do ângulo total do cone (120 graus no total)
chaseSpeed = 3.2;      // Velocidade de corrida reduzida ao perseguir o jogador para possibilitar fuga
lostTimer = 0;         // Timer atual de perda de visão
lostTimerMax = 90;     // Tolerância (1.5 segundos a 60 FPS) antes de entrar em alerta
alertTimer = 0;        // Timer de estado de busca alerta

// ============================================================
// COMBATE E ATAQUE (FASE 9)
// ============================================================
// DIDÁTICO: Variáveis para controle do estado de ataque melee do inimigo comum
enemyAttackTimer = 0;
enemyAttackTimerMax = 30; // Duração do ataque (0.5s a 60 FPS)
enemyAttackRange = 40;    // Distância para iniciar o ataque melee (corporal)