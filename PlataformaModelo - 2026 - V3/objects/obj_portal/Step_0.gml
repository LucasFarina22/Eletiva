// DIDÁTICO: Checa a colisão com o jogador no frame atual.
// Usamos instance_place para detectar a colisão e obter a referência da instância do jogador.
var p = instance_place(x, y, obj_player);

if (p != noone) {
    if (targetRoom != noone && room_exists(targetRoom)) {
        // DIDÁTICO: Atualizamos a posição x e y do jogador na nova sala.
        p.x = targetX;
        p.y = targetY;
        
        // DIDÁTICO: Atualizamos também os pontos de checkpoint para a nova posição.
        // Se fizermos isso, caso o jogador morra na nova sala antes de tocar em um novo
        // checkpoint, ele renascerá de forma segura no início da fase atual, e não no fim da fase anterior!
        p.checkpointX = targetX;
        p.checkpointY = targetY;
        
        // Sincroniza dados com o status persistente imediatamente
        if (instance_exists(obj_playerStats)) {
            obj_playerStats.hp = p.hp;
            obj_playerStats.stamina = p.stamina;
            obj_playerStats.coins = p.coins;
            obj_playerStats.currentLives = p.currentLives;
        }
        
        // Executa a transição física da sala no GameMaker
        room_goto(targetRoom);
    }
}
