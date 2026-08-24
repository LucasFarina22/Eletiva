// 1. HERANÇA: Chama o Create do inimigo pai (obj_enemy)
event_inherited();

// DIDÁTICO: Propriedades específicas do novo inimigo atirador (ranged)
image_blend = c_purple;    // Diferenciação visual em tom roxo
visionRange = 400;         // Campo de visão estendido para atirar de longe
chaseSpeed = 2.5;          // Velocidade de deslocamento reduzida para balanceamento
enemyAttackRange = 250;    // Alcance máximo do disparo do projétil
shootCooldown = 0;         // Cooldown atual de tiro
shootCooldownMax = 180;     // Tempo entre disparos (~3s a 60 FPS para balanceamento)
