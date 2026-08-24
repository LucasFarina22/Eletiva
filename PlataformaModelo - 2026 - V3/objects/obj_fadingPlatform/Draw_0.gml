// Desenha a plataforma com seu alpha normal controlado pelo Step
draw_self();

// DIDÁTICO: Detalhe estético premium: desenha um contorno de cristal ciano suave (ghost image)
// quando ela estiver intangível (alpha baixo) para que o jogador ainda consiga ver onde ela está
// e possa se posicionar e calcular o tempo correto para o pulo.
if (image_alpha < 0.25) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_aqua, 0.15);
}
