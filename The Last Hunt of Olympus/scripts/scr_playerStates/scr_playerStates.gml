function scr_playerStates()
{
    // Reseta gravidade para o padrão se não estiver nadando
    if (state != PLAYER_STATE.SWIM)
    {
        grv = normalGravity;
    }

     switch (state)
    {
        case PLAYER_STATE.GROUND:
            scr_playerGroundState();
            break;
        
        case PLAYER_STATE.AIR:
            scr_playerAirState();
            break;

        case PLAYER_STATE.ATTACK:
            scr_playerAttackState();
            break;

        case PLAYER_STATE.ATTACK_MOVE:
            scr_playerAttackMoveState();
            break;

        case PLAYER_STATE.ATTACK_AIR:
            scr_playerAttackAirState();
            break;

        case PLAYER_STATE.HURT:
            scr_playerHurtState();
            break;

        case PLAYER_STATE.DASH:
            scr_playerDashState();
            break;

        case PLAYER_STATE.DEAD:
            scr_playerDeadState();
            break;
            
        case PLAYER_STATE.WALL_SLIDE:
            scr_playerWallSlideState();
            break;

        case PLAYER_STATE.SWIM:
            scr_playerSwimState();
            break;

        case PLAYER_STATE.HIDE:
            scr_playerHideState();
            break;

        case PLAYER_STATE.SHOOT:
            scr_playerShootState();
            break;
    }
}