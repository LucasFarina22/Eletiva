function scr_enemyStates()
{
    switch (state)
    {
        case ENEMY_STATE.PATROL:
            scr_enemyPatrolState();
            break;
    
        case ENEMY_STATE.IDLE:
            scr_enemyIdleState();
            break;
        
        case ENEMY_STATE.HURT:
            scr_enemyHurtState();
            break;
        
        case ENEMY_STATE.DEAD:
            scr_enemyDeadState();
            break;
            
        case ENEMY_STATE.CHASE:
            scr_enemyChaseState();
            break;
            
        case ENEMY_STATE.ALERT:
            scr_enemyAlertState();
            break;
            
        case ENEMY_STATE.ATTACK:
            scr_enemyAttackState();
            break;
    }
}