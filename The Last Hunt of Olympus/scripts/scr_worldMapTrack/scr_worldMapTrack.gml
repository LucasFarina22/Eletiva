// ============================================================
// SISTEMAS DE MUNDO: RASTREAMENTO E RENDERIZAÇÃO DE MAPAS
// ============================================================

/// @function scr_worldMapTrack()
/// @desc Rastreia a célula da grade visitada pelo jogador e a registra no struct de progresso.
function scr_worldMapTrack()
{
    // DIDÁTICO: O jogo divide as salas em uma grade de tamanho 'cellSize' (ex: 256x256 pixels).
    // Conforme o Player anda pela sala, calculamos a célula em que ele está e a marcamos como visitada.
    var roomName = room_get_name(room);
    var p = instance_find(obj_player, 0);
    
    if (p != noone)
    {
        var cellX = floor(p.x / cellSize);
        var cellY = floor(p.y / cellSize);
        
        // Inicializa o mapa da sala no struct se ainda não tiver sido visitado nada nela
        if (!variable_struct_exists(visitedRooms, roomName))
        {
            visitedRooms[$ roomName] = {};
        }
        
        // Marca a célula como visitada usando a chave "X_Y"
        var roomGrid = visitedRooms[$ roomName];
        var cellKey = string(cellX) + "_" + string(cellY);
        roomGrid[$ cellKey] = true;
    }
}

/// @function scr_worldMapDrawMinimap(_player, _visitedRooms, _cellSize, _guiW, _guiH)
/// @desc Renderiza a interface do minimapa de HUD no canto da tela de jogo.
function scr_worldMapDrawMinimap(_player, _visitedRooms, _cellSize, _guiW, _guiH)
{
    // DIDÁTICO: Define as dimensões e a posição do minimapa no canto superior direito
    var mapW = 240;
    var mapH = 240;
    var mapX = _guiW - mapW - 32;
    var mapY = 32;
    
    // 1. Desenha a caixa de fundo preta translúcida do minimapa e sua borda branca
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(mapX, mapY, mapX + mapW, mapY + mapH, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_rectangle(mapX, mapY, mapX + mapW, mapY + mapH, true);
    
    var centerX = mapX + mapW / 2;
    var centerY = mapY + mapH / 2;
    var scale = 0.18; // Escala para desenhar as células do minimapa
    var mapCellSize = _cellSize * scale;
    
    var pCellX = floor(_player.x / _cellSize);
    var pCellY = floor(_player.y / _cellSize);
    
    var roomName = room_get_name(room);
    
    // 2. Loop para varrer e desenhar apenas a vizinhança próxima do jogador (grade 7x7)
    for (var cx = pCellX - 3; cx <= pCellX + 3; cx++)
    {
        for (var cy = pCellY - 3; cy <= pCellY + 3; cy++)
        {
            var isVisited = false;
            // Verifica limites da sala e se a célula atual já foi visitada
            if (cx >= 0 && cy >= 0 && cx * _cellSize < room_width && cy * _cellSize < room_height)
            {
                if (variable_struct_exists(_visitedRooms, roomName))
                {
                    var roomGrid = _visitedRooms[$ roomName];
                    var cellKey = string(cx) + "_" + string(cy);
                    if (variable_struct_exists(roomGrid, cellKey))
                    {
                        isVisited = roomGrid[$ cellKey];
                    }
                }
            }
            
            // 3. Se a célula foi visitada, calcula a posição relativa ao jogador e renderiza
            if (isVisited)
            {
                var worldX = cx * _cellSize;
                var worldY = cy * _cellSize;
                
                var relX = worldX - _player.x;
                var relY = worldY - _player.y;
                
                var mapCellX = centerX + (relX * scale);
                var mapCellY = centerY + (relY * scale);
                
                // Clampa a célula dentro dos limites visuais do minimapa (máscara)
                var drawX1 = max(mapCellX, mapX + 1);
                var drawY1 = max(mapCellY, mapY + 1);
                var drawX2 = min(mapCellX + mapCellSize, mapX + mapW - 1);
                var drawY2 = min(mapCellY + mapCellSize, mapY + mapH - 1);
                
                if (drawX1 < drawX2 && drawY1 < drawY2)
                {
                    // Preenchimento da célula
                    draw_set_color(make_color_rgb(50, 75, 110)); // Azul escuro
                    draw_rectangle(drawX1, drawY1, drawX2, drawY2, false);
                    
                    // Contorno da célula
                    draw_set_color(make_color_rgb(100, 130, 175)); // Azul claro
                    draw_rectangle(drawX1, drawY1, drawX2, drawY2, true);
                }
            }
        }
    }
    
    // 4. Desenha o jogador como um círculo amarelo piscando no centro do minimapa
    var blink = (current_time mod 500 < 250);
    if (blink)
    {
        draw_set_color(c_yellow);
        draw_circle(centerX, centerY, 4, false);
        draw_set_color(c_black);
        draw_circle(centerX, centerY, 4, true);
    }
}

/// @function scr_worldMapDrawFull(_cachedX, _cachedY, _visitedRooms, _cellSize, _guiW, _guiH)
/// @desc Renderiza a tela grande de mapa completo na aba de pausa (TAB).
function scr_worldMapDrawFull(_cachedX, _cachedY, _visitedRooms, _cellSize, _guiW, _guiH)
{
    // DIDÁTICO: Define as coordenadas e área do painel centralizado do mapa ampliado
    var bigMapX = _guiW * 0.5 - 400;
    var bigMapY = _guiH * 0.55 - 200;
    var bigMapW = 800;
    var bigMapH = 400;
    
    // 1. Desenha o fundo preto transparente e borda externa do painel
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_roundrect(bigMapX, bigMapY, bigMapX + bigMapW, bigMapY + bigMapH, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_roundrect(bigMapX, bigMapY, bigMapX + bigMapW, bigMapY + bigMapH, true);
    
    var mapCenterX = bigMapX + bigMapW / 2;
    var mapCenterY = bigMapY + bigMapH / 2;
    
    var totalCellsX = ceil(room_width / _cellSize);
    var totalCellsY = ceil(room_height / _cellSize);
    
    // 2. Calcula dinamicamente o tamanho em pixels de cada célula para caber no grid de 800x400
    var cellDrawSize = min(32, floor((bigMapW - 64) / totalCellsX), floor((bigMapH - 64) / totalCellsY));
    
    var gridW = totalCellsX * cellDrawSize;
    var gridH = totalCellsY * cellDrawSize;
    var gridStartX = mapCenterX - gridW / 2;
    var gridStartY = mapCenterY - gridH / 2;
    
    // Título do Mapa
    draw_set_halign(fa_center);
    draw_set_font(fnt_HUD);
    draw_set_color(c_black);
    draw_text(mapCenterX + 2, bigMapY + 24 + 2, "MAPA DE EXPLORACAO");
    draw_set_color(c_white);
    draw_text(mapCenterX, bigMapY + 24, "MAPA DE EXPLORACAO");
    
    // 3. Rastreia as posições dos checkpoints reativando-os temporariamente (já que o jogo está pausado)
    instance_activate_object(obj_checkpoint);
    var cpCount = instance_number(obj_checkpoint);
    var checkpointsArray = [];
    for (var i = 0; i < cpCount; i++)
    {
        var cp = instance_find(obj_checkpoint, i);
        if (cp != noone)
        {
            array_push(checkpointsArray, { x: cp.x, y: cp.y });
        }
    }
    instance_deactivate_object(obj_checkpoint);
    
    var roomName = room_get_name(room);
    
    // 4. Renderiza toda a grade de células da sala
    for (var cx = 0; cx < totalCellsX; cx++)
    {
        for (var cy = 0; cy < totalCellsY; cy++)
        {
            var cellX1 = gridStartX + cx * cellDrawSize;
            var cellY1 = gridStartY + cy * cellDrawSize;
            var cellX2 = cellX1 + cellDrawSize;
            var cellY2 = cellY1 + cellDrawSize;
            
            var isVisited = false;
            if (variable_struct_exists(_visitedRooms, roomName))
            {
                var roomGrid = _visitedRooms[$ roomName];
                var cellKey = string(cx) + "_" + string(cy);
                if (variable_struct_exists(roomGrid, cellKey))
                {
                    isVisited = roomGrid[$ cellKey];
                }
            }
            
            // Desenha com preenchimento se visitado
            if (isVisited)
            {
                // Célula visitada
                draw_set_color(make_color_rgb(50, 75, 110));
                draw_rectangle(cellX1 + 1, cellY1 + 1, cellX2 - 1, cellY2 - 1, false);
                
                // Borda
                draw_set_color(make_color_rgb(100, 130, 175));
                draw_rectangle(cellX1, cellY1, cellX2, cellY2, true);
                
                // 5. Desenha checkpoints visitados como um símbolo "+" verde no centro da célula
                var cellCenterX = cellX1 + cellDrawSize / 2;
                var cellCenterY = cellY1 + cellDrawSize / 2;
                
                for (var k = 0; k < array_length(checkpointsArray); k++)
                {
                    var cpX = checkpointsArray[k].x;
                    var cpY = checkpointsArray[k].y;
                    if (floor(cpX / _cellSize) == cx && floor(cpY / _cellSize) == cy)
                    {
                        draw_set_color(c_lime);
                        draw_line_width(cellCenterX - 4, cellCenterY, cellCenterX + 4, cellCenterY, 2);
                        draw_line_width(cellCenterX, cellCenterY - 4, cellCenterX, cellCenterY + 4, 2);
                    }
                }
            }
            else
            {
                // Grade cinza para áreas não exploradas (contexto didático da sala)
                draw_set_color(make_color_rgb(30, 30, 40));
                draw_rectangle(cellX1, cellY1, cellX2, cellY2, true);
            }
        }
    }
    
    // 6. Desenha o jogador (círculo amarelo piscante) usando suas coordenadas cacheadas de pausa
    var pCellX = floor(_cachedX / _cellSize);
    var pCellY = floor(_cachedY / _cellSize);
    var pOffsetX = (_cachedX mod _cellSize) / _cellSize;
    var pOffsetY = (_cachedY mod _cellSize) / _cellSize;
    
    var pCellMapX = gridStartX + pCellX * cellDrawSize;
    var pCellMapY = gridStartY + pCellY * cellDrawSize;
    var playerMapX = pCellMapX + pOffsetX * cellDrawSize;
    var playerMapY = pCellMapY + pOffsetY * cellDrawSize;
    
    var isPlayerCellVisited = false;
    if (variable_struct_exists(_visitedRooms, roomName))
    {
        var roomGrid = _visitedRooms[$ roomName];
        var cellKey = string(pCellX) + "_" + string(pCellY);
        if (variable_struct_exists(roomGrid, cellKey))
        {
            isPlayerCellVisited = roomGrid[$ cellKey];
        }
    }
    
    if (isPlayerCellVisited)
    {
        var blink = (current_time mod 500 < 250);
        if (blink)
        {
            draw_set_color(c_yellow);
            draw_circle(playerMapX, playerMapY, 5, false);
            draw_set_color(c_black);
            draw_circle(playerMapX, playerMapY, 5, true);
        }
    }
    
    // Legenda na base do mapa
    draw_set_font(fnt_HUD);
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text(mapCenterX, bigMapY + bigMapH - 30, "LEGENDA:  [+] Checkpoint  |  [*] Amarelo: Voce");
}
