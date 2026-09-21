function scr_playerTakeDamage(_hitDir, _dmg)
{
    // DIDÁTICO: O jogador fica imune a novos danos temporariamente após ser atingido (tempo de frame invencível).
    if (invTime > 0) return;

    // Aplica o dano à vida do jogador
    hp -= _dmg;

    // DIDÁTICO: Caso a vida chegue a zero, transiciona imediatamente para o estado de morte (DEAD).
    if (hp <= 0 && state != PLAYER_STATE.DEAD)
    {
        state = PLAYER_STATE.DEAD;
        deadTime = deadTimeMax;

        // Reseta efeitos visuais para garantir que a animação de morte seja vista claramente
        image_alpha = 1;
        image_blend = c_white;
        exit;
    }
    else 
    {
        // DIDÁTICO: Se o jogador sobreviveu ao golpe, calcula o knockback (empurrão).
        // A direção do empurrão é baseada na posição da origem do dano em relação ao jogador.
        hitDir = _hitDir;
        
        // DIDÁTICO: Define os tempos de stun (machucado) e de invencibilidade subsequente.
        hurtTime = hurtTimeMax;
        invTime  = invTimeMax;
        
        // DIDÁTICO: Impulso inicial vertical e horizontal (knockback) aplicados no frame do impacto.
        // O hsp recebe um impulso inicial forte que decairá suavemente no estado HURT.
        vsp = -knockbackVsp;
        hsp = -hitDir * (knockbackHsp * 2.5);
        
        // Entra no estado machucado (HURT), desabilitando os controles normais do jogador
        state = PLAYER_STATE.HURT;
    }
}