function scr_enemyAlertState()
{
    alertTimer--;
    
    // Olha de um lado para o outro para simular busca visual (a cada 0.5s)
    if (alertTimer mod 30 == 0)
    {
        image_xscale *= -1; // Vira de lado
    }
    
    // Se avistar o player durante o alerta, volta a perseguir!
    if (scr_enemyCheckForPlayer())
    {
        exit;
    }
    
    if (alertTimer <= 0)
    {
        state = ENEMY_STATE.PATROL;
        hsp = (image_xscale == 1) ? walkSpeed : -walkSpeed;
    }
}
