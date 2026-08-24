function scr_playerInput()
{
    // =================================================================
    // 1. CAPTURA DE ENTRADAS DE TECLADO
    // =================================================================
    // Teclas Contínuas (Andar/Mover)
    leftKey  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
    rightKey = keyboard_check(vk_right) || keyboard_check(ord("D"));
    downKey  = keyboard_check(vk_down)  || keyboard_check(ord("S"));

    jumpHeld     = keyboard_check(vk_up) || keyboard_check(vk_space) || keyboard_check(ord("W")) || keyboard_check(ord("Z"));
    // Teclas de Ação (Apenas no frame em que são pressionadas)
    // Usar _pressed é crucial para ações instantâneas.
    jumpPressed  = keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("Z"));

    dashPressed  = keyboard_check_pressed(ord("C")) || keyboard_check_pressed(ord("E"));
    attackPressed = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("X"));
    rangedAttackPressed = mouse_check_button_pressed(mb_right) || keyboard_check_pressed(ord("V"));
    interactPressed = keyboard_check_pressed(ord("F"));

    // =================================================================
    // Teclas de Menu e Sistema (Pausa, Inventário e Navegação)
    // =================================================================
    pausePressed = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start);
    inventoryPressed = keyboard_check_pressed(vk_tab) || keyboard_check_pressed(ord("I")) || gamepad_button_check_pressed(0, gp_select);
    
    tabLeftPressed = keyboard_check_pressed(ord("Q")) || gamepad_button_check_pressed(0, gp_shoulderl);
    tabRightPressed = keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_shoulderr);
    
    menuUpPressed = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || gamepad_button_check_pressed(0, gp_padu);
    menuDownPressed = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || gamepad_button_check_pressed(0, gp_padd);
    menuSelectPressed = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0, gp_face1);

    // =================================================================
    // 2. CÁLCULO DE DIREÇÃO BASE (TECLADO)
    // =================================================================
    
    // Define a direção base (1, -1 ou 0)
    inputX = rightKey - leftKey;

    // =========================
    // GAMEPAD (opcional)
    // =========================
    if (gamepad_is_connected(0))
    {
        var padX = gamepad_axis_value(0, gp_axislh);

        // Deadzone manual 
        if (abs(padX) > 0.35)
            inputX = padX;
        //Poderia ser
        //gamepad_set_axis_deadzone(0, 0.35); // 0.35 é um bom valor
        
        // Ações de toque do Gamepad (Combinamos com o teclado ou sobrescrevemos, dependendo da necessidade)
        // Aqui, vamos usar OR Binário (|=) para que o Gamepad OU o Teclado ativem a ação.
        jumpPressed   |= gamepad_button_check_pressed(0, gp_face1);
        dashPressed   |= gamepad_button_check_pressed(0, gp_face2);
        attackPressed |= gamepad_button_check_pressed(0, gp_face3);
    }
    
    /*
     * Held → ação contínua (andar, segurar pulo) 
     * Pressed → ação pontual (pulo, ataque, dash) 
     * inputX → direção desejada, não movimento 
     * teclado e controle alimentam as mesmas variáveis
    */
}
