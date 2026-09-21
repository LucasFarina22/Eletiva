function scr_playerShootState()
{
    // DIDÁTICO: No estado de disparo, travamos a velocidade horizontal (hsp = 0) para o jogador
    // focar na mira e execução do tiro.
    hsp = 0;
    
    // Se estiver no ar, aplica gravidade normalmente para continuar caindo.
    if (!grounded)
    {
        vsp += grv;
    }
    
    // DIDÁTICO: No primeiro frame do estado de tiro, geramos o projétil à frente do player.
    if (shootTime == shootTimeMax)
    {
        var proj = instance_create_layer(x + image_xscale * 16, y - 16, "Instances", obj_playerProjectile);
        if (proj != noone)
        {
            proj.hsp = image_xscale * 8; // Dispara na direção em que o jogador está virado
            proj.image_blend = c_yellow; // Diferenciação visual com brilho amarelo
        }
    }
    
    // Decrementa o tempo restante no estado de tiro
    shootTime--;
    
    // DIDÁTICO: Ao zerar o timer do tiro, retorna o controle do player para GROUND ou AIR.
    if (shootTime <= 0)
    {
        if (grounded)
        {
            state = PLAYER_STATE.GROUND;
        }
        else
        {
            state = PLAYER_STATE.AIR;
        }
    }
}
