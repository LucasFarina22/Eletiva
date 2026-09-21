function scr_enemyCheckForPlayer()
{
    var p = instance_find(obj_player, 0);
    if (p != noone && p.state != PLAYER_STATE.DEAD && p.state != PLAYER_STATE.HIDE)
    {
        var dist = point_distance(x, y, p.x, p.y);
        // DIDÁTICO: Limitamos a detecção vertical (diferença em Y <= 60 pixels) para evitar que o
        // inimigo tente perseguir o jogador em plataformas acima ou abaixo, o que o faria travar na beirada.
        if (dist <= visionRange && abs(y - p.y) <= 60)
        {
            // Calcula direção e ângulo em relação ao faceDir (olho do inimigo ao centro do player)
            var dirToPlayer = point_direction(x, y - 16, p.x, p.y - 16);
            var faceDir = (image_xscale == 1) ? 0 : 180;
            var diff = abs(angle_difference(dirToPlayer, faceDir));
            
            if (diff <= visionCone)
            {
                // Raycast para ver se há paredes no caminho
                var wallHit = collision_line(x, y - 16, p.x, p.y - 16, colMask, false, true);
                if (wallHit == noone)
                {
                    // Jogador avistado!
                    if (state != ENEMY_STATE.CHASE && object_index == obj_enemy2)
                    {
                        shootCooldown = 45; // 0.75s de aviso antes do primeiro tiro
                    }
                    state = ENEMY_STATE.CHASE;
                    lostTimer = lostTimerMax;
                    return true;
                }
            }
        }
    }
    return false;
}
