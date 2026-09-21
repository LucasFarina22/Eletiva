function scr_playerSwimState()
{
    // ============================================================
    // ESTADO: SWIM (NATAÇÃO)
    // ============================================================
    grv = swimGravity;
    
    // Movimento horizontal suave e amortecido na água
    hsp = lerp(hsp, inputX * swimSpeed, 0.1);
    
    // Limite de queda vertical na água (velocidade terminal)
    vsp = min(vsp, 2.5);
    
    // Pulo / Braçada
    if (jumpPressed)
    {
        var headSubmerged = place_meeting(x, y - 10, obj_water);
        if (!headSubmerged)
        {
            // Salto para fora da água
            vsp = -7.5;
            state = PLAYER_STATE.AIR;
            grv = normalGravity;
            exit;
        }
        else
        {
            // Braçada vertical na água
            vsp = -3.2;
        }
    }
    
    // Afundar / Nadar para baixo
    if (downKey)
    {
        vsp = max(vsp, 2.0);
    }
    
    // Se o player sair da água, volta para o estado AIR
    if (!place_meeting(x, y, obj_water))
    {
        state = PLAYER_STATE.AIR;
        grv = normalGravity;
    }
}
