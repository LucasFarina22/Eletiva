// Aplica dano contínuo e joga o player para cima ao tocar no ácido
var p = instance_place(x, y, obj_player);
if (p != noone && p.state != PLAYER_STATE.DEAD)
{
    if (p.invTime <= 0)
    {
        with (p)
        {
            scr_playerTakeDamage(0, 15); // Dano pesado de ácido
            vsp = -6.0; // Impulso vertical para ajudar a escapar
        }
    }
    else
    {
        // Se já está invencível (recebendo dano), empurra mesmo assim para ele não afundar passivamente
        p.vsp = -6.0;
    }
}
