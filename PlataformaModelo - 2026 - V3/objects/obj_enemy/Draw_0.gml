// 1. Desenha o próprio sprite do inimigo
draw_self();

// 2. Balões de Alerta/Status (! e ?)
draw_set_font(fnt_HUD);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

var markY = bbox_top - 8;

if (state == ENEMY_STATE.CHASE)
{
    // Desenha exclamação vermelha com contorno preto para visibilidade
    draw_set_color(c_black);
    draw_text(x + 1, markY + 1, "!");
    draw_text(x - 1, markY + 1, "!");
    draw_text(x + 1, markY - 1, "!");
    draw_text(x - 1, markY - 1, "!");
    
    draw_set_color(c_red);
    draw_text(x, markY, "!");
}
else if (state == ENEMY_STATE.ALERT)
{
    // Desenha interrogação amarela com contorno preto para visibilidade
    draw_set_color(c_black);
    draw_text(x + 1, markY + 1, "?");
    draw_text(x - 1, markY + 1, "?");
    draw_text(x + 1, markY - 1, "?");
    draw_text(x - 1, markY - 1, "?");
    
    draw_set_color(c_yellow);
    draw_text(x, markY, "?");
}

// Reseta o alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// 3. Cone de Visão de Depuração (Apenas se o jogador estiver em modo debug)
var p = instance_find(obj_player, 0);
if (p != noone && p.debugMode)
{
    var faceDir = (image_xscale == 1) ? 0 : 180;
    
    // Calcula pontos limite do cone de visão
    var x1 = x + lengthdir_x(visionRange, faceDir - visionCone);
    var y1 = (y - 16) + lengthdir_y(visionRange, faceDir - visionCone);
    var x2 = x + lengthdir_x(visionRange, faceDir + visionCone);
    var y2 = (y - 16) + lengthdir_y(visionRange, faceDir + visionCone);
    
    var coneColor = (state == ENEMY_STATE.CHASE) ? c_red : c_orange;
    
    // Desenha o triângulo preenchido translúcido
    draw_set_alpha(0.12);
    draw_set_color(coneColor);
    draw_triangle(x, y - 16, x1, y1, x2, y2, false);
    
    // Desenha as bordas do triângulo
    draw_set_alpha(0.45);
    draw_line_width_color(x, y - 16, x1, y1, 2, coneColor, coneColor);
    draw_line_width_color(x, y - 16, x2, y2, 2, coneColor, coneColor);
    draw_line_width_color(x1, y1, x2, y2, 2, coneColor, coneColor);
    
    // Desenha linha de Raycast direta até o jogador
    var wallHit = collision_line(x, y - 16, p.x, p.y - 16, colMask, false, true);
    var rayColor = (wallHit == noone) ? c_lime : c_red;
    
    draw_set_alpha(0.7);
    draw_line_width_color(x, y - 16, p.x, p.y - 16, 1.5, rayColor, rayColor);
    draw_circle_color(p.x, p.y - 16, 4, rayColor, rayColor, false);
    
    // Restaura o alpha padrão
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
