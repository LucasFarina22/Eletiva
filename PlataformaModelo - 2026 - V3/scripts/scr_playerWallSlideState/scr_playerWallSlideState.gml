function scr_playerWallSlideState()
{
    // Identifica se há parede à direita ou esquerda
    var wallDir = 0;
    if (place_meeting(x + 1, y, obj_wall)) wallDir = 1;
    else if (place_meeting(x - 1, y, obj_wall)) wallDir = -1;
    
    // Se não há parede ou tocou no chão, sai do estado de wall slide
    if (wallDir == 0 || grounded)
    {
        state = grounded ? PLAYER_STATE.GROUND : PLAYER_STATE.AIR;
        return;
    }
    
    // Aplica fricção na parede (desliza lento)
    vsp = min(vsp, 1.5);
    
    // Reseta o dash no ar e o contador de pulos para maior fluidez
    canAirDash = true;
    jumpCount = maxJumps;

    // Se o jogador pressionar para pular E tiver o upgrade de pulo na parede
    if (jumpPressed && hasWallJump)
    {
        vsp = jspd; // Aplica força de pulo (jspd é negativo)
        hsp = -wallDir * moveSpeed * 1.3; // Impulso horizontal oposto
        image_xscale = -wallDir; // Olha para a direção contrária da parede
        state = PLAYER_STATE.AIR;
        return;
    }
    
    // Se o jogador estiver segurando na direção oposta à parede, se desprende dela
    if ((wallDir == 1 && leftKey) || (wallDir == -1 && rightKey))
    {
        state = PLAYER_STATE.AIR;
        return;
    }
}
