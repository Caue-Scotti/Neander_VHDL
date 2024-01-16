LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity neander is
    Port(
        clk, reset: in std_logic;
        display: out std_logic_vector (7 downto 0);
    );
end neander;

architecture Behavioral of neander is

    component bram is
        Port (
            clka : in std_logic;
            wea : in std_logic_vector (0 downto 0);
            addra : in std_logic_vector (7 downto 0);
            dina : in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (7 downto 0);
        );
    end component;

    component datapath_neander is
        Port(
            clk : in STD_LOGIC;
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
            z_flag : out STD_LOGIC;
        );
    end component;

    component unidade_controle is
        Port(
            clk, reset: in std_logic;
            n_flag, z_flag: in std_logic;
            instruc: in std_logic_vector (7 downto 0);
    
            cargaacc, incPC, cargaPC, cargaREM, sel, cargaRI, cargaNZ, wr, rd: out std_logic;
            selULA: out std_logic_vector (2 downto 0);
        );
    end component;

    signal data_out_mem: std_logic_vector (7 downto 0);

    signal end_rem_datapath, acumulador_datapath, instruc_datapath: std_logic_vector (7 downto 0);
    signal n_flag_datapath, z_flag_datapath: std_logic;

    signal cargaacc_uc, incPC_uc, cargaPC_uc, cargaREM_uc, sel_uc, cargaRI_uc, cargaNZ_uc, wr_uc, rd_uc: std_logic;
    signal selULA_uc: std_logic_vector (7 downto 0);

begin

    mem: bram port map(

        clk => clka,
        wr_uc => wea,
        end_rem_datapath => addra,
        acumulador_datapath => dina,
        douta => data_out_mem

    );

    datapath: datapath_neander port map(

        clk => clk,
        reset => reset,
        cargaacc_uc => cargaacc,
        incPC_uc => incPC,
        cargaPC_uc => cargaPC,
        cargaREM_uc => cargaREM,
        sel_uc => sel,
        cargaRI_uc => cargaRI,
        cargaNZ_uc => cargaNZ,
        selULA_uc => selULA,
        data_out_mem => dado_saida_mem,
        end_rem => end_rem_datapath,
        dado_acumulador => acumulador_datapath,
        instrucao => instruc_datapath,
        n_flag => n_flag_datapath,
        z_flag => z_flash_datapath

    );

    uc: unidade_controle port map(

        clk => clk;
        reset => reset;
        n_flag_datapath => n_flag,
        z_flag_datapath => z_flag,
        instruc_datapath => instruc,
        cargaacc => cargaacc_uc,
        incPC => incPC_uc,
        cargaPC => cargaPC_uc,
        cargaREM => cargaREM_uc,
        sel => sel_uc,
        cargaRI => cargaRI_uc,
        cargaNZ => cargaNZ_uc,
        wr => wr_uc,
        rd => rd_uc

    );

end Behavioral;