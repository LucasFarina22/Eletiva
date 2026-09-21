function scr_playerHideState()
{
    // ============================================================
    // ESTADO: HIDE (FURTIVIDADE)
    // ============================================================
    // DIDÁTICO: O estado HIDE impede o movimento do jogador (hsp e vsp zerados)
    // e o torna indetectável para os inimigos.
    hsp = 0;
    vsp = 0;
    
    // Verifica colisão com moitas de vegetação (obj_bush)
    var bush = instance_place(x, y, obj_bush);
    var insideBush = (bush != noone);
    
    // DIDÁTICO: Se o jogador estiver escondido dentro de uma moita, o custo de estamina é zero (esconderijo gratuito).
    // Caso contrário, ele está se camuflando sob esforço físico no chão limpo, o que consome estamina.
    if (!insideBush)
    {
        stamina = max(0, stamina - 0.4); // Consome estamina progressivamente
        
        // Se a estamina acabar, ele é forçado a revelar-se voltando ao estado de chão normal
        if (stamina <= 0)
        {
            state = PLAYER_STATE.GROUND;
            exit;
        }
    }
    
    // DIDÁTICO: O jogador sai automaticamente da furtividade se realizar qualquer ação física:
    // mover-se para os lados, tentar pular, atacar ou pressionar o botão de interação novamente.
    if (abs(inputX) > 0 || jumpPressed || attackPressed || interactPressed)
    {
        state = PLAYER_STATE.GROUND;
    }
}
