function scr_playerInteractions()
{
//------------------------------------------CHECKPOINT----------------------------------------------    
    //Tempo de chechpoint
    if (checkpointLock > 0) 
    {
        checkpointLock--;
    }
    
    // CHECKPOINT - ATIVAÇÃO (mais robusto)
    if (checkpointLock <= 0)
    {
        var cp = instance_place(x, y, obj_checkpoint);
        if (cp != noone && cp != checkpointId)
        {
            // DIDÁTICO: Salvamos o X centralizado, mas o Y ligeiramente acima do meio (+12)
            // para garantir que ao renascer o player não fique travado dentro do bloco de chão.
            checkpointX = cp.x + 16;
            checkpointY = cp.y + 12;
            checkpointId = cp;
            
            checkpointLock = checkpointLockMax;
        }
    }
    
//------------------------------------------ESPINHOS----------------------------------------------    
    //Colisão com o espinho
    var hz = instance_place(x, y, obj_spike);
    if (hz != noone && invTime <= 0)
    {
    
        // Calculamos a direção baseada no centro dos dois
        // Centro do player (x) vs Centro do espinho (hz.x + 16)
        var _hzCenter = (hz.bbox_left + hz.bbox_right) * 0.5; // centro real em X
        var _hitDir = (x < _hzCenter) ? 1 : -1;
    
    
        scr_playerTakeDamage(_hitDir, 10);
    }
    
//------------------------------------------INIMIGO----------------------------------------------    
    // DIDÁTICO: Evita colisão de dano se o jogador estiver camuflado no estado HIDE (furtividade)
    if (state != PLAYER_STATE.HIDE)
    {
        var en = instance_place(x, y, obj_enemy);
        if (en != noone && invTime <= 0)
        {
            //Verificamos se o inimigo está a direita ou a esquerda do player
            var _hitDir = (x < en.x) ? 1 : -1; 
            scr_playerTakeDamage(_hitDir, 15);
        }
    }
    
    //------------------------------------------COLETAVEIS----------------------------------------------    
    /*// Colisão com moedas
    var coin = instance_place(x, y, obj_coin);
    if (coin != noone)
    {
        coins += 1;
        instance_destroy(coin);
    }
    
    // Colisão com poções
    var potion = instance_place(x, y, obj_potion);
    if (potion != noone)
    {
        var gui = instance_find(obj_GUI, 0);
        if (gui != noone)
        {
            gui.addItem("Poção de Vida", "Poção vermelha. Recupera 25 HP.", 1);
        }
        instance_destroy(potion);
    }*/
    
    //------------------------------------------TRAMPOLINS----------------------------------------------    
    // Colisão com trampolins
    var tramp = instance_place(x, y, obj_trampoline);
    if (tramp != noone)
    {
        // Se o player está caindo ou quase caindo sobre o trampolim
        if (vsp >= 0 && (bbox_bottom - vsp <= tramp.bbox_top + 8))
        {
            vsp = -11; // Lança o jogador para cima
            state = PLAYER_STATE.AIR;
            jumpCount = maxJumps; // Reseta pulo duplo
            canAirDash = true;    // Reseta dash no ar
            
            // Deforma o trampolim (Squash & Stretch)
            tramp.image_yscale = 0.3;
            tramp.image_xscale = 1.5;
        }
    }
}