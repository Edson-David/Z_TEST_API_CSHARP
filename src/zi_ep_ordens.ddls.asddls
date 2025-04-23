@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composição das Ordens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_EP_ORDENS
  as select from ZR_EP_ORDENS
{
  key Ordem,
      Maquina,
      Setor,
      Descricao,
      Status
}
