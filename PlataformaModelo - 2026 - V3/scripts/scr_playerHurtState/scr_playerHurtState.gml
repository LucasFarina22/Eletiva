function scr_playerHurtState()
{
    // 1. Desaceleração gradual do Knockback
    // DIDÁTICO: O hsp recebeu o impulso horizontal inicial no momento do impacto.
    // Aqui, apenas amortecemos esse impulso suavemente frame a frame.
    hsp = lerp(hsp, 0, 0.15);
    
    // 2. Visual: Piscar ou mudar cor (Opcional)
    //image_blend = c_red;
    
    // 3. Contagem regressiva do tempo de "atordoamento"
    hurtTime--;
    
    // 4. Condição de Saída
    if (hurtTime <= 0)
    {
        //image_blend = c_white;

        state = grounded ? PLAYER_STATE.GROUND : PLAYER_STATE.AIR;
        return;
    }
}