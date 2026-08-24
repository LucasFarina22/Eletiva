event_inherited();
// 1. Processar a entrada (preenche inputX, jumpPressed, etc.)
// Chamamos o input aqui para que TODOS os estados tenham acesso às variáveis de input.
scr_playerInput(); 

//Debug Mode
scr_playerDebug();

// 2. Aplicar a lógica do estado atual (O Switch Manager)
// Este script verifica 'state' e chama o scr_playerFreeState() que acabamos de criar.
scr_playerStates(); 

// Nota: O obj_lifeForm (Pai) gerencia scr_gravity, scr_collisionX, scr_collisionY.
// Ele garante que a física seja aplicada ao final do loop, após o player decidir o que fazer.

//Verificação adicional do estado de morte
if (state == PLAYER_STATE.DEAD) exit;

// ============================================================
// FASE 6: FÍSICA E DETECÇÃO DE ÁGUA
// ============================================================
var _inWater = place_meeting(x, y, obj_water);
if (_inWater && state != PLAYER_STATE.DEAD && state != PLAYER_STATE.HURT && state != PLAYER_STATE.DASH && state != PLAYER_STATE.SWIM)
{
    state = PLAYER_STATE.SWIM;
    vsp = clamp(vsp * 0.4, -3, 2); // Amortece a velocidade vertical ao entrar
    jumpCount = maxJumps;
    canAirDash = true;
}

// Lógica de Fôlego (Oxigênio)
var headSubmerged = place_meeting(x, y - 10, obj_water);
if (headSubmerged && state != PLAYER_STATE.DEAD)
{
    breath = max(0, breath - 0.25); // Perda de ar (~4 segundos de fôlego)
    if (breath <= 0)
    {
        if (breathDamageTimer <= 0)
        {
            scr_playerTakeDamage(0, 5); // 5 de dano
            breathDamageTimer = 30; // Dano a cada 0.5s (30 frames)
        }
        else
        {
            breathDamageTimer--;
        }
    }
}
else
{
    breath = min(breath_max, breath + 2); // Recupera rapidamente
    breathDamageTimer = 0;
}


// Atualiza cooldown do dash
if (dashCooldown > 0)
{
    dashCooldown--;
}

// Regenera stamina (DIDÁTICO: Bloqueia a regeneração caso o jogador esteja no estado HIDE/Furtivo)
if (stamina < stamina_max && state != PLAYER_STATE.HIDE)
{
    stamina = min(stamina + stamina_regen, stamina_max);
}

// ============================================================
// SISTEMA DE INVENCIBILIDADE E PISCADA DE DANO
// ============================================================
// DIDÁTICO: O loop de invencibilidade reduz o timer frame a frame.
// Enquanto o jogador estiver invencível (invTime > 0), ele pisca na tela
// alternando entre transparente e seu alpha base (0.4 se escondido, 1.0 se normal).
if (invTime > 0)
{
    invTime--;
    
    // Determina o alpha de destino base do estado
    var baseAlpha = 1.0;
    if (state == PLAYER_STATE.HIDE) 
    {
        baseAlpha = 0.4;
    }
    
    // Efeito de piscar rápido alternando a cada frame
    image_alpha = (invTime mod 2 == 0) ? 0.05 : baseAlpha;
}
else
{
    // DIDÁTICO: Se não estiver invencível, define o alpha baseado no estado de jogo.
    // O estado HIDE deixa o jogador semitransparente (0.4) para indicar furtividade.
    if (state == PLAYER_STATE.HIDE)
    {
        image_alpha = 0.4;
    }
    else
    {
        image_alpha = 1.0;
    }
}

//Interações do Player
scr_playerInteractions();

// DIDÁTICO: Sincroniza todas as variáveis de status do player para o controlador persistente
// ao final de cada frame. Isso garante que vida, estamina, moedas e upgrades modificados por scripts
// sejam salvos na persistência.
if (instance_exists(obj_playerStats)) {
    obj_playerStats.hp = hp;
    obj_playerStats.hp_max = hp_max;
    obj_playerStats.stamina = stamina;
    obj_playerStats.stamina_max = stamina_max;
    obj_playerStats.currentLives = currentLives;
    obj_playerStats.coins = coins;
    
    obj_playerStats.hasDoubleJump = hasDoubleJump;
    obj_playerStats.hasAttack = hasAttack;
    obj_playerStats.hasRangedAttack = hasRangedAttack;
    obj_playerStats.hasWallSlide = hasWallSlide;
    obj_playerStats.hasWallJump = hasWallJump;
}