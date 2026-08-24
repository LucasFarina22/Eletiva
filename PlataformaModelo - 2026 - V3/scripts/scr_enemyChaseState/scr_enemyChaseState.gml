function scr_enemyChaseState()
{
    var p = instance_find(obj_player, 0);
    if (p == noone || p.state == PLAYER_STATE.DEAD)
    {
        state = ENEMY_STATE.PATROL;
        hsp = 0;
        exit;
    }
    
    // DIDÁTICO: Decrementa o cooldown de tiro do inimigo ranged (obj_enemy2) se ele estiver em perseguição.
    if (object_index == obj_enemy2 && shootCooldown > 0)
    {
        shootCooldown--;
    }
    
    var dist = point_distance(x, y, p.x, p.y);
    var dirToPlayer = point_direction(x, y - 16, p.x, p.y - 16);
    var faceDir = (image_xscale == 1) ? 0 : 180;
    var diff = abs(angle_difference(dirToPlayer, faceDir));
    
    // Raycasting para ver se há paredes no caminho
    var canSee = false;
    // DIDÁTICO: Adicionamos abs(y - p.y) <= 60 para parar a perseguição se o player subir/descer demais verticalmente.
    if (dist <= visionRange && diff <= visionCone && p.state != PLAYER_STATE.HIDE && abs(y - p.y) <= 60)
    {
        var wallHit = collision_line(x, y - 16, p.x, p.y - 16, colMask, false, true);
        if (wallHit == noone)
        {
            canSee = true;
        }
    }
    
    if (canSee)
    {
        // Reseta o timer de perda de visão
        lostTimer = lostTimerMax;
        
        // Determina a direção até o jogador
        var pDir = sign(p.x - x);
        if (pDir != 0)
        {
            image_xscale = pDir;
        }
        
        // DIDÁTICO: Comportamento diferenciado por tipo de objeto (herança)
        if (object_index == obj_enemy)
        {
            // Inimigo comum (melee): se estiver ao alcance, entra no estado de ataque corporal
            if (dist <= enemyAttackRange)
            {
                hsp = 0;
                state = ENEMY_STATE.ATTACK;
                enemyAttackTimer = enemyAttackTimerMax;
                exit;
            }
            
            if (pDir != 0)
            {
                hsp = pDir * chaseSpeed;
            }
        }
        else if (object_index == obj_enemy2)
        {
            // Inimigo ranged (atirador): tenta manter distância segura
            if (dist <= 100)
            {
                // Muito perto! Foge na direção contrária para manter distância de disparo
                hsp = -pDir * chaseSpeed;
            }
            else if (dist <= enemyAttackRange && shootCooldown <= 0)
            {
                // Alcance correto e cooldown zerado: para para atirar
                hsp = 0;
                state = ENEMY_STATE.ATTACK;
                enemyAttackTimer = 20; // Duração do estado de disparo (0.33 segundos)
                shootCooldown = shootCooldownMax;
                exit;
            }
            else
            {
                // Se estiver no meio do caminho ou em cooldown, move-se em direção ao player
                if (pDir != 0)
                {
                    hsp = pDir * chaseSpeed;
                }
            }
        }
    }
    else
    {
        // Perdeu visão! Decrementa timer
        lostTimer--;
        if (lostTimer <= 0)
        {
            state = ENEMY_STATE.ALERT;
            alertTimer = 90; // 1.5s em alerta parado
            hsp = 0;
            exit;
        }
        else
        {
            // Continua correndo na última direção vista
            var pDir = sign(p.x - x);
            if (pDir != 0)
            {
                hsp = pDir * chaseSpeed;
                image_xscale = pDir;
            }
        }
    }
    
    // Evita suicídio caindo em buraco (abismo) ou travamento em paredes
    var _floorAhead = place_meeting(x + (sign(hsp) * 16), y + 1, colMask);
    var _wallAhead = place_meeting(x + hsp, y, colMask);
    
    if (!_floorAhead || _wallAhead)
    {
        hsp = 0; // Para para não cair ou bater
    }
}
