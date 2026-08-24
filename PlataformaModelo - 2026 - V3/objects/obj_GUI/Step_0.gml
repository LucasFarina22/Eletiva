// ============================================================
// LOGICA DE PAUSE, ABAS E INVENTÁRIO
// ============================================================

// Executa o script de leitura de inputs para ler as teclas mapeadas
scr_playerInput();

// 1. Estados de Transição (Abrindo os menus a partir da gameplay)
if (pauseType == 0)
{
    // RASTREAMENTO DO MAPA (GRADE VISITADA)
    // DIDÁTICO: Chamamos a função do script de sistemas do mundo para mapear o progresso de exploração.
    scr_worldMapTrack();

    if (pausePressed)
    {
        // Cacheia os dados do jogador
        var p = instance_find(obj_player, 0);
        if (p != noone)
        {
            cachedHp = p.hp;
            cachedHpMax = p.hp_max;
            cachedStamina = p.stamina;
            cachedStaminaMax = p.stamina_max;
            cachedLives = p.currentLives;
            cachedCoins = p.coins;
            cachedDebug = p.debugMode;
            cachedX = p.x;
            cachedY = p.y;
        }
        
        // Captura a tela atual na surface
        var width = surface_get_width(application_surface);
        var height = surface_get_height(application_surface);
        if (width > 0 && height > 0)
        {
            if (sprite_exists(pauseSprite)) sprite_delete(pauseSprite);
            pauseSprite = sprite_create_from_surface(application_surface, 0, 0, width, height, false, false, 0, 0);
        }
        
        // Define o estado para Pausa (ESC)
        pauseType = 1;
        menuIndex = 0;
        
        // Congela o resto do jogo
        instance_deactivate_all(true);
    }
    else if (inventoryPressed)
    {
        // Cacheia os dados do jogador
        var p = instance_find(obj_player, 0);
        if (p != noone)
        {
            cachedHp = p.hp;
            cachedHpMax = p.hp_max;
            cachedStamina = p.stamina;
            cachedStaminaMax = p.stamina_max;
            cachedLives = p.currentLives;
            cachedCoins = p.coins;
            cachedDebug = p.debugMode;
            cachedX = p.x;
            cachedY = p.y;
        }
        
        // Captura a tela
        var width = surface_get_width(application_surface);
        var height = surface_get_height(application_surface);
        if (width > 0 && height > 0)
        {
            if (sprite_exists(pauseSprite)) sprite_delete(pauseSprite);
            pauseSprite = sprite_create_from_surface(application_surface, 0, 0, width, height, false, false, 0, 0);
        }
        
        // Define o estado para Inventário/Mapa (TAB)
        pauseType = 2;
        currentTab = 0; // Abre direto na aba de Inventário
        menuIndex = 0;
        
        // Congela o resto do jogo
        instance_deactivate_all(true);
    }
    else if (interactPressed)
    {
        var p = instance_find(obj_player, 0);
        // DIDÁTICO: A verificação de proximidade foi expandida para 64 pixels e o grounded 
        // foi tornado mais robusto checando também colisão com blocos diretamente abaixo,
        // garantindo que o jogador consiga abrir a loja sem travar.
        if (p != noone && (p.grounded || place_meeting(p.x, p.y + 1, obj_wall)))
        {
            var cp = instance_nearest(p.x, p.y, obj_checkpoint);
            if (cp != noone && point_distance(p.x, p.y, cp.x + 16, cp.y + 16) < 64)
            {
                // Cacheia os dados do jogador
                cachedHp = p.hp;
                cachedHpMax = p.hp_max;
                cachedStamina = p.stamina;
                cachedStaminaMax = p.stamina_max;
                cachedLives = p.currentLives;
                cachedCoins = p.coins;
                cachedDebug = p.debugMode;
                cachedX = p.x;
                cachedY = p.y;
                
                cachedHasDoubleJump = p.hasDoubleJump;
                cachedHasAttack = p.hasAttack;
                cachedHasRangedAttack = p.hasRangedAttack;
                cachedHasWallSlide = p.hasWallSlide;
                cachedHasWallJump = p.hasWallJump;
                
                // Captura a tela atual na surface
                var width = surface_get_width(application_surface);
                var height = surface_get_height(application_surface);
                if (width > 0 && height > 0)
                {
                    if (sprite_exists(pauseSprite)) sprite_delete(pauseSprite);
                    pauseSprite = sprite_create_from_surface(application_surface, 0, 0, width, height, false, false, 0, 0);
                }
                
                // Define o estado para Loja (3)
                pauseType = 3;
                shopIndex = 0;
                
                // Congela o resto do jogo
                instance_deactivate_all(true);
            }
        }
    }
}
// 2. Menu de Pausa Simples (ESC)
else if (pauseType == 1)
{
    // Sair ou alternar de volta para o jogo
    if (pausePressed || inventoryPressed)
    {
        pauseType = 0;
        instance_activate_all();
        
        // Sincroniza dados com o Player reativado
        var p = instance_find(obj_player, 0);
        if (p != noone)
        {
            p.hp = cachedHp;
            p.stamina = cachedStamina;
            p.currentLives = cachedLives;
            p.coins = cachedCoins;
        }
        
        if (sprite_exists(pauseSprite))
        {
            sprite_delete(pauseSprite);
            pauseSprite = -1;
        }
    }
    
    // Navegação simples do menu
    var menuSize = array_length(menuOptions);
    if (menuUpPressed)
    {
        menuIndex--;
        if (menuIndex < 0) menuIndex = menuSize - 1;
    }
    if (menuDownPressed)
    {
        menuIndex++;
        if (menuIndex >= menuSize) menuIndex = 0;
    }
    
    if (menuSelectPressed)
    {
        switch (menuOptions[menuIndex])
        {
            case "Retornar":
                pauseType = 0;
                instance_activate_all();
                
                var p = instance_find(obj_player, 0);
                if (p != noone)
                {
                    p.hp = cachedHp;
                    p.stamina = cachedStamina;
                    p.currentLives = cachedLives;
                    p.coins = cachedCoins;
                }
                
                if (sprite_exists(pauseSprite))
                {
                    sprite_delete(pauseSprite);
                    pauseSprite = -1;
                }
                break;
                
            case "Reiniciar":
                pauseType = 0;
                instance_activate_all();
                if (sprite_exists(pauseSprite))
                {
                    sprite_delete(pauseSprite);
                    pauseSprite = -1;
                }
                room_restart();
                break;
                
            case "Sair":
                game_end();
                break;
        }
    }
}
// 3. Tela de Inventário/Mapa (TAB)
else if (pauseType == 2)
{
    // Fecha o menu de volta ao jogo
    if (inventoryPressed || pausePressed)
    {
        pauseType = 0;
        instance_activate_all();
        
        // Sincroniza dados com o Player
        var p = instance_find(obj_player, 0);
        if (p != noone)
        {
            p.hp = cachedHp;
            p.stamina = cachedStamina;
            p.currentLives = cachedLives;
            p.coins = cachedCoins;
        }
        
        if (sprite_exists(pauseSprite))
        {
            sprite_delete(pauseSprite);
            pauseSprite = -1;
        }
    }
    
    // Troca de Abas (Q e E)
    if (tabLeftPressed)
    {
        currentTab--;
        if (currentTab < 0) currentTab = array_length(tabNames) - 1;
        menuIndex = 0; // Reseta seleção interna da aba
    }
    if (tabRightPressed)
    {
        currentTab++;
        if (currentTab >= array_length(tabNames)) currentTab = 0;
        menuIndex = 0; // Reseta seleção interna da aba
    }
    
    // Controles internos de cada aba
    if (currentTab == 0) // Aba de Inventário
    {
        var invSize = array_length(inventory);
        if (invSize > 0)
        {
            if (menuUpPressed)
            {
                menuIndex--;
                if (menuIndex < 0) menuIndex = invSize - 1;
            }
            if (menuDownPressed)
            {
                menuIndex++;
                if (menuIndex >= invSize) menuIndex = 0;
            }
            
            // Usar o item selecionado (ex: Poção de Vida)
            if (menuSelectPressed)
            {
                var item = inventory[menuIndex];
                if (item.name == "Poção de Vida")
                {
                    if (cachedHp < cachedHpMax)
                    {
                        cachedHp = min(cachedHp + 25, cachedHpMax);
                        item.quantity--;
                        
                        // Se esgotar a poção, remove-a do inventário
                        if (item.quantity <= 0)
                        {
                            array_delete(inventory, menuIndex, 1);
                            menuIndex = max(0, menuIndex - 1);
                        }
                    }
                }
            }
        }
        else
        {
            menuIndex = 0;
        }
    }
}
// 4. Loja de Upgrades nos Checkpoints (pauseType == 3)
else if (pauseType == 3)
{
    // Sair da loja ao apertar ESC ou F
    if (pausePressed || interactPressed)
    {
        pauseType = 0;
        instance_activate_all();
        
        var p = instance_find(obj_player, 0);
        if (p != noone)
        {
            p.hp = cachedHp;
            p.stamina = cachedStamina;
            p.currentLives = cachedLives;
            p.coins = cachedCoins;
            
            p.hasDoubleJump = cachedHasDoubleJump;
            p.hasAttack = cachedHasAttack;
            p.hasRangedAttack = cachedHasRangedAttack;
            p.hasWallSlide = cachedHasWallSlide;
            p.hasWallJump = cachedHasWallJump;
        }
        
        if (sprite_exists(pauseSprite))
        {
            sprite_delete(pauseSprite);
            pauseSprite = -1;
        }
        exit;
    }
    
    // Navegação na Loja (Itens + Opção de Sair)
    var shopSize = array_length(shopUpgrades) + 1; // +1 para "Sair da Loja"
    if (menuUpPressed)
    {
        shopIndex--;
        if (shopIndex < 0) shopIndex = shopSize - 1;
    }
    if (menuDownPressed)
    {
        shopIndex++;
        if (shopIndex >= shopSize) shopIndex = 0;
    }
    
    // Confirmação de Compra ou Saída
    if (menuSelectPressed)
    {
        if (shopIndex == array_length(shopUpgrades)) // Opção "Sair"
        {
            pauseType = 0;
            instance_activate_all();
            
            var p = instance_find(obj_player, 0);
            if (p != noone)
            {
                p.hp = cachedHp;
                p.stamina = cachedStamina;
                p.currentLives = cachedLives;
                p.coins = cachedCoins;
                
                p.hasDoubleJump = cachedHasDoubleJump;
                p.hasAttack = cachedHasAttack;
                p.hasRangedAttack = cachedHasRangedAttack;
                p.hasWallSlide = cachedHasWallSlide;
                p.hasWallJump = cachedHasWallJump;
            }
            
            if (sprite_exists(pauseSprite))
            {
                sprite_delete(pauseSprite);
                pauseSprite = -1;
            }
            exit;
        }
        else // Upgrade selecionado
        {
            var upgrade = shopUpgrades[shopIndex];
            
            // Verifica posse atual
            var alreadyOwned = false;
            if (upgrade.key == "DoubleJump") alreadyOwned = cachedHasDoubleJump;
            else if (upgrade.key == "Attack") alreadyOwned = cachedHasAttack;
            else if (upgrade.key == "RangedAttack") alreadyOwned = cachedHasRangedAttack;
            else if (upgrade.key == "WallSlide") alreadyOwned = cachedHasWallSlide;
            else if (upgrade.key == "WallJump") alreadyOwned = cachedHasWallJump;
            
            // Tenta efetuar a compra
            if (!alreadyOwned && cachedCoins >= upgrade.price)
            {
                cachedCoins -= upgrade.price;
                
                if (upgrade.key == "DoubleJump") cachedHasDoubleJump = true;
                else if (upgrade.key == "Attack") cachedHasAttack = true;
                else if (upgrade.key == "RangedAttack") cachedHasRangedAttack = true;
                else if (upgrade.key == "WallSlide") cachedHasWallSlide = true;
                else if (upgrade.key == "WallJump") cachedHasWallJump = true;
            }
        }
    }
}
