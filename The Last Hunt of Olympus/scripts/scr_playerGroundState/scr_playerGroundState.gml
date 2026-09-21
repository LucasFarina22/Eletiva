function scr_playerGroundState()
{
    // ============================================================
    // ESTADO: CHÃO
    // ============================================================
    // Player está no chão:
    // - pode andar
    // - pode parar
    // - pode iniciar pulo
    // - pode atacar

    // Movimento horizontal (controle total)
    scr_playerMove();
    
    // Reset do Dash no ar ao tocar no chão
    canAirDash = true;
    // Reset de pulos ao tocar no chão
    jumpCount = maxJumps;

    // Pulo
    if (jumpPressed)
    {
        
        vsp = jspd; // Aplica a força de pulo.
        grounded = false; // Remove status de chão.
        jumpCount --;       // Gasta o primeiro pulo (2 -> 1)
        state = PLAYER_STATE.AIR; // O MAIS IMPORTANTE: Muda imediatamente para o estado AIR
        return;
    }

    // Transição para o ar (caiu de uma plataforma)
    if (!grounded && vsp >= 0)
    {
        state = PLAYER_STATE.AIR;
        return;
    }
    
    // GROUND DASH
    if (dashPressed && dashCooldown <= 0 && stamina >= stamina_cost_dash)
    {
        stamina -= stamina_cost_dash; // Gasta a stamina
        
        dashDir = (inputX != 0) ? sign(inputX) : sign(image_xscale);
        dashTime = dashTimeMax;
        dashCooldown = dashCooldownMax;
        state = PLAYER_STATE.DASH;
        return;
    }
    
    // ATAQUE
    if (attackPressed && hasAttack)
    {
        attackTime = attackTimeMax;
        isAttacking = true;
        state = (inputX == 0) ? PLAYER_STATE.ATTACK : PLAYER_STATE.ATTACK_MOVE;
        return;
    }

    // DIDÁTICO: Transição para o estado de tiro (SHOOT) ao apertar o botão de ataque à distância (V ou clique direito)
    if (rangedAttackPressed && hasRangedAttack && stamina >= 15)
    {
        stamina -= 15; // Consome 15 de stamina
        shootTime = shootTimeMax; // Inicia o timer/lock de tiro
        state = PLAYER_STATE.SHOOT; // Muda o estado
        return;
    }

    // FURTIVIDADE (HIDE / CAMUFLAGEM)
    if (interactPressed && grounded)
    {
        var cp = instance_nearest(x, y, obj_checkpoint);
        var nearCheckpoint = (cp != noone && point_distance(x, y, cp.x + 16, cp.y + 16) < 64);
        if (!nearCheckpoint)
        {
            var bush = instance_place(x, y, obj_bush);
            var insideBush = (bush != noone);
            
            if (insideBush || stamina >= 15)
            {
                state = PLAYER_STATE.HIDE;
                hsp = 0;
                vsp = 0;
                image_alpha = 0.4;
                return;
            }
        }
    }
}