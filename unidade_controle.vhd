LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity unidade_controle is
    Port(
        clk, reset: in std_logic;
        n_flag, z_flag: in std_logic;
        instruc: in std_logic_vector (7 downto 0);

        cargaacc, incPC, cargaPC, cargaREM, sel, cargaRI, cargaNZ, wr, rd: out std_logic;
        selULA: out std_logic_vector (2 downto 0);
    );
end unidade_controle;

architecture Behavioral of unidade_controle is
    
    type temp is (t0, t1, t2, t3, t4, t5, t6, t7, Halt);

    signal inst_atual: std_logic_vector (7 downto 0);
    signal temp_atual, temp_prox: temp;

    constant STA: std_logic_vector (7 downto 0) := "00010000";
    constant LDA: std_logic_vector (7 downto 0) := "00100000";
    constant ADD: std_logic_vector (7 downto 0) := "00110000";
    constant OR_: std_logic_vector (7 downto 0) := "01000000";
    constant AND_: std_logic_vector (7 downto 0) := "01010000";
    constant NOT_: std_logic_vector (7 downto 0) := "01100000";
    constant JMP: std_logic_vector (7 downto 0) := "10000000";
    constant JN: std_logic_vector (7 downto 0) := "10010000";
    constant JZ: std_logic_vector (7 downto 0) := "10100000";
    constant NOP: std_logic_vector (7 downto 0) := "00000000";
    constant HLT: std_logic_vector (7 downto 0) := "11110000";

begin
    process(clk, reset)
    begin
        if (reset = '1') then
            temp_atual <=  t0;
        else
            if (rising_edge(clk)) then
                if (temp_prox = t0) then
                    inst_atual <= instruc;
                else
                    --inst_atual <= inst_prox;
                    temp_atual <= temp_prox;
                end if;
            end if;
        end if;
    end process;

    process(inst_atual, temp_atual)
    begin
        case (temp_atual) is
            when t0 =>
                cargaacc <= '0';
                incPC <= '0';
                cargaPC <= '0';
                sel <= '0';
                cargaRI <= '0'; 
                cargaREM <= '1';
                cargaNZ <= '0';
                selULA <= "000";
                wr <= '0';
                rd <= '0';

                temp_prox <= t1;
            when t1 =>
                cargaacc <= '0'; 
                incPC <= '1'; 
                cargaPC <= '0'; 
                cargaREM <= '0'; 
                sel <= '0'; 
                cargaRI <= '0'; 
                cargaNZ <= '0'; 
                selULA <= "000"; 
                wr <= '0'; 
                rd <= '1';
                
                temp_prox <= t2;
            when t2 =>
                cargaacc <= '0'; 
                incPC <= '0'; 
                cargaPC <= '0'; 
                cargaREM <= '0'; 
                sel <= '0'; 
                cargaRI <= '1'; 
                cargaNZ <= '0'; 
                selULA <= "000"; 
                wr <= '0'; 
                rd <= '0';
                
                temp_prox <= t3;
            when t3 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ or JMP =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '1'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                        temp_prox <= t4;
                    when NOT_ =>
                        cargaacc <= '1'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '1'; 
                        selULA <= "011"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                        temp_prox <= t0;
                    when JN =>
                        if (n_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '0'; 
                            cargaREM <= '1'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t4;
                        else
                            cargaacc <= '0'; 
                            incPC <= '1'; 
                            cargaPC <= '0'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t0;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '0'; 
                            cargaREM <= '1'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t4;
                        else
                            cargaacc <= '0'; 
                            incPC <= '1'; 
                            cargaPC <= '0'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t0;
                        end if;
                    when NOP =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '0';

                        temp_prox <= t0;
                    when HLT =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000";
                        wr <= '0'; 
                        rd <= '0';

                        temp_prox <= Halt;
                end case;
            when t4 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ =>
                        cargaacc <= '0'; 
                        incPC <= '1'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '1';
                        
                        temp_prox <= t5;
                    when JMP =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '1';
                        
                        temp_prox <= t5;
                    when JN =>
                        if (n_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '0'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '1';
                            
                            temp_prox <= t5;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '0'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '1';
                            
                            temp_prox <= t5;
                        end if;    
                end case;
            when t5 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '1'; 
                        sel <= '1'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                        temp_prox <= t6;
                    when JMP =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '1'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0';
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                        temp_prox <= t0;
                    when JN =>
                        if (n_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '1'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t0;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            cargaacc <= '0'; 
                            incPC <= '0'; 
                            cargaPC <= '1'; 
                            cargaREM <= '0'; 
                            sel <= '0'; 
                            cargaRI <= '0'; 
                            cargaNZ <= '0'; 
                            selULA <= "000"; 
                            wr <= '0'; 
                            rd <= '0';
                            
                            temp_prox <= t0;
                        end if; 
                end case;
            when t6 =>
                cargaacc <= '0'; 
                incPC <= '0'; 
                cargaPC <= '0'; 
                cargaREM <= '0'; 
                sel <= '0'; 
                cargaRI <= '0'; 
                cargaNZ <= '0'; 
                selULA <= "000"; 
                wr <= '0'; 
                rd <= '1';
                
                temp_prox <= t7;
            when t7 =>
                case (inst_atual) is
                    when STA =>
                        cargaacc <= '0'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '0'; 
                        selULA <= "000"; 
                        wr <= '1'; 
                        rd <= '0';
                        
                    when LDA =>
                        cargaacc <= '1'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '1'; 
                        selULA <= "100";
                        wr <= '0'; 
                        rd <= '0';
                        
                    when ADD =>
                        cargaacc <= '1';
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '1'; 
                        selULA <= "000"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                    when OR_ =>
                        cargaacc <= '1'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '1'; 
                        selULA <= "010"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                    when AND_ =>
                        cargaacc <= '1'; 
                        incPC <= '0'; 
                        cargaPC <= '0'; 
                        cargaREM <= '0'; 
                        sel <= '0'; 
                        cargaRI <= '0'; 
                        cargaNZ <= '1'; 
                        selULA <= "001"; 
                        wr <= '0'; 
                        rd <= '0';
                        
                end case;
                temp_prox <= t0;
            when Halt =>
                cargaacc <= '0'; 
                incPC <= '0'; 
                cargaPC <= '0'; 
                cargaREM <= '0'; 
                sel <= '0'; 
                cargaRI <= '0'; 
                cargaNZ <= '0'; 
                selULA <= "000"; 
                wr <= '0'; 
                rd <= '0';

                temp_prox <= Halt;
        end case;
    end process;

end Behavioral;