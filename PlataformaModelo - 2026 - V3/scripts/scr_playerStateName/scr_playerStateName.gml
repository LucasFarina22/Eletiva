function scr_playerStateName(_s)
{
    switch (_s)
    {
        case PLAYER_STATE.GROUND: return "GROUND";
        case PLAYER_STATE.AIR:    return "AIR";
        case PLAYER_STATE.DASH:   return "DASH";
        case PLAYER_STATE.HURT:   return "HURT";
        case PLAYER_STATE.ATTACK: return "ATTACK";
        case PLAYER_STATE.ATTACK_MOVE: return "ATTACK_MOVE";
        case PLAYER_STATE.ATTACK_AIR:  return "ATTACK_AIR";
        case PLAYER_STATE.DEAD:   return "DEAD";
        case PLAYER_STATE.WALL_SLIDE: return "WALL_SLIDE";
        case PLAYER_STATE.SWIM:   return "SWIM";
        case PLAYER_STATE.HIDE:   return "HIDE";
        case PLAYER_STATE.SHOOT:  return "SHOOT";
    }
    return "UNKNOWN";
}