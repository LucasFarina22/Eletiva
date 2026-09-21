function scr_playerAirState()
{
    // ============================================================
    // ESTADO: AR
    // ============================================================
    // Player está no ar:
    // - controle reduzido
    // - não pode pular novamente (por enquanto)

    // 1. Input
    //scr_playerInput();

    // 2. Movimento horizontal (controle no ar)
    scr_playerMove();

    // 3. Transição para o chão
    if (grounded)
    {
        state = PLAYER_STATE.GROUND;
        return;
    }
    
    // AIR DASH
    if (dashPressed && dashCooldown <= 0 && canAirDash && stamina >= stamina_cost_dash)
    {
        stamina -= stamina_cost_dash; // Gasta a stamina
        
        dashDir = (inputX != 0) ? sign(inputX) : sign(image_xscale);
        dashTime = dashTimeMax;
        dashCooldown = dashCooldownMax;
        state = PLAYER_STATE.DASH;
        canAirDash = false;
        return;
    }
    
    // DIDÁTICO: Transição para o estado de tiro (SHOOT) no ar ao apertar o botão correspondente (V ou clique direito)
    if (rangedAttackPressed && hasRangedAttack && stamina >= 15)
    {
        stamina -= 15; // Consome 15 de stamina
        shootTime = shootTimeMax; // Inicia o timer de tiro
        state = PLAYER_STATE.SHOOT; // Muda o estado
        return;
    }
    
    //DOUBLE JUMP
    // Só permite se tiver o "poder" (hasDoubleJump) E se ainda houver pulos no contador
    if (jumpPressed && hasDoubleJump && jumpCount > 0)
    {
        vsp = jspd;     // Aplica a força de pulo novamente
        jumpCount--;    // Gasta o pulo atual
    }
    
    // TRANSICAO PARA WALL SLIDE
    if (hasWallSlide && vsp > 0)
    {
        var onWallRight = place_meeting(x + 1, y, obj_wall);
        var onWallLeft  = place_meeting(x - 1, y, obj_wall);
        
        if ((onWallRight && rightKey) || (onWallLeft && leftKey))
        {
            vsp = 0;
            state = PLAYER_STATE.WALL_SLIDE;
            return;
        }
    }

    // ATAQUE NO AR
    if (attackPressed && hasAttack)
    {
        attackTime = attackTimeMax;
        isAttacking = true;
        state = PLAYER_STATE.ATTACK_AIR;
        return;
    }
}