LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY project_reti_logiche IS
    PORT (
        i_clk : IN STD_LOGIC;
        i_rst : IN STD_LOGIC;
        i_start : IN STD_LOGIC;
        i_w : IN STD_LOGIC;
        o_z0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_z3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        i_mem_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mem_we : OUT STD_LOGIC;
        o_mem_en : OUT STD_LOGIC;
        o_done : OUT STD_LOGIC
    );
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS
    TYPE S IS (FIRST_BIT, SECOND_BIT, ADDRESS, DATA, OUTPUT_REG, RELEASE_DATA);
    SIGNAL cur_state, next_state : S;
    SIGNAL l1, l2, l3, l4, sel, l5, l6, l7, j, reg5, reg6 : STD_LOGIC;
    SIGNAL reg1, reg2, reg3, reg4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- j vale 1 solo quando smetto di prendere il dato,cioè nello stato OUTPUT_REG, quando rimetto en=0
    l1 <= NOT reg5 AND NOT reg6 AND j;
    l2 <= NOT reg5 AND reg6 AND j;
    l3 <= reg5 AND NOT reg6 AND j;
    l4 <= reg5 AND reg6 AND j;
    --
    --
    PROCESS (i_clk, i_rst)
    BEGIN
        IF (i_rst = '1') THEN
            cur_state <= FIRST_BIT;
        ELSIF i_clk'event AND i_clk = '1' THEN
            cur_state <= next_state;
        END IF;
    END PROCESS;
    --
    --
    PROCESS (cur_state, i_start) BEGIN
        next_state <= cur_state;
        CASE cur_state IS
            WHEN FIRST_BIT =>
                IF i_start = '1' THEN
                    next_state <= SECOND_BIT;
                ELSE
                    next_state <= FIRST_BIT;
                END IF;
            WHEN SECOND_BIT => next_state <= ADDRESS;
            WHEN ADDRESS => IF i_start = '1' THEN
                next_state <= ADDRESS;
            ELSE
                next_state <= DATA;
        END IF;
        WHEN DATA => next_state <= OUTPUT_REG;
        WHEN OUTPUT_REG => next_state <= RELEASE_DATA;
        WHEN RELEASE_DATA => next_state <= FIRST_BIT;
    END CASE;
END PROCESS;
--
--
PROCESS (cur_state) BEGIN
    l5 <= '0';
    l6 <= '0';
    l7 <= '0';
    j <= '0';
    o_mem_we <= '0';
    o_mem_en <= '0';
    sel <= '0';

    CASE cur_state IS
        WHEN FIRST_BIT =>
            l5 <= '1';
        WHEN SECOND_BIT => l5 <= '0';
            l6 <= '1';
        WHEN ADDRESS =>
            l6 <= '0';
            l7 <= '1';
        WHEN DATA =>
            l7 <= '0';
            o_mem_en <= '1';
        WHEN OUTPUT_REG =>
            j <= '1';
            o_mem_en <= '0';
        WHEN RELEASE_DATA =>
            j <= '0';
            sel <= '1';
    END CASE;
END PROCESS;
--
o_mem_addr <= temp;

--
PROCESS (sel, i_rst, i_clk) BEGIN

    IF (sel = '0') THEN
        o_z0 <= "00000000";
        o_z1 <= "00000000";
        o_z2 <= "00000000";
        o_z3 <= "00000000";
    ELSE
        o_z0 <= reg1;
        o_z1 <= reg2;
        o_z2 <= reg3;
        o_z3 <= reg4;
    END IF;

    IF (i_rst = '1') THEN
        reg1 <= "00000000";
        reg2 <= "00000000";
        reg3 <= "00000000";
        reg4 <= "00000000";
    END IF;

    IF (i_clk'event AND i_clk = '1') THEN
        IF (l1 = '1') THEN
            reg1 <= i_mem_data;
        END IF;
        IF (l2 = '1') THEN
            reg2 <= i_mem_data;
        END IF;
        IF (l3 = '1') THEN
            reg3 <= i_mem_data;
        END IF;
        IF (l4 = '1') THEN
            reg4 <= i_mem_data;
        END IF;
    END IF;
END PROCESS;
--
o_done <= sel;
--
PROCESS (i_rst, sel, i_clk) BEGIN

    IF (i_rst = '1') THEN --azzero i tre registri 
        reg5 <= '0';
        reg6 <= '0';
        temp <= "0000000000000000";
    END IF;

    IF (sel = '1') THEN --se done=1 azzero o_mem_addr perchè non mi serve più
        temp <= "0000000000000000";
    END IF;

    IF (i_clk'event AND i_clk = '1') THEN
        IF (l5 = '1') THEN --Z
            reg5 <= i_w;

        ELSIF (l6 = '1') THEN --Z
            reg6 <= i_w;

        ELSIF (l7 = '1' AND i_start = '1') THEN --address
            temp <= temp(14 DOWNTO 0) & i_w;
        END IF;
    END IF;
END PROCESS;

END Behavioral;