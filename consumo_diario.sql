EXEC dba.pkg_mv.atribui_empresa(1);
SELECT resultado.cd_estoque
     , resultado.ds_estoque
     , produto.cd_produto
     , produto.ds_produto
     , Verif_ds_unid_prod (produto.cd_produto) ds_unidade
     , Sum(resultado.qt_consumo)qt_consumo
     , Decode(Sum(resultado.qt_dias_periodo),0,1,Sum(resultado.qt_dias_periodo))qt_dias_periodo
     , Trunc(Sum(resultado.qt_consumo) / Decode(Sum(resultado.qt_dias_periodo),0,1,Sum(resultado.qt_dias_periodo))) qt_consumo_medio
     , Nvl(est_pro.qt_estoque_atual,0) / verif_vl_fator_prod (produto.cd_produto) qt_estoque_atual
     , Trunc(Nvl(est_pro.qt_estoque_atual,0) / verif_vl_fator_prod (produto.cd_produto) / Sum(resultado.qt_consumo) / Decode(Sum(resultado.qt_dias_periodo),0,1,Sum(resultado.qt_dias_periodo))) qt_dias_previsao
  FROM (SELECT max (mvto_estoque.dt_mvto_estoque ) - Min (mvto_estoque.dt_mvto_estoque ) qt_dias_periodo
             , estoque.cd_estoque
             , estoque.ds_estoque
             , produto.cd_produto
             , trunc (sum (decode (mvto_estoque.tp_mvto_estoque, 'D', -1, 'C', -1, 'N', -1, 1) * ( itmvto_estoque.qt_movimentacao * uni_pro.vl_fator ) ) , 4) / Verif_vl_fator_prod (produto.cd_produto) qt_consumo
             , trunc (sum (decode (mvto_estoque.tp_mvto_estoque, 'D', -1, 'C', -1, 'N', -1, 1) * ( itmvto_estoque.qt_movimentacao * uni_pro.vl_fator ) * ( Verif_vl_custo_medio (produto.cd_produto , mvto_estoque.dt_mvto_estoque, 'H'/* histórico*/ , produto.vl_custo_medio, mvto_estoque.hr_mvto_estoque ) )), 4) Vl_Custo_Periodo
          FROM dba.mvto_estoque
             , dba.itmvto_estoque
             , dba.produto
             , dba.classe
             , dba.sub_clas
             , dba.especie
             , dba.estoque
             , dba.uni_pro
         WHERE mvto_estoque.cd_mvto_estoque         = itmvto_estoque.cd_mvto_estoque
           AND itmvto_estoque.cd_produto            = produto.cd_produto
           AND produto.cd_especie                   = especie.cd_especie
           AND produto.cd_classe                    = classe.cd_classe
           AND especie.cd_especie                   = classe.cd_especie
           AND especie.cd_especie                   = sub_clas.cd_especie
           AND classe.cd_classe                     = sub_clas.cd_classe
           AND produto.cd_sub_cla                   = sub_clas.cd_sub_cla
           AND itmvto_estoque.cd_uni_pro            = uni_pro.cd_uni_pro
           AND mvto_estoque.cd_estoque              = estoque.cd_estoque
           AND produto.sn_mestre                    <> 'S'
           AND produto.tp_ativo                     = 'S'
           AND mvto_estoque.tp_mvto_estoque         IN ( 'D','C' ,'S' ,'P' ,DECODE ( estoque.tp_estoque, 'D', 'T', '#') )
           AND estoque.cd_multi_empresa             = pkg_mv.le_empresa
           AND estoque.cd_estoque                   = 4
           AND produto.cd_produto                   =  5
           AND TRUNC (mvto_estoque.dt_mvto_estoque) >= trunc(sysdate) - 4
           AND TRUNC (mvto_estoque.dt_mvto_estoque) <= trunc(sysdate)
         GROUP BY produto.cd_produto,estoque.cd_estoque,estoque.ds_estoque
         UNION ALL
        SELECT max (mvto_estoque.dt_mvto_estoque ) - Min (mvto_estoque.dt_mvto_estoque ) qt_dias_periodo
             , estoque.cd_estoque
             , estoque.ds_estoque
             , produto.cd_produto
             , trunc (sum (decode (mvto_estoque.tp_mvto_estoque, 'T', 1, 0) * ( itmvto_estoque.qt_movimentacao * uni_pro.vl_fator ) * ( -1 )), 4) / Verif_vl_fator_prod (produto.cd_produto) QT_CONSUMO
             , trunc (sum (decode (mvto_estoque.tp_mvto_estoque, 'T', 1, 0) * ( itmvto_estoque.qt_movimentacao * uni_pro.vl_fator ) * ( Verif_vl_custo_medio (produto.cd_produto , mvto_estoque.dt_mvto_estoque, 'H', produto.vl_custo_medio, mvto_estoque.hr_mvto_estoque ) ) * ( -1 )), 4) vl_custo_periodo
          FROM dba.mvto_estoque
             , dba.itmvto_estoque
             , dba.produto
             , dba.classe
             , dba.sub_clas
             , dba.especie
             , dba.estoque
             , dba.uni_pro
         WHERE mvto_estoque.cd_mvto_estoque         = itmvto_estoque.cd_mvto_estoque
           AND itmvto_estoque.cd_produto            = produto.cd_produto
           AND produto.cd_especie                   = especie.cd_especie
           AND produto.cd_classe                    = classe.cd_classe
           AND especie.cd_especie                   = classe.cd_especie
           AND especie.cd_especie                   = sub_clas.cd_especie
           AND classe.cd_classe                     = sub_clas.cd_classe
           AND produto.cd_sub_cla                   = sub_clas.cd_sub_cla
           AND itmvto_estoque.cd_uni_pro            = uni_pro.cd_uni_pro
           AND mvto_estoque.cd_estoque              = estoque.cd_estoque
           AND produto.sn_mestre                    <> 'S'
           AND produto.tp_ativo                     = 'S'
           AND mvto_estoque.tp_mvto_estoque         IN ( DECODE (estoque.tp_estoque, 'D', 'T', '#') )
           AND estoque.cd_multi_empresa             = pkg_mv2000.le_empresa
           AND estoque.cd_estoque                   = 4
           AND produto.cd_produto                   = 12
           AND TRUNC (mvto_estoque.dt_mvto_estoque) >= trunc(sysdate) - 4
           AND TRUNC (mvto_estoque.dt_mvto_estoque) <= trunc(sysdate)
         GROUP BY produto.cd_produto,estoque.cd_estoque,estoque.ds_estoque
       ) resultado
     , dba.produto
     , dba.est_pro
 WHERE RESULTADO.cd_produto = produto.cd_produto
   AND resultado.cd_produto = est_pro.cd_produto(+)
   AND resultado.cd_estoque = est_pro.cd_estoque(+)
   AND EXISTS (SELECT empresa_produto.cd_produto
                 FROM dba.empresa_produto
                WHERE empresa_produto.cd_produto = produto.cd_produto
                  AND cd_multi_empresa = pkg_mv.le_empresa
               )
 GROUP BY resultado.cd_estoque
     , resultado.ds_estoque
     , produto.cd_produto
     , produto.ds_produto
     , Nvl(est_pro.qt_estoque_atual,0) / verif_vl_fator_prod (produto.cd_produto)
 ORDER BY produto.ds_produto
