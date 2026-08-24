function scr_playerAttackMoveState()
{
    // Permite movimentação horizontal no chão
    scr_playerMove();

    // Cria a hitbox só no primeiro frame do ataque
    if (attackTime == attackTimeMax)
    {
        var hit = instance_create_layer(x + (image_xscale * 32), y, "Instances", obj_playerAttackHitbox);
        hit.creator = id;
        hit.damage = attackDamage;
        hit.image_xscale = image_xscale;
    }

    // Transição se o jogador parar de se mover
    if (inputX == 0)
    {
        state = PLAYER_STATE.ATTACK;
    }
    // Transição se o jogador cair de uma plataforma
    else if (!grounded)
    {
        state = PLAYER_STATE.ATTACK_AIR;
    }
    // Pulo durante o ataque em movimento
    else if (jumpPressed)
    {
        vsp = jspd;
        grounded = false;
        jumpCount--;
        state = PLAYER_STATE.ATTACK_AIR;
    }

    attackTime--;

    if (attackTime <= 0)
    {
        isAttacking = false;
        state = grounded ? PLAYER_STATE.GROUND : PLAYER_STATE.AIR;
        return;
    }
}
