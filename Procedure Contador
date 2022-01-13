CREATE OR REPLACE FUNCTION fnc_afastamento (p_cadastro number, p_data DATE) return number is

CURSOR C_DADOS IS

SELECT numcad
, datafa
, datter
FROM R0AFA
WHERE datter IS NOT null
AND numcad = p_cadastro
AND sitafa IN (3, 4, 53, 54)
ORDER BY 1;

retorna NUMBER(1);

vcursor_dados  C_DADOS%rowtype;

BEGIN

    OPEN  C_DADOS;
     loop
        fetch C_DADOS into vcursor_dados;
        exit when C_DADOS%notfound;
        IF p_data BETWEEN vcursor_dados.datafa AND vcursor_dados.datter THEN
        SELECT (1 + Nvl(retorna, 0)) INTO retorna FROM dual;
        ELSE SELECT (0 + Nvl(retorna, 0)) INTO retorna FROM dual;
        END IF;

    end loop;
    CLOSE C_DADOS;
   RETURN retorna;

    END;
/
