function scr_enemyHurtState()
{
    // DIDÁTICO: O hsp recebeu o impulso horizontal inicial no momento do impacto.
    // Aqui, apenas amortecemos esse impulso suavemente frame a frame.
    hsp = lerp(hsp, 0, 0.15);
    
    // 3. Contagem regressiva do tempo de "atordoamento"
    hurtTime--;
    
    // 4. Condição de Saída
    if (hurtTime <= 0)
    {
        //image_blend = c_white;
        hsp = 0;
        state = choose(ENEMY_STATE.PATROL,ENEMY_STATE.IDLE);
        return;
    }
}