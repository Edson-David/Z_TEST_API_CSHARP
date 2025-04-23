@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Basic Ordens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_EP_ORDENS
  as select from ztep_ordens
{
  key ordem as Ordem,
  maquina   as Maquina,
  setor     as Setor,
  descricao as Descricao,
  status    as Status
}
