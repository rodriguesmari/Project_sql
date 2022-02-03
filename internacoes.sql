select atendimento.cd_atendimentonto
     , paciente.nm_paciente
     , prestador.nm_prestador
     , nvl(leito.ds_resumo, leito.ds_leito) ds_leito
     , convenio.nm_convenio
     , tipo_internacao.ds_tipo_internacao
     , dba.fnc_mv_recupera_data_hora(atendimento.dt_atendimentonto,atendimento.hr_atendimentonto) dt_atendimentonto
   from dba.atendimento
     , dba.prestador
     , dba.convenio
     , dba.paciente
     , dba.tipo_internacao
     , dba.leito
     , dba.empresa_convenio
 where empresa_convenio.cd_convenio       = convenio.cd_convenio
   and atendimento.cd_prestador              = prestador.cd_prestador
   and atendimento.cd_convenio               = convenio.cd_convenio
   and paciente.cd_paciente               = atendimento.cd_paciente
   and atendimento.cd_leito                  = leito.cd_leito
   and tipo_internacao.cd_tipo_internacao = atendimento.cd_tipo_internacao
   and atendimento.tp_atendimentonto            = 'I'
   AND To_Char(atendimento.hr_atendimentonto,'hh24:mi:ss') <= '23:59:59'
 UNION
select atendimento.cd_atendimentonto
     , paciente.nm_paciente
     , prestador.nm_prestador
     , nvl(leito.ds_resumo, leito.ds_leito) ds_leito
     , convenio.nm_convenio
     , tipo_internacao.ds_tipo_internacao
     , dba.fnc_mv_recupera_data_hora(atendimento.dt_atendimentonto,atendimento.hr_atendimentonto) dt_atendimentonto
   from dba.atendimento
     , dba.prestador
     , dba.convenio
     , dba.paciente
     , dba.tipo_internacao
     , dba.leito
     , dba.empresa_convenio
 where empresa_convenio.cd_convenio       = convenio.cd_convenio
   and atendimento.cd_prestador              = prestador.cd_prestador
   and atendimento.cd_convenio               = convenio.cd_convenio
   and paciente.cd_paciente               = atendimento.cd_paciente
   and atendimento.cd_leito                  = leito.cd_leito
   and tipo_internacao.cd_tipo_internacao = atendimento.cd_tipo_internacao
   and atendimento.tp_atendimentonto            = 'I'

 UNION

select atendimento.cd_atendimentonto
     , paciente.nm_paciente
     , prestador.nm_prestador
     , nvl(leito.ds_resumo, leito.ds_leito) ds_leito
     , convenio.nm_convenio
     , tipo_internacao.ds_tipo_internacao
     , dba.fnc_mv_recupera_data_hora(atendimento.dt_atendimentonto,atendimento.hr_atendimentonto) dt_atendimentonto
   from dba.atendimento
     , dba.prestador
     , dba.convenio
     , dba.paciente
     , dba.tipo_internacao
     , dba.leito
     , dba.empresa_convenio
 where empresa_convenio.cd_convenio       = convenio.cd_convenio
   and atendimento.cd_prestador              = prestador.cd_prestador
   and atendimento.cd_convenio               = convenio.cd_convenio
   and paciente.cd_paciente               = atendimento.cd_paciente
   and atendimento.cd_leito                  = leito.cd_leito
   and tipo_internacao.cd_tipo_internacao = atendimento.cd_tipo_internacao
   and atendimento.tp_atendimentonto            = 'I'
   ORDER BY dt_atendimentonto
        , nm_convenio
        , nm_paciente
