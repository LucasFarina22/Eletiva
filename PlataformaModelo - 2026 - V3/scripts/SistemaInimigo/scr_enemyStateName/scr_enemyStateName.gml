function scr_enemyStateName(_s)
{
    switch (_s)
    {
        case ENEMY_STATE.PATROL: return "PATROL";
        case ENEMY_STATE.IDLE:   return "IDLE";
        case ENEMY_STATE.HURT:   return "HURT";
        case ENEMY_STATE.DEAD:   return "DEAD";
        case ENEMY_STATE.CHASE:  return "CHASE";
        case ENEMY_STATE.ALERT:  return "ALERT";
        case ENEMY_STATE.ATTACK: return "ATTACK";
    }
    return "UNKNOWN";
}