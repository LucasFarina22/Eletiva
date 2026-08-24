// ============================================================
// INICIALIZAÇÃO DE VARIÁVEIS DA GUI, PAUSE E INVENTÁRIO
// ============================================================

// Estado do pause: 0 = Jogando, 1 = Configurações/Pausa (ESC), 2 = Inventário/Mapa (TAB)
pauseType = 0;
pauseSprite = -1;

// Sistema de Mapa (Grade Metroidvania)
cellSize = 256;
visitedRooms = {};

// Opções do menu de pausa (Configurações)
menuOptions = ["Retornar", "Reiniciar", "Sair"];
menuIndex = 0;

// Navegação de Abas do Menu de Inventário/Mapa
currentTab = 0; // 0 = Inventário, 1 = Mapa
tabNames = ["INVENTARIO", "MAPA"];

// Sistema de Inventário (Array de structs)
inventory = [
    { name: "Poção de Vida", description: "Poção vermelha. Recupera 25 HP.", quantity: 1 }
];

// Função para adicionar itens ao inventário (com acumulação de quantidade)
addItem = function(_name, _desc, _qty)
{
    var _len = array_length(inventory);
    for (var i = 0; i < _len; i++)
    {
        if (inventory[i].name == _name)
        {
            inventory[i].quantity += _qty;
            return;
        }
    }
    
    array_push(inventory, {
        name: _name,
        description: _desc,
        quantity: _qty
    });
}

// Valores cacheados do Player para desenho da HUD em pause e sincronização
cachedHp = 100;
cachedHpMax = 100;
cachedStamina = 100;
cachedStaminaMax = 100;
cachedLives = 3;
cachedCoins = 0;
cachedDebug = false;
cachedX = 0;
cachedY = 0;

// Caches de upgrades
cachedHasDoubleJump = false;
cachedHasAttack = false;
cachedHasRangedAttack = false;
cachedHasWallSlide = false;
cachedHasWallJump = false;

// Estrutura da loja de checkpoint
shopUpgrades = [
    { name: "Pulo Duplo", key: "DoubleJump", price: 15, desc: "Permite realizar um segundo pulo no ar." },
    { name: "Ataque Fisico", key: "Attack", price: 10, desc: "Permite usar ataques fisicos com a espada." },
    { name: "Ataque a Distancia", key: "RangedAttack", price: 25, desc: "Atira esferas de energia (Consome 15 Stamina)." },
    { name: "Deslizamento na Parede", key: "WallSlide", price: 15, desc: "Deslize pelas paredes ao segurar na direcao delas." },
    { name: "Pulo na Parede", key: "WallJump", price: 20, desc: "Pule a partir de paredes (Requer Deslizamento)." }
];
shopIndex = 0;
