----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2024 11:47:53
-- Design Name: 
-- Module Name: datapath_neander - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath_neander is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cargaacc : in STD_LOGIC;
           incPC : in STD_LOGIC;
           cargaPC : in STD_LOGIC;
           cargaREM : in STD_LOGIC;
           sel : in STD_LOGIC;
           cargaRI : in STD_LOGIC;
           cargaNZ : in STD_LOGIC;
           selULA : in STD_LOGIC_VECTOR (2 downto 0);
           dado_saida_mem : in STD_LOGIC_VECTOR (7 downto 0);
           end_rem : out STD_LOGIC_VECTOR (7 downto 0);
           dado_acumulador : out STD_LOGIC_VECTOR (7 downto 0);
           instrucao : out STD_LOGIC_VECTOR (7 downto 0);
           n_flag : out STD_LOGIC;
           z_flag : out STD_LOGIC);
end datapath_neander;

architecture Behavioral of datapath_neander is

    signal acumulador, pc, registrador_mem, reg_instrucao, ula: std_logic_vector (7 downto 0);

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
                elsif (incPC = '1') then
                    pc <= pc + '1';
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
                        ula <= not acumulador;
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

    end_rem <= registrador_mem;
    dado_acumulador <= acumulador;
    instrucao <= reg_instrucao;

end Behavioral; 
