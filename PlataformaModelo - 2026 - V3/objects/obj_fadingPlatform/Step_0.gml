// DIDÁTICO: A oscilação senoidal do image_alpha cria um efeito suave de sumir e aparecer.
// Multiplicamos o seno por 1.8 e adicionamos 0.5 para saturar os extremos,
// deixando a plataforma 100% sólida por um tempo e 100% invisível por outro,
// em vez de passar a maior parte do tempo semi-transparente.
theta += fadeSpeed;
var raw_sin = sin(theta);
image_alpha = clamp(raw_sin * 1.8 + 0.5, 0, 1);

// DIDÁTICO: A forma profissional de desativar colisões no GameMaker sem mover as
// coordenadas do objeto é trocar seu mask_index. Se a opacidade for menor que 0.1,
// ela fica intangível (usando a máscara vazia) e o jogador cai através dela.
if (image_alpha <= 0.1) {
    mask_index = spr_empty_mask;
} else {
    mask_index = -1; // Restaura a colisão padrão baseada no sprite_index
}
