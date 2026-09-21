function scr_playerAttackAirState()
{
    // Permite movimentação horizontal no ar (controle reduzido)
    scr_playerMove();

    // Cria a hitbox só no primeiro frame do ataque
    if (attackTime == attackTimeMax)
    {
        var hit = instance_create_layer(x + (image_xscale * 32), y, "Instances", obj_playerAttackHitbox);
        hit.creator = id;
        hit.damage = attackDamage;
        hit.image_xscale = image_xscale;
    }

    // Transição ao tocar no chão
    if (grounded)
    {
        state = (inputX == 0) ? PLAYER_STATE.ATTACK : PLAYER_STATE.ATTACK_MOVE;
    }

    attackTime--;

    if (attackTime <= 0)
    {
        isAttacking = false;
        state = grounded ? PLAYER_STATE.GROUND : PLAYER_STATE.AIR;
        return;
    }
}
