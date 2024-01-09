LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath_neander is
    Port(
        clk, reset: in std_logic;
        cargaacc, incPC, cargaPC, cargaREM, sel, cargaRI, cargaNZ: in std_logic;
        selULA: in std_logic_vector (2 downto 0);
        dado_saida_mem: in std_logic_vector (7 downto 0);

        end_rem, dado_acumulador: out std_logic_vector (7 downto 0);
        instrucao: out std_logic_vector (7 downto 0);
        n_flag, z_flag: out std_logic;

    );
end datapath_neander;

architecture Behavioral of datapath_neander is

    signal acumulador, pc, registrador_mem, reg_instrucao
           ula: std_logic_vector (7 downto 0);

    -- O mux não precisa porque eu posso selecionar direto (lembra disso, não sei descrever)
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            pc <= "00000000";
        else
            if (rising_edge(clk)) then
                -- Trecho de implementação do PC
                if (cargaPC = '1') then
                    pc <= dado_saida_mem;
                else if (incPC = '1') then
                    pc <= pc + 1;
                end if;

                -- Implementação acumulador
                if (cargaacc = '1') then 
                    acumulador <= ula;
                end if;

                -- Implementação ULA
                case (selULA) is
                    when "000" =>
                        ula <= acumulador + dado_saida_mem;
                    when "001" =>
                        ula <= acumulador and dado_saida_mem;
                    when "010" =>
                        ula <= acumulador or dado_saida_mem;
                    when "011" =>
                        ula <= not X;
                    when "100" =>
                        ula <= dado_saida_mem;
                    end case;
                
                -- Implementação REM
                if (cargaREM = '1') then
                    if (sel = '0') then
                        reg_instrucao <= pc;
                    else
                        reg_instrucao <= dado_saida_mem;
                    end if;
                end if;

                -- Implementação RI
                if (cargaRI = '1') then
                    reg_instrucao <= dado_saida_mem;
                end if;

                -- Implementação flags
                if (ula(7) = '1') then
                    n_flag <= '1';
                else
                    n_flag <= '0';
                end if;

                if (ula = "00000000") then
                    z_flag <= '1';
                else
                    z_flag <= '0';
                end if;

            end if;
        end if;
    end process;

    end_rem <= registrador_rem;
    dado_acumulador <= acumulador;
    instrucao <= reg_instrucao;

end Behavioral; 
