// 1. HERANÇA: Importante! Garante que as variáveis do obj_lifeForm (Pai) sejam carregadas primeiro.
event_inherited(); 

// DIDÁTICO: Garante que o gerenciador de status persistente exista no jogo.
// Usamos depth para evitar erros caso a layer "Instances" não esteja criada na sala atual.
if (!instance_exists(obj_playerStats)) {
    instance_create_depth(0, 0, 0, obj_playerStats);
}

// Carrega os status do controlador persistente para as variáveis locais do Player
hp = obj_playerStats.hp;
hp_max = obj_playerStats.hp_max;
stamina = obj_playerStats.stamina;
stamina_max = obj_playerStats.stamina_max;
currentLives = obj_playerStats.currentLives;
livesMax = obj_playerStats.livesMax;
coins = obj_playerStats.coins;

// Upgrades
hasDoubleJump = obj_playerStats.hasDoubleJump;
hasAttack = obj_playerStats.hasAttack;
hasRangedAttack = obj_playerStats.hasRangedAttack;
hasWallSlide = obj_playerStats.hasWallSlide;
hasWallJump = obj_playerStats.hasWallJump;

// Inicializa o estado.
state = PLAYER_STATE.GROUND; 

// ================================================================================================================
//                                              VARIÁVEIS ESPECÍFICAS DO PLAYER
// ================================================================================================================
// ============================================================
// MOVIMENTO - PARÂMETROS
// ============================================================
moveSpeed = 4; // Velocidade máxima horizontal
normalSpeed = 4;
swimSpeed = 2.2;

normalGravity = 0.3;
swimGravity = 0.08;

breath = 100;
breath_max = 100;
breathDamageTimer = 0;

accelGround = 0.35; // Aceleração no chão
frictionGround = 0.15; // Desaceleração (fricção) no chão

accelAir = 0.2; // Aceleração no ar (menor controle)
frictionAir = 0.05; // Fricção no ar (quase nenhuma)


// ============================================================
// DASH
// ============================================================

// Força do dash
dashSpeed = 10; // Velocidade horizontal extrema durante o dash

// Duração do dash (frames)
dashTimeMax = 15; 
dashTime = 0; // Contador de frames restantes do dash

// Cooldown do dash
dashCooldownMax = 30;
dashCooldown = 0;

// Direção do dash
dashDir = 0;

//Air Dash
canAirDash = true;

// =================================================================
// VARIÁVEIS DE RECURSO (STAMINA)
// =================================================================
// DIDÁTICO: stamina_max e stamina agora são carregadas do obj_playerStats no início
stamina_cost_dash = 20; // Custo de stamina por dash
stamina_regen = 0.5;

// =================================================================
// DOUBLE JUMP
// =================================================================
canDoubleJump = true;
maxJumps = 2;
jumpCount = maxJumps;

// =================================================================
// UPGRADES (METROIDVANIA PROGRESSION)
// =================================================================
// DIDÁTICO: Os upgrades agora são carregados do obj_playerStats no início


// =================================================================
// HURT
// =================================================================
//Invencibilidade
invTime = 0; 
invTimeMax = 60;

//tempo de dano (reduzido de 60 para 20 frames para balanceamento de combate)
hurtTime = 0; 
hurtTimeMax = 20;

//knockback
knockbackHsp = 2; 
knockbackVsp = 2;

//diração do dano
hitDir = image_xscale;

// ============================================================
// DEAD / RESPAWN
// ============================================================
startX = x;
startY = y;

deadTimeMax = 60; // 1 segundo em 60fps
deadTime = 0;


// ============================================================
// CHECKPOINT
// ============================================================
checkpointX = startX;
checkpointY = startY;
checkpointId = noone; // opcional: guardar qual bandeira foi ativada

// trava para não reativar checkpoint no mesmo frame (opcional, mas recomendo)
checkpointLock = 0;
checkpointLockMax = 10;


// ============================================================
// LIFES (VIDAS)
// ============================================================
// DIDÁTICO: livesMax e currentLives agora são carregadas do obj_playerStats no início

// ============================================================
// MOEDAS (COLETÁVEIS)
// ============================================================
// DIDÁTICO: coins agora é carregada do obj_playerStats no início

// ============================================================
// ATAQUE
// ============================================================
attackTime = 0;
attackTimeMax = 20;
isAttacking = false;
attackDamage = 50;

// DIDÁTICO: Variáveis para controle do estado de tiro do jogador
shootTime = 0;
shootTimeMax = 15; // Cooldown/tempo travado no estado de tiro (0.25 segundos a 60 FPS)

// ============================================================
// DEBUG MODE
// ============================================================
debugMode = false; // deixe true enquanto desenvolve;