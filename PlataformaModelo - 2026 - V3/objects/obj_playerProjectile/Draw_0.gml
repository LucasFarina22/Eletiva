// DIDÁTICO: 1. Desenha o rastro translúcido usando cópias do sprite escalado e atenuado
var len = array_length(trailX);
for (var i = 0; i < len; i++)
{
    var alpha = (1.0 - (i / len)) * 0.4;
    var scale = 1.0 - (i / len) * 0.6;
    draw_sprite_ext(sprite_index, 0, trailX[i], trailY[i], scale, scale, 0, image_blend, alpha);
}

// 2. Desenha o projétil principal
draw_self();
