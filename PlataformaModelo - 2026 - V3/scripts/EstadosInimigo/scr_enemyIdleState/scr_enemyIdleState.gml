function scr_enemyIdleState()
{
    // 1. DETECÇÃO DO JOGADOR
    if (scr_enemyCheckForPlayer()) {
        exit;
    }

    idleTime--;
    if (idleTime <= 0) {
        state = ENEMY_STATE.PATROL;
        hsp = (image_xscale == 1) ? walkSpeed : -walkSpeed; // Volta a andar na direção que estava
    }
}