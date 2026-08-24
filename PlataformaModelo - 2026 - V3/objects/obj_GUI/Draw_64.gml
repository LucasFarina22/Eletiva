// ============================================================
// RENDERIZAÇÃO DA GUI, HUD E MENUS
// ============================================================

var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

// ------------------------------------------------------------
// CASO 1: JOGO RODANDO NORMALMENTE
// ------------------------------------------------------------
if (pauseType == 0)
{
    var p = instance_find(obj_player, 0);
    if (p != noone)
    {
        scr_drawHUD(p);

        if (p.debugMode)
        {
            scr_drawDebug(p);
            draw_text(32, 160, "DEBUG: ON (F1 para alternar)");
        }
        else 
        {
            draw_text(32, 160, "DEBUG: OFF (F1 para alternar)");
        }
        
        // ============================================================
        // MINIMAPA (Gameplay) - DELEGADO
        // ============================================================
        // DIDÁTICO: Chamamos a função de desenho do minimapa extraída para o script de sistemas do mundo.
        scr_worldMapDrawMinimap(p, visitedRooms, cellSize, guiW, guiH);
    }
}
// ------------------------------------------------------------
// CASO 2: MENUS DE PAUSA ATIVOS
// ------------------------------------------------------------
else
{
    // 1. Desenha o fundo congelado capturado
    if (sprite_exists(pauseSprite))
    {
        draw_sprite_stretched(pauseSprite, 0, 0, 0, guiW, guiH);
    }
    
    // 2. Aplica filtro de escurecimento translúcido
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(0, 0, guiW, guiH, false);
    draw_set_alpha(1.0);
    
    // 3. Desenha a HUD usando os valores cacheados
    var hudData = {
        hp: cachedHp,
        hp_max: cachedHpMax,
        stamina: cachedStamina,
        stamina_max: cachedStaminaMax,
        currentLives: cachedLives,
        coins: cachedCoins
    };
    scr_drawHUD(hudData);
    
    if (cachedDebug)
    {
        draw_set_font(fnt_HUD);
        draw_set_color(c_yellow);
        draw_text(32, 160, "DEBUG: CONGELADO EM PAUSE");
    }
    
    // ------------------------------------------------------------
    // SEÇÃO A: MENU DE PAUSA (ESC)
    // ------------------------------------------------------------
    if (pauseType == 1)
    {
        draw_set_font(fnt_HUD);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Título do Menu
        draw_set_color(c_black);
        draw_text(guiW * 0.5 + 2, guiH * 0.3 + 2, "MENU DE PAUSA");
        draw_set_color(c_white);
        draw_text(guiW * 0.5, guiH * 0.3, "MENU DE PAUSA");
        
        // Opções
        var menuSize = array_length(menuOptions);
        var startY = guiH * 0.45;
        var spacing = 48;
        
        for (var i = 0; i < menuSize; i++)
        {
            var textY = startY + (i * spacing);
            var textStr = menuOptions[i];
            
            if (i == menuIndex)
            {
                draw_set_color(c_yellow);
                textStr = "> " + textStr + " <";
            }
            else
            {
                draw_set_color(c_white);
            }
            
            // Sombra da opção
            var curColor = draw_get_color();
            draw_set_color(c_black);
            draw_text(guiW * 0.5 + 2, textY + 2, textStr);
            
            draw_set_color(curColor);
            draw_text(guiW * 0.5, textY, textStr);
        }
    }
    // ------------------------------------------------------------
    // SEÇÃO B: TELA DE INVENTÁRIO E MAPA (TAB)
    // ------------------------------------------------------------
    else if (pauseType == 2)
    {
        draw_set_font(fnt_HUD);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Desenha Cabeçalho de Abas
        var tabY = guiH * 0.15;
        
        // Dica de navegação
        draw_set_color(c_gray);
        draw_text(guiW * 0.5, tabY - 24, "Q / E para alternar abas");
        
        // Abas
        var tabW = 200;
        var tabStartX = guiW * 0.5 - (tabW * 0.5);
        
        for (var i = 0; i < array_length(tabNames); i++)
        {
            var tabX = tabStartX + (i * tabW) - (tabW * 0.5 * (array_length(tabNames) - 1));
            var tabStr = tabNames[i];
            
            if (i == currentTab)
            {
                draw_set_color(c_yellow);
                tabStr = "[ " + tabStr + " ]";
            }
            else
            {
                draw_set_color(c_white);
            }
            
            // Sombra da aba
            var curColor = draw_get_color();
            draw_set_color(c_black);
            draw_text(tabX + 2, tabY + 2, tabStr);
            
            draw_set_color(curColor);
            draw_text(tabX, tabY, tabStr);
        }
        
        // Linha divisória abaixo das abas
        draw_set_color(c_white);
        draw_line_width(guiW * 0.2, tabY + 20, guiW * 0.8, tabY + 20, 2);
        
        // ABA 0: INVENTÁRIO
        if (currentTab == 0)
        {
            var invSize = array_length(inventory);
            var itemStartY = guiH * 0.3;
            var itemSpacing = 36;
            
            draw_set_halign(fa_left);
            
            if (invSize > 0)
            {
                for (var i = 0; i < invSize; i++)
                {
                    var itemY = itemStartY + (i * itemSpacing);
                    var item = inventory[i];
                    var itemText = item.name + " x" + string(item.quantity);
                    
                    // DIDÁTICO: Desenha o sprite da poção de vida com escala ampliada de 1x para melhor visibilidade na interface
                    if (item.name == "Poção de Vida")
                    {
                        var iconX = guiW * 0.26;
                        var potScale = 1;
                        // Centraliza verticalmente e horizontalmente o sprite (que tem origem 0,0) em relação a iconX e itemY
                        var drawY = itemY - (32 * potScale) / 2;
                        var drawX = iconX - (32 * potScale) / 2;
                        draw_sprite_ext(spr_potion, 0, drawX, drawY, potScale, potScale, 0, c_white, 1);
                    }
                    
                    if (i == menuIndex)
                    {
                        draw_set_color(c_yellow);
                        itemText = "-> " + itemText;
                    }
                    else
                    {
                        draw_set_color(c_white);
                    }
                    
                    // Sombra do texto do item
                    var curColor = draw_get_color();
                    draw_set_color(c_black);
                    draw_text(guiW * 0.3 + 2, itemY + 2, itemText);
                    
                    draw_set_color(curColor);
                    draw_text(guiW * 0.3, itemY, itemText);
                }
                
                // Desenhar painel de descrição do item selecionado na parte inferior
                draw_set_halign(fa_center);
                var descY = guiH * 0.75;
                var selectedItem = inventory[menuIndex];
                
                // Caixa de fundo para a descrição
                draw_set_color(c_black);
                draw_set_alpha(0.5);
                draw_roundrect(guiW * 0.2, descY - 20, guiW * 0.8, descY + 40, false);
                draw_set_alpha(1.0);
                draw_set_color(c_white);
                draw_roundrect(guiW * 0.2, descY - 20, guiW * 0.8, descY + 40, true);
                
                // Texto de descrição
                var descText = selectedItem.description;
                if (selectedItem.name == "Poção de Vida")
                {
                    descText += " (Pressione [Enter/Espaço] para consumir)";
                }
                
                draw_set_color(c_black);
                draw_text(guiW * 0.5 + 1, descY + 11, descText);
                draw_set_color(c_white);
                draw_text(guiW * 0.5, descY + 10, descText);
            }
            else
            {
                draw_set_halign(fa_center);
                draw_set_color(c_gray);
                draw_text(guiW * 0.5, guiH * 0.45, "INVENTARIO VAZIO");
            }
        }
        // ABA 1: MAPA (DELEGADO)
        else if (currentTab == 1)
        {
            // DIDÁTICO: Delega a renderização do mapa expandido de exploração para a função global no script scr_worldSystems.
            scr_worldMapDrawFull(cachedX, cachedY, visitedRooms, cellSize, guiW, guiH);
        }
    }
    // ------------------------------------------------------------
    // SEÇÃO C: LOJA DE CHECKPOINT (pauseType == 3)
    // ------------------------------------------------------------
    else if (pauseType == 3)
    {
        draw_set_font(fnt_HUD);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Título da Loja
        draw_set_color(c_black);
        draw_text(guiW * 0.5 + 2, guiH * 0.15 + 2, "LOJA DE CHECKPOINT");
        draw_set_color(c_white);
        draw_text(guiW * 0.5, guiH * 0.15, "LOJA DE CHECKPOINT");
        
        // Moedas atuais
        draw_set_color(c_yellow);
        var coinsStr = "Moedas: " + string(cachedCoins);
        draw_text(guiW * 0.5, guiH * 0.22, coinsStr);
        
        // Dica de navegação
        draw_set_color(c_gray);
        draw_text(guiW * 0.5, guiH * 0.27, "Cima / Baixo para selecionar | Enter para comprar");
        
        // Opções da Loja
        var shopSize = array_length(shopUpgrades);
        var startY = guiH * 0.35;
        var spacing = 45;
        
        for (var i = 0; i <= shopSize; i++)
        {
            var textY = startY + (i * spacing);
            var textStr = "";
            var isSelected = (i == shopIndex);
            
            if (i == shopSize)
            {
                // Opção de Sair
                textStr = "Sair da Loja";
                if (isSelected)
                {
                    draw_set_color(c_yellow);
                    textStr = "> " + textStr + " <";
                }
                else
                {
                    draw_set_color(c_white);
                }
            }
            else
            {
                // Item da Loja
                var upgrade = shopUpgrades[i];
                var alreadyOwned = false;
                if (upgrade.key == "DoubleJump") alreadyOwned = cachedHasDoubleJump;
                else if (upgrade.key == "Attack") alreadyOwned = cachedHasAttack;
                else if (upgrade.key == "RangedAttack") alreadyOwned = cachedHasRangedAttack;
                else if (upgrade.key == "WallSlide") alreadyOwned = cachedHasWallSlide;
                else if (upgrade.key == "WallJump") alreadyOwned = cachedHasWallJump;
                
                var statusStr = "";
                if (alreadyOwned)
                {
                    statusStr = "[Adquirido]";
                }
                else
                {
                    statusStr = "(" + string(upgrade.price) + " Moedas)";
                }
                
                textStr = upgrade.name + " - " + statusStr;
                
                if (isSelected)
                {
                    draw_set_color(c_yellow);
                    textStr = "-> " + textStr + " <-";
                }
                else
                {
                    if (alreadyOwned)
                    {
                        draw_set_color(c_gray);
                    }
                    else if (cachedCoins >= upgrade.price)
                    {
                        draw_set_color(c_white);
                    }
                    else
                    {
                        draw_set_color(c_red); // não pode comprar
                    }
                }
            }
            
            // Sombra
            var curColor = draw_get_color();
            draw_set_color(c_black);
            draw_text(guiW * 0.5 + 2, textY + 2, textStr);
            
            draw_set_color(curColor);
            draw_text(guiW * 0.5, textY, textStr);
        }
        
        // Caixa de Descrição na parte inferior
        var descY = guiH * 0.8;
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_roundrect(guiW * 0.15, descY - 20, guiW * 0.85, descY + 40, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_roundrect(guiW * 0.15, descY - 20, guiW * 0.85, descY + 40, true);
        
        var descText = "";
        if (shopIndex == shopSize)
        {
            descText = "Retorna para o jogo.";
        }
        else
        {
            descText = shopUpgrades[shopIndex].desc;
        }
        
        draw_set_color(c_black);
        draw_text(guiW * 0.5 + 1, descY + 11, descText);
        draw_set_color(c_white);
        draw_text(guiW * 0.5, descY + 10, descText);
    }
    
    // Reseta alinhamento e cores padrão do GameMaker
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}