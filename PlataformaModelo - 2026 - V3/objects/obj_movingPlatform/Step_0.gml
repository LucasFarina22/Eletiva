// DIDÁTICO: O segredo para mover o player perfeitamente é calcular a velocidade (delta) real 
// deste frame baseado na mudança de posição. Assim o player acompanha o Ease-In-Out!

// 1. Detecta se o jogador está em cima da plataforma ANTES de se mover
// (Isso evita que o jogador fique para trás quando a plataforma se move para baixo)
var p = instance_place(x, y - 2, obj_player);

// 2. Salva posições anteriores para calcular a velocidade (hsp e vsp)
var prevX = x;
var prevY = y;

// 3. Atualiza o ângulo de oscilação baseando-se no tempo/velocidade
theta += moveSpeed * 0.02;

// 4. Calcula o offset senoidal (seno oscila de -1 a 1, então normalizamos para 0 a 1)
var offset = (0.5 + 0.5 * sin(theta)) * moveRange;

// 5. Aplica a nova coordenada com base no eixo configurado
if (isHorizontal) {
    x = startX + offset;
} else {
    y = startY + offset;
}

// 6. Calcula a velocidade real deste frame
hsp = x - prevX;
vsp = y - prevY;

// 7. Se o jogador estava em cima, move-o proporcionalmente
if (p != noone) {
    with (p) {
        // DIDÁTICO: Move o jogador horizontalmente respeitando colisões de parede
        if (other.hsp != 0) {
            if (!place_meeting(x + other.hsp, y, colMask)) {
                x += other.hsp;
            } else {
                while (!place_meeting(x + sign(other.hsp), y, colMask)) {
                    x += sign(other.hsp);
                }
            }
        }
        
        // DIDÁTICO: Move o jogador verticalmente respeitando colisões de teto/chão
        if (other.vsp != 0) {
            if (!place_meeting(x, y + other.vsp, colMask)) {
                y += other.vsp;
            } else {
                while (!place_meeting(x, y + sign(other.vsp), colMask)) {
                    y += sign(other.vsp);
                }
            }
        }
    }
}
