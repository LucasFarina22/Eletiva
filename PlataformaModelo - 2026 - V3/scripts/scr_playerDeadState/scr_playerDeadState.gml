function scr_playerDeadState()
{
    //Tira resíduos de dano
    invTime = 0;
    hurtTime = 0;
    hsp = 0;
    vsp = 0;
    // 1. Visual de morte
    image_blend = c_black; // Fica escurinho
    image_alpha = lerp(image_alpha, 0, 0.05); // Vai sumindo aos poucos
    
    deadTime--;

    if (deadTime <= 0)
    {
        if (currentLives > 0)
        {
            currentLives -= 1; // Perde uma vida
            // 1. Teletransporta para a coordenada salva
            x = checkpointX;
            y = checkpointY;
        
            // 2. SEGURANÇA (DIDÁTICO): Se o checkpoint estiver ligeiramente desalinhado ou "enterrado", tenta descolar
            // o jogador para cima passo a passo, apenas se esse deslocamento resolver a colisão com o cenário.
            var safety_counter = 0;
            var tempY = y;
            var collision_resolved = false;
            while (safety_counter < 32) 
            {
                if (!place_meeting(x, tempY, colMask))
                {
                    collision_resolved = true;
                    break;
                }
                tempY -= 1; 
                safety_counter++;
            }
            if (collision_resolved)
            {
                y = tempY;
            }
            
            // 3. REINICIALIZAÇÃO DO ÁCIDO (DIDÁTICO): Na sala de inundação de torre (rm_3), reinicia a posição
            // do gerador de inundação e destrói o ácido atual para que o jogador não sofra dano imediato ao renascer.
            var flood = instance_find(obj_flood, 0);
            if (flood != noone)
            {
                with (flood)
                {
                    floodY = room_height + 64;
                    if (acidInstance != noone && instance_exists(acidInstance))
                    {
                        instance_destroy(acidInstance);
                    }
                    acidInstance = noone;
                }
            }
    
            // reseta vida (decida o valor padrão)
            hp = hp_max;
            
            checkpointLock = checkpointLockMax;
    
            // reseta física/estados
            hsp = 0;
            vsp = 0;
    
            grounded = false;
            jumpCount = maxJumps;      // se estiver usando contador
            canAirDash = true;         // se quiser resetar junto
            dashCooldown = 0;
            dashTime = 0;
    
            // reseta stamina (opcional)
            stamina = stamina_max;
    
            // volta para um estado padrão
            state = PLAYER_STATE.AIR; // cai até encostar no chão
            image_alpha = 1;
            image_blend = c_white;
        }
        else 
        {
        	room_restart();
            exit;
        }
    }
        
}