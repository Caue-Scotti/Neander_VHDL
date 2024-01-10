LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity unidade_controle is
    Port(
        clk, reset: in std_logic;
        n_flag, z_flag: in std_logic;
        instrucao: in std_logic_vector (7 downto 0);

        cargaacc, incPC, cargaPC, cargaREM, sel, cargaRI, cargaNZ, wr, rd: out std_logic;
        selULA: out std_logic_vector (2 downto 0);
    );
end unidade_controle;

architecture Behavioral of unidade_controle is
    
    type temp is (t0, t1, t2, t3, t4, t5, t6, t7, Halt);

    signal inst_atual, inst_prox: std_logic_vector (7 downto 0);
    signal temp_atual, temp_prox: temp;

    constant STA: std_logic_vector (7 downto 0) := "00010000";
    constant LDA: std_logic_vector (7 downto 0) := "00100000"
    constant ADD: std_logic_vector (7 downto 0) := "00110000"
    constant OR_: std_logic_vector (7 downto 0) := "01000000"
    constant AND_: std_logic_vector (7 downto 0) := "01010000"
    constant NOT_: std_logic_vector (7 downto 0) := "01100000"
    constant JMP: std_logic_vector (7 downto 0) := "10000000"
    constant JN: std_logic_vector (7 downto 0) := "10010000"
    constant JZ: std_logic_vector (7 downto 0) := "10100000"
    constant NOP: std_logic_vector (7 downto 0) := "00000000"
    constant HLT: std_logic_vector (7 downto 0) := "11110000"

begin
    process(clk, reset)
    begin
        if (reset = '1') then
            temp_atual <=  t0;
        else
            if (rising_edge(clk)) then
                if (temp_prox = t0) then
                    inst_atual <= instrucao;
                else
                    inst_atual <= inst_prox;
                    temp_atual <= temp_prox;
                end if;
            end if;
        end if;
    end process;

    process(inst_atual, temp_atual)
    begin
        case (temp_atual) is
            when t0 =>
                sel <= '0';
                cargaREM <= '1';
                temp_prox <= t1;
            when t1 =>
                rd <= '1';
                incPC <= '1';
                temp_prox <= t2;
            when t2 =>
                cargaRI <= '1';
                temp_prox <= t3;
            when t3 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ or JMP =>
                        sel <= '0';
                        cargaREM <= '1';
                        temp_prox <= t4;
                    when NOT_ =>
                        selULA <= "011";
                        cargaacc <= '1';
                        cargaNZ <= '1';
                        temp_prox <= t0;
                    when JN =>
                        if (n_flag = '1') then
                            sel <= '0';
                            cargaREM <= '1';
                            temp_prox <= t4;
                        else
                            incPC <= '1';
                            temp_prox <= t0;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            sel <= '0';
                            cargaREM <= '1';
                            temp_prox <= t4;
                        else
                            incPC <= '1';
                            temp_prox <= t0;
                        end if;
                    when NOP =>
                        temp_prox <= t0;
                    when HLT =>
                        temp_prox <= Halt;
                end case;
            when t4 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ =>
                        rd <= '1';
                        incPC <= '1';
                        temp_prox <= t5;
                    when JMP =>
                        rd <= '1';
                        temp_prox <= t5;
                    when JN =>
                        if (n_flag = '1') then
                            rd <= '1';
                            temp_prox <= t5;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            rd <= '1';
                            temp_prox <= t5;
                        end if;    
                end case;
            when t5 =>
                case (inst_atual) is
                    when STA or LDA or ADD or OR_ or AND_ =>
                        sel <= '1';
                        cargaREM <= '1';
                        temp_prox <= t6;
                    when JMP =>
                        cargaPC <= '1';
                        temp_prox <= t0;
                    when JN =>
                        if (n_flag = '1') then
                            cargaPC <= '1';
                            temp_prox <= t0;
                        end if;
                    when JZ =>
                        if (z_flag = '1') then
                            cargaPC <= '1';
                            temp_prox <= t0;
                        end if; 
                end case;
            when t6 =>
                rd <= '1';
                temp_prox <= t7;
            when t7 =>
                case (inst_atual) is
                    when STA =>
                        wr <= '1';
                    when LDA =>
                        selULA <= "100";
                        cargaacc <= '1';
                        cargaNZ <= '1';
                    when ADD =>
                        selULA <= "000";
                        cargaacc <= '1';
                        cargaNZ <= '1';
                    when OR_ =>
                        selULA <= "010";
                        cargaacc <= '1';
                        cargaNZ <= '1';
                    when AND_ =>
                        selULA <= "001";
                        cargaacc <= '1';
                        cargaNZ <= '1';
                end case;
                temp_prox <= t0;
            when Halt =>
                temp_prox <= Halt;
        end case;
    end process;

end Behavioral;