function scr_enemyAttackState()
{
    // DIDÁTICO: O estado de ataque zera a velocidade horizontal para o inimigo parar e desferir o golpe/disparo.
    hsp = 0;
    
    // Decrementa o timer do ataque
    enemyAttackTimer--;
    
    // Busca a referência do jogador
    var p = instance_find(obj_player, 0);
    if (p == noone || p.state == PLAYER_STATE.DEAD)
    {
        state = ENEMY_STATE.PATROL;
        exit;
    }
    
    // DIDÁTICO: Comportamento diferenciado de ataque com base no tipo de inimigo (polimorfismo simples)
    if (object_index == obj_enemy)
    {
        // Inimigo comum (Melee): causa dano no frame do meio do ataque (timer na metade do máximo)
        if (enemyAttackTimer == floor(enemyAttackTimerMax / 2))
        {
            var dist = point_distance(x, y, p.x, p.y);
            var pDir = sign(p.x - x);
            
            // Verifica se o jogador ainda está ao alcance, se o inimigo está virado para ele e se o player não está escondido (HIDE)
            if (dist <= enemyAttackRange && (pDir == 0 || pDir == image_xscale) && p.state != PLAYER_STATE.HIDE)
            {
                // DIDÁTICO: Aplica dano ao jogador e o empurra (knockback)
                with (p)
                {
                    scr_playerTakeDamage(other.image_xscale, 15);
                }
            }
        }
    }
    else if (object_index == obj_enemy2)
    {
        // Inimigo ranged (Atirador): atira no primeiro frame ativo (timer em 19, pois inicia em 20)
        if (enemyAttackTimer == 19)
        {
            var proj = instance_create_layer(x, y - 16, "Instances", obj_enemyProjectile);
            if (proj != noone)
            {
                // DIDÁTICO: O projétil se desloca horizontalmente na direção para onde o inimigo está virado (velocidade reduzida para 5 para balanceamento)
                proj.hsp = image_xscale * 5;
                proj.image_blend = c_purple; // Diferenciação visual roxa para combinar com o atirador
            }
        }
    }
    
    // DIDÁTICO: Quando o tempo de ataque termina, retorna ao estado de perseguição (CHASE)
    if (enemyAttackTimer <= 0)
    {
        state = ENEMY_STATE.CHASE;
        lostTimer = lostTimerMax; // Reseta tolerância de visão para continuar perseguindo de imediato
    }
}
